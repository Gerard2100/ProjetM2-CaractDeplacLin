--------------------------------------------------------------------
-- Université de Bordeaux
-- Projet M2 ISE
-- MARTIN Léo & KALIFA Léo
-- Module : write_eeprom - Behavioral
-- Description : écrire dans l'eeprom les valeurs de hauteur et DAC
--------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity write_eeprom is
    Port ( addr : in STD_LOGIC_VECTOR (5 downto 0);     -- adresse sur 6 bits
           data : in STD_LOGIC_VECTOR (15 downto 0);    -- données �  stocker (hauteur ou tension)
           bp_encodeur : in STD_LOGIC;                  -- Appui sur le BP encodeur pour commencer l'écriture
           reset : in STD_LOGIC;                        -- reset synchrone sur front montant
           clk : in STD_LOGIC;                          -- horloge 100 MHz
           DO : in STD_LOGIC;                           -- broche de sortie de l'eeprom, indique la fin d'une écriture
           CS : out STD_LOGIC;                          -- signal d'activation de l'eeprom, actif niveau haut
           SK : out STD_LOGIC;                          -- horloge de l'eeprom T = 1 µs
           DI : out STD_LOGIC);                         -- entrée de l'eeprom
end write_eeprom;

architecture Behavioral of write_eeprom is

-- SIGNAUX INTERNES -- 
-- signaux pour la machine �  états finie
type state_type is (idle, waitForCS, highSK, lowSK, endWrite); -- différents états de la FSM
signal state : state_type;

-- signaux pour le compteur de période 1 µs et 500 ns
constant moduloHalfPeriod : integer := 50;
constant moduloPeriod : integer := 100;
signal cpt1micro : integer range 0 to moduloPeriod - 1;
signal endHalfPeriod : std_logic;
signal endPeriod : std_logic;
signal Cssig: std_logic;

-- signaux pour générer TCSS
constant moduloTCSS : integer := 10;
signal cptTCSS : integer range 0 to moduloTCSS - 1;
signal endTCSS : std_logic;

-- signaux pour générer TWP 
constant moduloTWP : integer := 300000;
signal cptTWP : integer range 0 to moduloTWP - 1;
signal endTWP : std_logic;

-- signaux pour le registre �  décalage
signal DI_reg : std_logic_vector (24 downto 0);

signal bitIndex : integer range 0 to 24;

constant WRITE : std_logic_vector (2 downto 0) := "101";

begin

    FSM : process(clk)
    begin
        if clk'event and clk='1' then
             if reset = '1' then 
                state <= idle;  
            else
                case state is
                    when idle =>        if bp_encodeur = '1' then
                                            state <= waitForCS;
                                            CS <= '1';
                                        end if; 
                    when waitForCS =>   if endTCSS = '1' then
                                            state <= highSK;
                                            --bitIndex <= 0;
                                        end if;
                    when highSK =>      if endHalfPeriod = '1' then
                                            state <= lowSK;
                                        end if;
                    when lowSK =>       if endPeriod = '1' and bitIndex = 0 then
                                            state <= endWrite;
                                        elsif endPeriod = '1' and bitIndex /= 1  then
                                            state <= highSK;
                                        end if;
                    when endWrite =>    if endTWP = '1' then
                                            state <= idle;
                                        end if;
                end case;
            end if;
        end if;
    end process;

    outputDecodeSK : SK <= '1' when state = highSK else '0';

    shiftreg_proc : process (clk)
    begin
        if clk'event and clk = '1' then
            if reset = '1' or state = idle then
                DI_reg (24 downto 22) <= WRITE;
                DI_reg (21 downto 16) <= addr;
                DI_reg (15 downto 0) <= data;
                bitIndex <= 24;
            elsif endHalfPeriod = '1' and state = lowSK then
                DI_reg <= DI_reg(23 downto 0) & '0';
                bitIndex <= bitIndex - 1;
            end if;
        end if;
    end process;

    DI_proc : DI <= DI_reg(24);

    cpt1micro_proc : process (clk)
    begin
        if clk'event and clk = '1' then
            if reset = '1' or state = idle then
                cpt1micro <= 0;
                endHalfPeriod <= '0';
                endPeriod <= '0';
            elsif endTCSS = '1' then
                case cpt1micro is 
                    when moduloHalfPeriod - 2 =>    cpt1micro <= cpt1micro + 1;
                                                    endHalfPeriod <= '1';
                                                    endPeriod <= '0';
                    when moduloPeriod - 2 =>        cpt1micro <= moduloPeriod - 1;
                                                    endHalfPeriod <= '0';
                                                    endPeriod <= '1';
                    when moduloPeriod - 1 =>        cpt1micro <= 0;
                                                    endHalfPeriod <= '0';
                                                    endPeriod <= '1';
                    when others =>                  cpt1micro <= cpt1micro + 1;
                                                    endHalfPeriod <= '0';
                                                    endPeriod <= '0';
                end case;
            end if;
        end if;
    end process;

    cptTCSS_proc : process (clk)
    begin
        if clk'event and clk = '1' then
            if reset = '1' or state = idle then
                cptTCSS <= 0;
                endTCSS <= '0';
            elsif bp_encodeur = '1' and state = waitForCS then
                case cptTCSS is
                    when moduloTCSS - 2 =>  cptTCSS <= moduloTCSS - 1;
                                            endTCSS <= '1';
                    when moduloTCSS - 1 =>  cptTCSS <= 0;
                                            endTCSS <= '0';
                    when others =>          cptTCSS <= cptTCSS + 1;
                                            endTCSS <= '0';
                end case;
            end if;
        end if;
    end process;

    cptTWP_proc : process (clk)
    begin
        if clk'event and clk = '1' then
            if reset = '1' or state = idle then
                cptTWP <= 0;
                endTWP <= '0';
            elsif bitIndex = 0 and state = endWrite then
                case cptTWP is
                    when moduloTWP - 2 =>   cptTWP <= moduloTWP - 1;
                                            endTWP <= '1';
                    when moduloTWP - 1 =>   cptTWP <= 0;
                                            endTWP <= '0';
                    when others =>          cptTWP <= cptTWP + 1;
                                            endTWP <= '0';
                end case;
            end if;
        end if;
    end process;    
                                  
end Behavioral;
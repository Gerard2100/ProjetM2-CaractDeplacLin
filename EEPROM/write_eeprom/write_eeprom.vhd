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
           data : in STD_LOGIC_VECTOR (15 downto 0);    -- données à stocker (hauteur ou tension)
           write : in STD_LOGIC;                        -- Appui sur le BP encodeur pour commencer l'écriture
           reset : in STD_LOGIC;                        -- reset synchrone sur front montant
           clk : in STD_LOGIC;                          -- horloge 100 MHz
           DO : in STD_LOGIC;                           -- broche de sortie de l'eeprom, indique la fin d'une écriture
           CS : out STD_LOGIC;                          -- signal d'activation de l'eeprom, actif niveau haut
           SK : out STD_LOGIC;                          -- horloge de l'eeprom T = 1 µs
           DI : out STD_LOGIC);                         -- entrée de l'eeprom
end write_eeprom;

architecture Behavioral of write_eeprom is

-- SIGNAUX INTERNES -- 
-- signaux pour la machine à états finie
type state_type is (idle, waitForEndTCSS, highSK, lowSK, endWrite); -- différents états de la FSM
signal state : state_type;

-- signaux pour le compteur de période 500 ns
constant moduloPeriod500ns : integer := 50;
signal cpt500ns : integer range 0 to moduloPeriod500ns - 1;
signal endPeriod : std_logic;

-- signaux pour le registre à décalage
signal DI_reg : std_logic_vector (24 downto 0);
signal bitIndexDI : integer range 0 to 24;

-- instruction d'écriture de l'eeprom
constant W : std_logic_vector (2 downto 0) := "101";

begin
    
    -- Machine à états finie
    FSM : process(clk) 
    begin
        if clk'event and clk='1' then
            if reset = '1' then 
                state <= idle;  
            else
                case state is
                    when idle =>            if write = '1' then
                                                state <= waitForEndTCSS;
                                            end if; 
                    when waitForEndTCSS =>  if endPeriod = '1' then
                                                state <= highSK;
                                            end if;
                    when highSK =>          if endPeriod = '1' then
                                                state <= lowSK;
                                            end if;
                    when lowSK =>           if endPeriod = '1' and bitIndexDI = 0 then
                                                state <= endWrite;
                                            elsif endPeriod = '1' and bitIndexDI /= 0 then
                                                state <= highSK;
                                            end if;
                    when endWrite =>        if DO = '1' then
                                                state <= idle;
                                            end if;
                end case;
            end if;
        end if;
    end process;
    
    outputDecodeCS : CS <= '0' when state = idle or state = endWrite else '1';

    outputDecodeSK : SK <= '1' when state = highSK else '0';
    
    shiftreg_proc : process (clk) -- registre à décalage 
    begin
        if clk'event and clk = '1' then
            if reset = '1' or state = idle then
                DI_reg (24 downto 22) <= W;
                DI_reg (21 downto 16) <= addr;
                DI_reg (15 downto 0) <= data;
                bitIndexDI <= 24;
            elsif state = highSK and endPeriod = '1' then
                DI_reg <= DI_reg(23 downto 0) & '0';
                bitIndexDI <= bitIndexDI - 1;
            end if;
        end if;
    end process;
    
    outputDecodeDI : DI <= DI_reg(24);
    
    -- compteur modulo 50 (=> 500 ns)
    cpt500ns_proc : process (clk) 
    begin
        if clk'event and clk = '1' then
            if reset = '1' or state = idle then
                cpt500ns <= 0;
                endPeriod <= '0';
            elsif state = waitForEndTCSS or state = highSK or state = lowSK then
                case cpt500ns is 
                    when moduloPeriod500ns - 2 =>   cpt500ns <= moduloPeriod500ns - 1;
                                                    endPeriod <= '1';
                    when moduloPeriod500ns - 1 =>   cpt500ns <= 0;
                                                    endPeriod <= '0';
                    when others =>                  cpt500ns <= cpt500ns + 1;
                                                    endPeriod <= '0';
                end case;
            end if;
        end if;
    end process; 
                                  
end Behavioral;
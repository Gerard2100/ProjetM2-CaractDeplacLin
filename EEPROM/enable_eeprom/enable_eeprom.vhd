--------------------------------------------------------------------
-- Université de Bordeaux
-- Projet M2 ISE
-- MARTIN Léo & KALIFA Léo
-- Module : enable_eeprom - Behavioral
-- Description : active l'eeprom pour sa première utilisation
--------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity enable_eeprom is
  Port ( clk : in std_logic;
         reset : in std_logic;
         enable : in std_logic;
         CS : out std_logic;
         SK : out std_logic;
         DI :out std_logic);
end enable_eeprom;

architecture Behavioral of enable_eeprom is
-- SIGNAUX INTERNES -- 
-- signaux pour la machine à états finie
type state_type is (idle, waitForEndTCSS, highSK, lowSK, endEWEN); -- différents états de la FSM
signal state : state_type;

-- signaux pour le compteur de période 500 ns
constant moduloPeriod500ns : integer := 50;
signal cpt500ns : integer range 0 to moduloPeriod500ns - 1;
signal endPeriod : std_logic;

-- signaux pour le registre à décalage
signal DI_reg : std_logic_vector (4 downto 0);
signal bitIndexDI : integer range 0 to 8;

-- instruction d'activation de l'eeprom
constant EWEN : std_logic_vector (4 downto 0) := "10011";

begin

    FSM : process(clk)
    begin
        if clk'event and clk='1' then
            if reset = '1' then 
                state <= idle;  
            else
                case state is
                    when idle =>            if enable = '1' then
                                                state <= waitForEndTCSS;
                                            end if; 
                    when waitForEndTCSS =>  if endPeriod = '1' then
                                                state <= highSK;
                                            end if;
                    when highSK =>          if endPeriod = '1' then
                                                state <= lowSK;
                                            end if;
                    when lowSK =>           if endPeriod = '1' and bitIndexDI = 0 then
                                                state <= endEWEN;
                                            elsif endPeriod = '1' and bitIndexDI /= 0 then
                                                state <= highSK;
                                            end if;
                    when endEWEN =>        if endPeriod = '1' then
                                                state <= idle;
                                            end if;
                end case;
            end if;
        end if;
    end process;
    
    outputDecodeCS : CS <= '0' when state = idle or state = endEWEN else '1';

    outputDecodeSK : SK <= '1' when state = highSK else '0';
    
    shiftreg_proc : process (clk)
    begin
        if clk'event and clk = '1' then
            if reset = '1' or state = idle then
                DI_reg  <= EWEN;
                bitIndexDI <= 8;
            elsif state = highSK and endPeriod = '1' then
                DI_reg <= DI_reg(3 downto 0) & '0';
                bitIndexDI <= bitIndexDI - 1;
            end if;
        end if;
    end process;
    
    outputDecodeDI : DI <= DI_reg(4);

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

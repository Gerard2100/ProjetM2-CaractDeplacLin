--------------------------------------------------------------------
-- Université de Bordeaux
-- Projet M2 ISE
-- MARTIN Léo & KALIFA Léo
-- Module : enable_eeprom_tb - Behavioral
-- Description : module de test de enable_eeprom
--------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity enable_eeprom_tb is

end enable_eeprom_tb;

architecture Behavioral of enable_eeprom_tb is

    component enable_eeprom
    Port ( clk : in STD_LOGIC;                  
           reset : in STD_LOGIC;                        
           enable : in STD_LOGIC;                                                    
           CS : out STD_LOGIC;                          
           SK : out STD_LOGIC;                          
           DI : out STD_LOGIC); 
    end component;
    
-- Initialisation à "0" des signaux d'entrées et de sorties
signal t_clk : std_logic := '0';
signal t_reset : std_logic := '0';
signal t_enable : std_logic := '0';
signal t_CS : std_logic := '0';
signal t_SK : std_logic := '0';
signal t_DI : std_logic := '0';

begin
    uut : enable_eeprom
        Port map ( clk => t_clk,
                   reset => t_reset,
                   enable => t_enable,
                   CS => t_CS,
                   SK => t_SK,
                   DI => t_DI);
    
    clk100Mhz : process
    begin
        t_clk <= '0';
        wait for 5 ns;
        t_clk <= '1';
        wait for 5 ns;
    end process;
       
    reset_proc : t_reset <= '1','0' after 10 ns;
    
    enable_proc : t_enable <= '0', '1' after 10 ns, '0' after 20 ns;
    
end Behavioral;

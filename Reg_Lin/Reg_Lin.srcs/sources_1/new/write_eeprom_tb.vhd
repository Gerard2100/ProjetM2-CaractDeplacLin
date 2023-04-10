--------------------------------------------------------------------
-- Université de Bordeaux
-- Projet M2 ISE
-- MARTIN Léo & KALIFA Léo
-- Module : write_eeprom_tb - Behavioral
-- Description : module de test de write_eeprom
--------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity write_eeprom_tb is

end write_eeprom_tb;

architecture Behavioral of write_eeprom_tb is

    component write_eeprom
    Port ( addr : in STD_LOGIC_VECTOR (5 downto 0);     
           data : in STD_LOGIC_VECTOR (15 downto 0);    
           bp_encodeur : in STD_LOGIC;                  
           reset : in STD_LOGIC;                        
           clk : in STD_LOGIC;                          
           DO : in STD_LOGIC;                           
           CS : out STD_LOGIC;                          
           SK : out STD_LOGIC;                          
           DI : out STD_LOGIC); 
    end component;
    
-- Initialisation à "0" des signaux d'entrées et de sorties
signal t_addr : std_logic_vector (5 downto 0) := (others => '0');
signal t_data : std_logic_vector (15 downto 0) :=(others =>'0');
signal t_bp_encodeur : std_logic := '0';
signal t_reset : std_logic := '0';
signal t_clk : std_logic := '0';
signal t_DO : std_logic := '0';
signal t_CS : std_logic := '0';
signal t_SK : std_logic := '0';
signal t_DI : std_logic := '0';

begin
    uut : write_eeprom
        Port map (
            addr => t_addr,
            data => t_data,
            bp_encodeur => t_bp_encodeur,
            reset => t_reset,
            clk => t_clk,
            DO => t_DO,
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

    bp_encodeur_proc : t_bp_encodeur <= '0', '1' after 10 ns, '0' after 20 ns;

    addr_proc : t_addr <= "000001";

    data_proc : t_data <= "1010101010101010";

end Behavioral;

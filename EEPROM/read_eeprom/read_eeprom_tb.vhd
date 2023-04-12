--------------------------------------------------------------------
-- Université de Bordeaux
-- Projet M2 ISE
-- MARTIN Léo & KALIFA Léo
-- Module : write_eeprom_tb - Behavioral
-- Description : module de test de read_eeprom
--------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity read_eeprom_tb is
--  Port ( );
end read_eeprom_tb;

architecture Behavioral of read_eeprom_tb is

    component read_eeprom
    Port ( addr : in STD_LOGIC_VECTOR (5 downto 0);     
           data : out STD_LOGIC_VECTOR (15 downto 0);    
           read : in STD_LOGIC;                  
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
signal t_read : std_logic := '0';
signal t_reset : std_logic := '0';
signal t_clk : std_logic := '0';
signal t_DO : std_logic := '0';
signal t_CS : std_logic := '0';
signal t_SK : std_logic := '0';
signal t_DI : std_logic := '0';

begin

uut : read_eeprom
        Port map (
            addr => t_addr,
            data => t_data,
            read => t_read,
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

    bp_encodeur_proc : t_read <= '0', '1' after 10 ns, '0' after 20 ns;

    addr_proc : t_addr <= "000001";
    
    data_proc : t_DO <= '0', '1' after 9 us,    -- data(15)
                             '0' after 10 us,   -- data(14)
                             '1' after 11 us,   -- data(13)
                             '0' after 12 us,   -- data(12)
                             '1' after 13us,    -- data(11)
                             '0' after 14 us,   -- data(10)
                             '1' after 15 us,   -- data(9)
                             '0' after 16 us,   -- data(8)
                             '1' after 17 us,   -- data(7)
                             '0' after 18 us,   -- data(6)
                             '1' after 19 us,   -- data(5)
                             '0' after 20 us,   -- data(4)
                             '1' after 21 us,   -- data(3)
                             '0' after 22 us,   -- data(2)
                             '1' after 23 us,   -- data(1)
                             '0' after 24 us;   -- data(0)
end Behavioral;

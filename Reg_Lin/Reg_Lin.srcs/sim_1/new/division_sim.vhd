----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.04.2023 16:51:02
-- Design Name: 
-- Module Name: division_sim - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity division_sim is
--  Port ( );
end division_sim;

architecture Behavioral of division_sim is

component division_fixe
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           enable: in std_logic;
           dividend : in STD_LOGIC_vector (7 downto 0);
           divisor : in STD_LOGIC_vector (3 downto 0);
           result : OUT STD_LOGIC_vector (7 downto 0));
end component;

signal t_CLK : STD_LOGIC;
signal t_RESET : STD_LOGIC;
signal t_enable : STD_LOGIC;
signal t_dividend : STD_LOGIC_vector (7 downto 0):= "10000111";
signal t_divisor : STD_LOGIC_vector (3 downto 0):="0110";
signal t_result : STD_LOGIC_vector (7 downto 0);

begin

inst_div: division_fixe Port Map(
    clk=>t_clk,
    reset=>t_reset,
    enable=>t_enable,
    dividend=>t_dividend,
    divisor=>t_divisor,
    result=>t_result
);

CLK : process -- process de clk : '0' pendant 5ns puis '1' pendant 5ns etc.
begin
    t_CLK <= '0', '1' after 5ns;
    wait for 10ns;
end process;

-- process de RESET : '1' pendant 5ns puis '0'
RESET_process :t_RESET <= '1', '0' after 10ns;

-- process de CONV : '0' pendant 5ns puis '1' pendant 5ns 
enable_process : t_enable <= '0', '1' after 60ns;-- '0' after 70ns; --, '1' after 5ns;
end Behavioral;

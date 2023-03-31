----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 31.03.2023 14:23:06
-- Design Name: 
-- Module Name: FIFO_fpga - Behavioral
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

entity FIFO_fpga is
    Port ( dac_out : out STD_LOGIC_VECTOR (11 downto 0);
           haut_out : out STD_LOGIC_VECTOR (14 downto 0);
           load_dac : in STD_LOGIC_VECTOR (11 downto 0);
           load_haut : in STD_LOGIC_VECTOR (14 downto 0);
           enable : in STD_LOGIC;
           clk : in STD_LOGIC;
           acces_rang : in STD_LOGIC_VECTOR (2 downto 0));
end FIFO_fpga;

architecture Behavioral of FIFO_fpga is

begin


end Behavioral;

----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.03.2023 17:24:59
-- Design Name: 
-- Module Name: Calcul_Haut - Behavioral
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

entity Calcul_Haut is
    Port ( 
           
           color_choice : in STD_logic ; -- 0 green 1 red
           segments : out STD_LOGIC_VECTOR (7 downto 0);
           Color_multiplex : out STD_LOGIC_VECTOR (7 downto 0));
end Calcul_Haut;

architecture Behavioral of Calcul_Haut is

begin


end Behavioral;

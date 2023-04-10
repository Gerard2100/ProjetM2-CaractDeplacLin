----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Leo Khalifa
-- 
-- Create Date: 10.04.2023 15:00:17
-- Design Name: 
-- Module Name: division_fixe_clean - Behavioral
-- Project Name: 
-- Target Devices: Artix-7 XC7A35T-1XPG236C4
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--  Version multicprocessuss de la division fixe
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity division_fixe_clean is
   Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           enable: in std_logic;
           dividend : in STD_LOGIC_vector (7 downto 0);
           divisor : in STD_LOGIC_vector (3 downto 0);
           result : OUT STD_LOGIC_vector (7 downto 0));
end division_fixe_clean;

architecture Behavioral of division_fixe_clean is

begin


end Behavioral;

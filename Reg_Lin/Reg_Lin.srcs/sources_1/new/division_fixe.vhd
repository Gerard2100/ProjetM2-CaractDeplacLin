----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.04.2023 14:33:11
-- Design Name: 
-- Module Name: division_fixe - Behavioral
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
use IEEE.STD_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity division_fixe is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           dividend : in STD_LOGIC_vector (7 downto 0);
           divisor : in STD_LOGIC_vector (3 downto 0);
           result : OUT STD_LOGIC_vector (8 downto 0));
end division_fixe;

architecture Behavioral of division_fixe is

constant size : integer := 4;
constant endloop: integer  := 7;
signal temp_result: std_logic_vector (4 downto 0);
signal final_result: std_logic_vector(8 downto 0);
signal temp_num  : std_logic_vector (4 downto 0);
signal complement_divisor: std_logic_vector (3 downto 0);
signal padded_divisor: std_logic_vector (4 downto 0);

begin
    process (clk)
        begin
            if rising_edge(clk) then
                if reset = '1' then
                    result <= "000000000";
                else
                    temp_num <= '0' + dividend(7 downto 3);
                    complement_divisor <= not divisor + 1; 
                    padded_divisor(3 downto 0) <= complement_divisor;
                    padded_divisor(4) <= '0';
                    for i in 0 to endloop loop
                    
                        temp_result<= temp_num and padded_divisor;
                        
                        final_result(8-i)<=temp_result(4);
                        if temp_result(4) = '1' then --si on as une division possible
                            if 4+i > endloop then   -- si on as atteind le bout du numérateur
                                temp_num(4 downto 1)<=temp_num(3 downto 0);
                                temp_num(0)<='0';
                            else
                                temp_num(4 downto 1)<=temp_num(3 downto 0);
                                temp_num(0)<=dividend(7-(4+i));
                            end if;
                        else
                            if 4+i > endloop then  -- si on as atteind le bout du numérateur
                                temp_num(4 downto 1)<=temp_result(3 downto 0);
                                temp_num(0)<='0';
                            else
                                temp_num(4 downto 1)<=temp_result(3 downto 0);
                                temp_num(0)<=dividend(7-(4+i));
                            end if;
                        end if;
                    end loop; 
                end if;
                
            end if;
    
    end process;

end Behavioral;

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
--use IEEE.STD_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity division_fixe is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           enable: in std_logic;
           dividend : in STD_LOGIC_vector (7 downto 0);
           divisor : in STD_LOGIC_vector (3 downto 0);
           result : OUT STD_LOGIC_vector (7 downto 0));
end division_fixe;

architecture Behavioral of division_fixe is
constant taille_denum : integer := 4;
constant taille_num: integer  := 7;
constant taille_res: integer :=7;
signal temp_result: std_logic_vector (4 downto 0);
signal final_result: std_logic_vector(7 downto 0);
signal temp_num  : std_logic_vector (4 downto 0);
signal complement_divisor: std_logic_vector (3 downto 0);
signal padded_divisor: std_logic_vector (4 downto 0);
signal datavalid: std_logic;

begin
    process (clk)
        begin
            if clk= '1' and clk'event then
                if reset = '1' then
                    datavalid <= '0';
                else
                    if enable ='1' then
                        temp_num(3 downto 0) <= dividend(7 downto 4);
                        temp_num(4) <='0';
                        complement_divisor <= not divisor + 1; 
                        padded_divisor(3 downto 0) <= complement_divisor;
                        padded_divisor(taille_denum) <= '0';
                        for i in 0 to taille_res loop
                           if i=taille_res then
                                datavalid<='1';   
                            end if;
                            temp_result<= temp_num and padded_divisor;
                            
                            final_result(7-i)<=temp_result(taille_denum);
                            if temp_result(taille_denum) = '1' then --si on as une division possible
                                if taille_denum+i > taille_num then   -- si on as atteind le bout du numérateur
                                    temp_num(taille_denum downto 1)<=temp_num(3 downto 0);
                                    temp_num(0)<='0';
                                else
                                    temp_num(taille_denum downto 1)<=temp_num(3 downto 0);
                                    temp_num(0)<=dividend(taille_num-(taille_denum+i));
                                end if;
                            else
                                if taille_denum+i > taille_num then  -- si on as atteind le bout du numérateur
                                    temp_num(taille_denum downto 1)<=temp_result(3 downto 0);
                                    temp_num(0)<='0';
                                else
                                    temp_num(taille_denum downto 1)<=temp_result(3 downto 0);
                                    temp_num(0)<=dividend(taille_num-(taille_denum+i));
                                end if;
                            end if;
                        end loop;
                        
                    end if;
                end if;                
            end if;
    
    end process;
    
    result<=final_result when datavalid ='1' else "00000000";

end Behavioral;

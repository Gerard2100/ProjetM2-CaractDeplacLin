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
           numerateur : in STD_LOGIC_vector (7 downto 0);
           denominateur : in STD_LOGIC_vector (3 downto 0);
           result : OUT STD_LOGIC_vector (7 downto 0);
           data_valid : out std_logic);
end division_fixe_clean;

architecture Behavioral of division_fixe_clean is
--constants
constant numLength : integer := 8;
constant denumLength: integer :=4;

--signals

-- compteur 
constant moduloPeriod : integer := 8;
signal cptITend: std_logic;
signal cptIT : integer range 0 to moduloPeriod - 1;
signal iterate: std_logic:='0';


signal Unumerateur: unsigned(numLength downto 0);
signal num_temporaire: unsigned((denumLength+1) downto 0);
signal denum_temporaire: unsigned((denumLength+1) downto 0);





type state_type is (idle,init, iteration); -- différents états de la FSM
signal state : state_type;

begin

Unumerateur <= unsigned(numerateur);

    FSM : process(clk)
    begin
        if clk'event and clk='1' then
             if reset = '1' then 
                state <= idle;  
            else
                case state is
                    when idle =>        if enable  = '1' then
                                            state <= iteration;                                            
                                        end if; 
                 
                    when iteration =>   if cptITend = '1' then
                                            state <= idle;
                                            data_valid <= '1';
                                        end if; 
                end case;
            end if;
        end if;
    end process;

       
     cptIT_proc : process (clk)
    begin
        if clk'event and clk = '1' then
            if reset = '1' or state = idle then
                cptIT <= 0;
                cptITend <= '0';
            elsif iterate = '1' and state = iteration then -- buffer needed
                case cptIT is
                    when moduloPeriod - 1 =>        cptIT <= 0;
                                                    cptITend <= '1';
                    when others =>                  cptIT <= cptIT + 1;
                                                    cptITend <= '0';
                end case;
            end if;
        end if;
    end process;
    
    

    IT_proc: process(clk)
    begin
    if clk'event and clk = '1' then
            if state = iteration then
                if cptIT = 0 then -- init
                    denum_temporaire(denumLength downto 0) <= unsigned(denominateur);
                    denum_temporaire(denumLength downto 0) <= not(denum_temporaire(denumLength downto 0)+1);
                    denum_temporaire(4)<='0';
                    num_temporaire <= Unumerateur((denumLength+1) downto 0);
                end if;
                
            end if;
        end if;
    
    
    
    
    
    
    end process;
    
 

end Behavioral;

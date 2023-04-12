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
--  Version multiprocessuss de la division fixe
-- 
-- entrées : - numérateur
--           - dénominateur
--           - clock, raz, enable
--
-- sorties : - résultat
--           - datavalid
--          
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
signal to_iterate: std_logic;
signal valid_data: integer:= 0;
signal end_iterate:std_logic;
-- compteur 
constant moduloPeriod : integer := 8;
signal cptITend: std_logic;
signal cptIT : integer range 0 to moduloPeriod - 1;
signal iterate: std_logic:='1';

--calcul
signal Unumerateur: unsigned((numLength-1) downto 0);
signal num_temporaire: unsigned((denumLength+1) downto 0);
signal denum_temporaire: unsigned((denumLength+1) downto 0);
signal temp_result: unsigned((denumLength+1) downto 0);
signal final_result: unsigned(moduloPeriod-1 downto 0);

--init
signal complement : unsigned ((denumLength-1) downto 0);


type state_type is (idle,init, iteration); -- diffÃ©rents Ã©tats de la FSM
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
                                            state <= init;
                                            valid_data <= 0;                                            
                                        end if; 
                    when init =>        if to_iterate = '1' then
                                            state <= iteration;
                                            
                                        end if;
                    when iteration =>   if cptITend = '1' then
                                            state <= idle;
                                            valid_data <= 1;
                                        end if; 
                end case;
            end if;
        end if;
    end process;

complementproc : complement<= not(unsigned(denominateur));

    initproc: process (clk) -- init
    begin
    if clk'event and clk = '1' then
            if reset = '1' or state = idle then
                denum_temporaire <= "000000";
                num_temporaire <= "000000";
            elsif  state = init then
                    denum_temporaire(denumLength-1 downto 0) <= complement + "0001" ;
                    denum_temporaire(denumLength+1)<='0';
                    num_temporaire (denumLength downto 0) <= Unumerateur((numLength-1) downto denumLength-1);
                    num_temporaire(denumLength+1) <= '0';
                    to_iterate <='1';
            end if;
        end if;
    end process;
       
     cptIT_proc : process (clk)
    begin
        if clk'event and clk = '1' then
            if reset = '1' or state = idle then
                cptIT <= 0;
                cptITend <= '0';
                iterate<='0';
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
   
    IT_proc: process(clk,cptIT)
    begin
    if clk'event and clk = '1' then
            if state = iteration and cptIT'event then
                
                --standard it
                    temp_result<= denum_temporaire + num_temporaire;
                     
                    final_result(7-cptIT) <= temp_result(denumLength);
                    if temp_result(denumLength) = '1' then --si on as une division possible
                        if denumLength+cptIT > numLength then   -- si on as atteind le bout du numérateur
                            denum_temporaire(denumLength downto 1)<=denum_temporaire((denumLength-1) downto 0);
                            denum_temporaire(0)<='0';
                        else
                            denum_temporaire(denumLength downto 1)<=denum_temporaire((denumLength-1) downto 0);
                            denum_temporaire(0) <= Unumerateur(numLength-(denumLength+cptIT));
                        end if;
                    else
                        if denumLength+cptIT > numLength then  -- si on as atteind le bout du numérateur
                            denum_temporaire(denumLength downto 1)<=temp_result((denumLength-1) downto 0);
                            denum_temporaire(0)<='0';
                        else
                            denum_temporaire(denumLength downto 1)<=temp_result((denumLength-1) downto 0);
                            denum_temporaire(0)<=Unumerateur(numLength-(denumLength+cptIT));
                        end if;
                    end if; 
                -- fin it
            end if;
        end if;
    
    
    end process;
    
 datavalidProc: data_valid <= '1' when valid_data = 1 else '0';

end Behavioral;
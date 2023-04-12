----------------------------------------------------------------------------------
-- Company: UBdx
-- Engineer: JT
-- Create Date:    17/10/2018
-- Module Name:    debouncer - Behavioral 
-- Description: debouncer, check same signal value after 5ms
-- using FSM and decounter
----------------------------------------------------------------------------------


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY debouncer IS
  PORT (	reset  	: IN  std_logic;   -- synchronous reset active high
			clk    	: IN  std_logic;   -- 100Mhz for Nexys3, rising edge active
			pushIn 	: IN  std_logic;   -- pushIn 
			debOut 	: OUT std_logic);  -- pushIn debounced
END debouncer;

ARCHITECTURE behavioral OF debouncer IS
    
	TYPE type_state IS (waitFor1, test1, waitFor0, test0);
	SIGNAL state : type_state;

	CONSTANT modulo_tempo : natural := 5000000/10; -- := 5ms/(Tclk=10ns) 
--	CONSTANT modulo_tempo : natural := 10;  -- dedicated to simulation
	SIGNAL load_tempo	: std_logic;		-- load of decounter active high
	SIGNAL end_tempo	: std_logic;		-- carry of tempo decounter active high
	SIGNAL dec_tempo	: integer range 0 to modulo_tempo-1;

BEGIN  
 
tempo_5ms : PROCESS(clk)  -- decounter with priority loading
	BEGIN
		IF clk'event and clk='1' then
			IF reset='1' OR load_tempo='1'  THEN 
				dec_tempo <= modulo_tempo - 1;
				end_tempo <= '0';				
			ELSE
				case dec_tempo is
					when 1 =>
						dec_tempo <= 0;
						end_tempo <= '1';
					when 0=>
						dec_tempo <= modulo_tempo - 1;
						end_tempo <= '0';
					when others =>
						dec_tempo <= dec_tempo - 1;
						end_tempo <= '0';
				end case;  
			END IF;
		END IF;
	END PROCESS;

load_tempo_proc : load_tempo <= '1' WHEN state=waitFor1 OR state=waitFor0 ELSE '0';
	
fsm_proc : PROCESS(clk)
	BEGIN  
		IF clk'event and clk='1' then
			IF reset='1' THEN
				state <= waitFor1;
			else
				CASE state IS
					WHEN waitFor1 => 
						IF pushIn='1' THEN 
							state <= test1;
						END IF;
					WHEN test1 => 
						IF end_tempo='1' AND pushIn='1' THEN 
							state <= waitFor0;
						ELSIF end_tempo='1' AND pushIn='0' THEN
							state <= waitFor1;
						END IF;
					WHEN waitFor0 =>  
						IF pushIn='0' THEN 
							state <= test0;
						END IF;
					WHEN test0 => 
						IF end_tempo='1' AND pushIn='1' THEN 
							state <= waitFor0; 
						ELSIF end_tempo='1' AND pushIn='0' THEN 
							state <= waitFor1;
						END IF;               
				END CASE;
			END IF;
		END IF;
	END PROCESS;

output_decode : debOut <= '1' WHEN state=waitFor0 OR state=test0 ELSE '0';

END behavioral;

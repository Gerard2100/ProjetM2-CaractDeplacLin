----------------------------------------------------------------------------------
-- Company: UBdx
-- Engineer: JT
-- Create Date:    17/10/2018
-- Module Name:    calibTclk - Behavioral 
-- Description: calibration to one clock period of input pulse
-- 					using FSM, positive pulse
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity calibTclk is
    Port(CLK : in STD_LOGIC;				--	rising edge active
			RESET : in STD_LOGIC;			-- synchronnous, active high
			PULSE_IN : in STD_LOGIC;		-- input
			PULSE_OUT : out STD_LOGIC);		-- output 
end calibTclk;

architecture Behavioral of calibTclk is

	type state_type is (waitFor1, risingEdge, waitFor0);
	signal next_state, state : state_type;

begin

nextStateDecode : process (state, PULSE_IN) 
	begin
		next_state <= state;
		case state is
			when waitFor1 => 
				if PULSE_IN='1' then 
					next_state <= risingEdge;
				end if;
			when risingEdge => 
				if PULSE_IN='1' then 
					next_state <= waitFor0;
				else 
					next_state <= waitFor1;
				end if;
			when waitFor0 => 
				if PULSE_IN='0' then 
					next_state <= waitFor1;
				end if;
		end case;
	end process;

stateReg : process (CLK)
	begin
		if clk'event and clk='1' then
			if reset='1' then
				state <= waitFor1;
			else
				state <= next_state;
		    end if;
		end if;
	end process;

outputDecode : PULSE_OUT <= '1' when state=risingEdge else '0';	

end Behavioral;
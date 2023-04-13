--------------------------------------------------------------------
-- Université de Bordeaux
-- Projet M2 ISE
-- MARTIN Léo & KALIFA Léo
-- Module : enable_eeprom_basys3 - Behavioral
-- Description : implémentation de enable_eeprom sur la carte basys3
--------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity enable_eeprom_basys3 is
    Port ( clk : in STD_LOGIC;                  
           reset : in STD_LOGIC;                        
           enable : in STD_LOGIC;                                                    
           CS : out STD_LOGIC;                          
           SK : out STD_LOGIC;                          
           DI : out STD_LOGIC); 
end enable_eeprom_basys3;

architecture Behavioral of enable_eeprom_basys3 is

    component enable_eeprom
        Port ( clk : in STD_LOGIC;                  
               reset : in STD_LOGIC;                        
               enable : in STD_LOGIC;                                                    
               CS : out STD_LOGIC;                          
               SK : out STD_LOGIC;                          
               DI : out STD_LOGIC); 
    end component;
    
    component debouncer
	   Port( reset : IN std_logic;
	         CLK : IN std_logic;
	         pushIn : IN std_logic;
	         debOut : OUT std_logic);
	end component;
	
	component calibTclk
	   Port( PULSE_IN : IN std_logic;
	         CLK : IN std_logic;
	         RESET : IN std_logic;
	         PULSE_OUT : OUT std_logic);
	end component;
	
-- Signaux internes
signal debOut_PULSE_IN : STD_LOGIC; -- signal de sortie du debouncer
signal Q : STD_LOGIC; -- signal de sortie de la bascule D
signal PULSE_OUT_enable : std_logic; -- signal de sortie de calibTclk

begin

    I_enable_eeprom : enable_eeprom
        Port map ( enable => PULSE_OUT_enable,
                   reset => reset,
                   clk => clk,
                   CS => CS,
                   SK => SK,
                   DI => DI);
                   
      I_debouncer : debouncer 
        Port MAP( reset => RESET,
                  pushIn => Q,
                  CLK => CLK,
                  debOut => debOut_PULSE_IN);  
                  
     I_calibTclk : calibTclk 
        Port MAP( PULSE_IN => debOut_PULSE_IN,
                  CLK => CLK,
                  RESET => RESET,
                  PULSE_OUT => PULSE_OUT_enable);                            

    -- Bascule D   
    process (clk)
    begin
        if clk'event and clk='1' then
            if reset='1' then
                Q <= '0';
            else
                Q <= enable;
            end if;
         end if;
    end process;

end Behavioral;

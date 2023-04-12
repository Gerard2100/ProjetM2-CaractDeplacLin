--------------------------------------------------------------------
-- Université de Bordeaux
-- Projet M2 ISE
-- MARTIN Léo & KALIFA Léo
-- Module : write_eeprom_basys3 - Behavioral
-- Description : implémentation de write_eeprom sur la carte basys3
--------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity write_eeprom_basys3 is
    Port ( data : in STD_LOGIC_VECTOR (15 downto 0);    
           write : in STD_LOGIC;                  
           reset : in STD_LOGIC;                        
           clk : in STD_LOGIC;                          
           DO : in STD_LOGIC;                           
           CS : out STD_LOGIC;                          
           SK : out STD_LOGIC;                          
           DI : out STD_LOGIC); 
end write_eeprom_basys3;

architecture Behavioral of write_eeprom_basys3 is

    component write_eeprom
    Port ( addr : in STD_LOGIC_VECTOR (5 downto 0);     
           data : in STD_LOGIC_VECTOR (15 downto 0);    
           write : in STD_LOGIC;                  
           reset : in STD_LOGIC;                        
           clk : in STD_LOGIC;                          
           DO : in STD_LOGIC;                           
           CS : out STD_LOGIC;                          
           SK : out STD_LOGIC;                          
           DI : out STD_LOGIC); 
    end component;
    
    component debouncer
	    Port ( reset : IN std_logic;
	           CLK : IN std_logic;
	           pushIn : IN std_logic;
	           debOut : OUT std_logic);
	end component;
	
	component calibTclk
	   Port ( PULSE_IN : IN std_logic;
	         CLK : IN std_logic;
	         RESET : IN std_logic;
	         PULSE_OUT : OUT std_logic);
	end component;
    
-- Initialisation à "1" de l'adresse
signal t_addr : std_logic_vector (5 downto 0) := "111111";

-- Signaux internes
signal debOut_PULSE_IN : STD_LOGIC; -- signal de sortie du debouncer
signal Q : STD_LOGIC;               -- signal de sortie de la bascule D
signal PULSE_OUT_write : std_logic; -- signal de sortie de calibTclk

begin

    I_write_eeprom : write_eeprom
        Port map ( addr => t_addr,
                   data => data,
                   write => PULSE_OUT_write,
                   reset => reset,
                   clk => clk,
                   DO => DO,
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
                  PULSE_OUT => PULSE_OUT_write);
                  
    -- bascule D
    process(clk)  
	begin
		if clk'event and clk='1' then
			if reset='1'  then 
				 Q <= '0';				
			else
				 Q <= write   ;
			end if;
		end if;
	end process;                          
    
end Behavioral;

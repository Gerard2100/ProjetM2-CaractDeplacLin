--------------------------------------------------------------------
-- Université de Bordeaux
-- Projet M2 ISE
-- MARTIN Léo & KALIFA Léo
-- Module : read_eeprom_basys3 - Behavioral
-- Description : implémentation de read_eeprom sur la basys3
--------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity read_eeprom_basys3 is
  Port ( clk : in std_logic;
         reset : in std_logic;
         read : in std_logic;
         addr : in std_logic_vector (5 downto 0);
         DO : in std_logic;
         CS : out std_logic;
         SK : out std_logic;
         DI : out std_logic;
         data : out std_logic_vector (15 downto 0));
end read_eeprom_basys3;

architecture Behavioral of read_eeprom_basys3 is

    component read_eeprom
    Port ( addr : in STD_LOGIC_VECTOR (5 downto 0);
           read : in STD_LOGIC;     
           reset : in STD_LOGIC;                        
           clk : in STD_LOGIC;                          
           DO : in STD_LOGIC;                          
           CS : out STD_LOGIC;                         
           SK : out STD_LOGIC;                          
           DI : out STD_LOGIC;                          
           data : out STD_LOGIC_VECTOR (15 downto 0));  
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
	
-- SIGNAUX INTERNES
signal debOut_PULSE_IN : STD_LOGIC; -- signal de sortie du debouncer
signal Q : STD_LOGIC; -- signal de sortie de la bascule D
signal PULSE_OUT_read : std_logic; -- signal de sortie de calibTclk

begin
    
    I_read_eeprom : read_eeprom
        Port map ( addr => addr,
                   read => PULSE_OUT_read,
                   reset => reset,
                   clk => clk,
                   DO => DO,
                   CS => CS,
                   SK => SK,
                   DI => DI,
                   data => data);
                   
      I_debouncer : debouncer 
        Port MAP( reset => RESET,
                  pushIn => Q,
                  CLK => CLK,
                  debOut => debOut_PULSE_IN);  
                  
     I_calibTclk : calibTclk 
        Port MAP( PULSE_IN => debOut_PULSE_IN,
                  CLK => CLK,
                  RESET => RESET,
                  PULSE_OUT => PULSE_OUT_read);                            

    -- Bascule D   
    process (clk)
    begin
        if clk'event and clk='1' then
            if reset='1' then
                Q <= '0';
            else
                Q <= read;
            end if;
         end if;
    end process;

end Behavioral;

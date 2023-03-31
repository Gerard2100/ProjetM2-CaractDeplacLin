----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 31.03.2023 14:07:09
-- Design Name: 
-- Module Name: Affichage - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Affichage is
    Port ( 
            color: in std_logic;
			clk : in  STD_LOGIC;		
			raz : in  STD_LOGIC;		
			enable : in  STD_LOGIC;	
			pt_d3 : in  STD_LOGIC;  	
			pt_d2 : in  STD_LOGIC;
			pt_d1 : in  STD_LOGIC;
			pt_d0 : in  STD_LOGIC;  	
			d3 : in  STD_LOGIC_VECTOR (3 downto 0);  	
			d2 : in  STD_LOGIC_VECTOR (3 downto 0);
			d1 : in  STD_LOGIC_VECTOR (3 downto 0);
			d0 : in  STD_LOGIC_VECTOR (3 downto 0);  	
			segments : out  STD_LOGIC_VECTOR (6 downto 0);  	
			anodes : out  STD_LOGIC_VECTOR (7 downto 0);  	
			dp : out  STD_LOGIC);  							
end Affichage;

architecture Behavioral of Affichage is

signal s_1KHz : STD_LOGIC;  							
signal choix_digit : STD_LOGIC_VECTOR (1 downto 0); 
signal choix_digit_col : STD_LOGIC_VECTOR (2 downto 0);
signal val_hexa_aff : STD_LOGIC_VECTOR (3 downto 0);  	
signal pt_aff : STD_LOGIC; 								

COMPONENT mux2_4bits
	PORT(
		e0 : IN std_logic_vector(3 downto 0);
		e1 : IN std_logic_vector(3 downto 0);
		e2 : IN std_logic_vector(3 downto 0);
		e3 : IN std_logic_vector(3 downto 0);
		sel : IN std_logic_vector(1 downto 0);          
		s : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;

COMPONENT mux2_1bit
	PORT(
		e0 : IN std_logic;
		e1 : IN std_logic;
		e2 : IN std_logic;
		e3 : IN std_logic;
		sel : IN std_logic_vector(1 downto 0);          
		s : OUT std_logic
		);
	END COMPONENT;

COMPONENT cpt_mod4
	PORT(
		clk : IN std_logic;
		enable : IN std_logic;
		reset : IN std_logic;          
		count : OUT std_logic_vector(1 downto 0)
		);
	END COMPONENT;

COMPONENT gene_1kHz
	PORT(
		clk : IN std_logic;
		enable : IN std_logic;
		raz : IN std_logic;          
		carry : OUT std_logic
		);
	END COMPONENT;

COMPONENT hex2seg_dp
	PORT(
	    color : in std_logic;
		hex : IN std_logic_vector(3 downto 0);
		aff : IN std_logic_vector(3 downto 0);
		pt : IN std_logic;          
		segments : OUT std_logic_vector(6 downto 0);
		anodes : OUT std_logic_vector(3 downto 0);
		dp : OUT std_logic
		);
	END COMPONENT;

begin

choix_digit_col(1 downto 0) <= choix_digit;
choix_digit_col(2) <= color;

	Inst_gene_1kHz: gene_1kHz PORT MAP(
		clk => clk ,
		enable => enable,
		raz => raz,
		carry => s_1KHz
	);

	Inst_cpt_mod4: cpt_mod4 PORT MAP(
		clk => clk,
		enable => s_1KHz,
		reset => raz ,
		count => choix_digit
	);

	Inst_mux2_4bits: mux2_4bits PORT MAP(
		e0 => d0,
		e1 => d1,
		e2 => d2,
		e3 => d3,
		sel => choix_digit,
		s => val_hexa_aff
	);
	
	Inst_mux2_1bit: mux2_1bit PORT MAP(
		e0 => pt_d0,
		e1 => pt_d1,
		e2 => pt_d2,
		e3 => pt_d3,
		sel => choix_digit,
		s => pt_aff
	);

	Inst_hex2seg_dp: hex2seg_dp PORT MAP(
	    color => color,
		hex =>  val_hexa_aff,
		aff => choix_digit_col,
		pt => pt_aff,
		segments => segments,
		anodes => anodes,
		dp => dp
	);

end Behavioral;

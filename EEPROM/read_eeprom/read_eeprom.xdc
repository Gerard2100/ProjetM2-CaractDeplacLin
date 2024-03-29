## This file is a general .xdc for the Basys3 rev B board
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

## uncomment if required
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]

## Clock signal 100MHz on BOARD
set_property PACKAGE_PIN W5 [get_ports clk]							
	set_property IOSTANDARD LVCMOS33 [get_ports clk]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

	
## Switches 
set_property PACKAGE_PIN V17 [get_ports {sw[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[0]}]
set_property PACKAGE_PIN V16 [get_ports {sw[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[1]}]
set_property PACKAGE_PIN W16 [get_ports {sw[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[2]}]
set_property PACKAGE_PIN W17 [get_ports {sw[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[3]}]
set_property PACKAGE_PIN W15 [get_ports {sw[4]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[4]}]
set_property PACKAGE_PIN V15 [get_ports {sw[5]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[5]}]
 

## LEDs
set_property PACKAGE_PIN U16 [get_ports {data[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {data[0]}]
set_property PACKAGE_PIN E19 [get_ports {data[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {data[1]}]
set_property PACKAGE_PIN U19 [get_ports {data[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {data[2]}]
set_property PACKAGE_PIN V19 [get_ports {data[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {data[3]}]
set_property PACKAGE_PIN W18 [get_ports {data[4]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {data[4]}]
set_property PACKAGE_PIN U15 [get_ports {data[5]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {data[5]}]
set_property PACKAGE_PIN U14 [get_ports {data[6]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {data[6]}]
set_property PACKAGE_PIN V14 [get_ports {data[7]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {data[7]}]
set_property PACKAGE_PIN V13 [get_ports {data[8]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {data[8]}]
set_property PACKAGE_PIN V3 [get_ports {data[9]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {data[9]}]
set_property PACKAGE_PIN W3 [get_ports {data[10]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {data[10]}]
set_property PACKAGE_PIN U3 [get_ports {data[11]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {data[11]}]
set_property PACKAGE_PIN P3 [get_ports {data[12]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {data[12]}]
set_property PACKAGE_PIN N3 [get_ports {data[13]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {data[13]}]
set_property PACKAGE_PIN P1 [get_ports {data[14]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {data[14]}]
set_property PACKAGE_PIN L1 [get_ports {data[15]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {data[15]}]
	

##Buttons
#set_property PACKAGE_PIN U18 [get_ports read]						
	#set_property IOSTANDARD LVCMOS33 [get_ports read]
#set_property PACKAGE_PIN T18 [get_ports reset]						
	#set_property IOSTANDARD LVCMOS33 [get_ports reset]
 


##Pmod Header JA
##Sch name = JA1
set_property PACKAGE_PIN J1 [get_ports {CS}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {CS}]
##Sch name = JA2
set_property PACKAGE_PIN L2 [get_ports {SK}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {SK}]
##Sch name = JA3
set_property PACKAGE_PIN J2 [get_ports {DI}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {DI}]
##Sch name = JA4
set_property PACKAGE_PIN G2 [get_ports {DO}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {DO}]

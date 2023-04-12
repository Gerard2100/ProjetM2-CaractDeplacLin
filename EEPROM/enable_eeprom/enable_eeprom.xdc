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


##Buttons
set_property PACKAGE_PIN U18 [get_ports enable]						
	set_property IOSTANDARD LVCMOS33 [get_ports enable]
set_property PACKAGE_PIN T18 [get_ports reset]						
	set_property IOSTANDARD LVCMOS33 [get_ports reset]
 
 
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
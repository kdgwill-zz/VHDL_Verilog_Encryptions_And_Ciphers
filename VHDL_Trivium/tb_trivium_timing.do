quit -sim
vlib work
vmap work work
vmap simprim C:/Xilinx/14.7/ISE_DS/ISE/vhdl/mti_pe/10.4/nt64/simprim
vcom -reportprogress 300 -work work C:/SkyDrive/School/Polytechnic/EL6463_AdvancedHardwareDesign/Labs/FinalProject/trivium_impl/netgen/par/tb_trivium_timesim.vhd
vsim -gui -sdfmax /=C:/SkyDrive/School/Polytechnic/EL6463_AdvancedHardwareDesign/Labs/FinalProject/trivium_impl/netgen/par/tb_trivium_timesim.sdf work.tb_trivium
view wave
#add wave *;
do trivium_timing_wave.do; 
force clk_25 0 0ns, 1 4.5ns -repeat 9ns

################################################
force rst 1 1ns, 0 500ns
force input 0 0ns
force nxt 0 0ns 
#, 1 1000ns, 0 2000ns, 1 3000ns, 0 4000ns
force skp 0 0ns, 1 6000ns, 0 7000ns, 1 9000ns, 0 11000ns
force skp 1 63000ns
force skp 0 0ns, 1 1000ns -repeat 2000ns 
run 80us
################################################
wave zoom full
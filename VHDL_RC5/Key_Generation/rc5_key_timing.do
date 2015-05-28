quit -sim
vlib work
vmap work work
vmap simprim C:/Xilinx/14.7/ISE_DS/ISE/vhdl/mti_pe/10.4/nt64/simprim
vcom -reportprogress 300 -work work C:/SkyDrive/School/Polytechnic/EL6463_AdvancedHardwareDesign/Labs/Lab5/rc5_key_expansion/netgen/par/rc5_key_timesim.vhd
vsim -gui -sdfmax /=C:/SkyDrive/School/Polytechnic/EL6463_AdvancedHardwareDesign/Labs/Lab5/rc5_key_expansion/netgen/par/rc5_key_timesim.sdf work.rc5_key
view wave
do rc5_expand_time_wave.do; 
force clk 0 0ns, 1 20ns -repeat 40ns
force clr 0 0ns, 1 500ns
force key 0 0ns
force key_vld 0 0ns, 1 600ns, 0 700ns
run 4.5us
wave zoom full
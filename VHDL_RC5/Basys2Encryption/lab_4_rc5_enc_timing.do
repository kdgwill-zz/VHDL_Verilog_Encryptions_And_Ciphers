quit -sim
vlib work
vmap work work
vmap simprim C:/Xilinx/14.7/ISE_DS/ISE/vhdl/mti_pe/10.4/nt64/simprim
vcom -reportprogress 300 -work work C:/SkyDrive/School/Polytechnic/EL6463_AdvancedHardwareDesign/Labs/Lab4/rc5_enc_full/netgen/par/rc5_enc_timesim.vhd
vsim -gui -sdfmax /=C:/SkyDrive/School/Polytechnic/EL6463_AdvancedHardwareDesign/Labs/Lab4/rc5_enc_full/netgen/par/rc5_enc_timesim.sdf work.rc5_enc
view wave
do C:/SkyDrive/School/Polytechnic/EL6463_AdvancedHardwareDesign/Labs/Lab4/rc5_enc_timing_wave.do; 
force clk 0 0ns, 1 12ns -repeat 24ns

################################################
#Encryption
#force enc 0 0ns
force clr 0 0ns, 1 500ns
force din 16#0000000000000000
force di_vld 0 0ns, 1 600ns, 0 1100ns
run 2us
################################################
#Encryption
#force enc 0 0ns
force din 16#00000000000000FF
force di_vld 0 0ns, 1 600ns, 0 1100ns
run 2us
################################################
#Encryption
#force enc 0 0ns
force din 16#00000000000000F0
force di_vld 0 0ns, 1 600ns, 0 1100ns
run 2us
################################################
#Encryption
#force enc 0 0ns
force din 16#000000000000000F
force di_vld 0 0ns, 1 600ns, 0 1100ns
run 2us
################################################
#Encryption
#force enc 0 0ns
force din 16#00000000000000AA
force di_vld 0 0ns, 1 600ns, 0 1100ns
run 2us
################################################
#Encryption
#force enc 0 0ns
force din 16#0000000000000055
force di_vld 0 0ns, 1 600ns, 0 1100ns
run 2us
################################################
##Full Screen Wave
wave zoom full
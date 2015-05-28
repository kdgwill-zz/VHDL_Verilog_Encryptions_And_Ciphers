quit -sim
vlib work
vmap work work
vcom rotLeft.vhd rotRight.vhd hex2sevenseg.vhd rc5.vhd
vsim work.rc5
view wave
do rc5_func_wave.do;#add wave *
force clk_25 0 0ns, 1 20ns -repeat 40ns 

################################################
#Encryption
#force enc 0 0ns
force clr 1 0ns, 0 500ns
force din_lower 8#00
force di_vld 0 0ns, 1 600ns, 0 1100ns
run 1.5us
################################################
#Encryption
#force enc 0 0ns
force din_lower 16#FF
force di_vld 0 0ns, 1 600ns, 0 1100ns
run 1.5us
################################################
#Encryption
#force enc 0 0ns
force din_lower 16#F0
force di_vld 0 0ns, 1 600ns, 0 1100ns
run 1.5us
################################################
#Encryption
#force enc 0 0ns
force din_lower 16#0F
force di_vld 0 0ns, 1 600ns, 0 1100ns
run 1.5us
################################################
#Encryption
#force enc 0 0ns
force din_lower 16#AA
force di_vld 0 0ns, 1 600ns, 0 1100ns
run 1.5us
################################################
#Encryption
#force enc 0 0ns
force din_lower 16#55
force di_vld 0 0ns, 1 600ns, 0 1100ns
run 1.5us
################################################
##Full Screen Wave
wave zoom full
quit -sim
vlib work
vmap work work
vmap simprim C:/Xilinx/14.7/ISE_DS/ISE/vhdl/mti_pe/10.4/nt64/simprim
# vcom -reportprogress 300 -work work C:/SkyDrive/School/Polytechnic/EL6463_AdvancedHardwareDesign/Labs/Lab6/rc5/netgen/par/tb_rc5_timesim.vhd
# vsim -gui -sdfmax /=C:/SkyDrive/School/Polytechnic/EL6463_AdvancedHardwareDesign/Labs/Lab6/rc5/netgen/par/tb_rc5_timesim.sdf work.tb_rc5
vcom -reportprogress 300 -work work ./rc5/netgen/par/tb_rc5_timesim.vhd
vsim -gui -sdfmax /=./rc5/netgen/par/tb_rc5_timesim.sdf work.tb_rc5 -t ns
view wave
do timing_wave.do; #add wave *; 

#Base Signals
force clk 0 0ns, 1 45ns -repeat 90ns
force clr 0 0ns, 1 1200ns
force data_vld 0 0ns
##Perform Key Expansion
#force din 16#0000000000000000 0ns
#force key_vld 0 0ns, 1 1700ns, 0 2300ns
##Run Simulation
#run 10us
##Perform Encryption when key is ready
#force din 16#FEDCBA9876543210 0ns
#force enc 1 0ns; #This sets encryption
#force data_vld 1 1700ns, 0 2300ns
#run 6us
####Perform Decryption After Encryption is completed
#force din 16#EA04BFBEB6EB797B 0ns
#force enc 0 0ns; # This sets it to decryption
#force data_vld 1 1700ns, 0 3100ns;
##Run Simulation
#run 6us

##Full Screen Wave
#wave zoom full
#################################################
##Perform Key Expansion
#force din 16#0000000000000000 0ns
#force key_vld 0 0ns, 1 1700ns, 0 2300ns
##Run Simulation
#run 60us
##Perform Encryption when key is ready
#force din 16#0000000000000000 0ns
#force enc 1 0ns; #This sets encryption
#force data_vld 1 1700ns, 0 2300ns
#run 17us
####Perform Decryption After Encryption is completed
#force din 16#EEDBA5216D8F4B15 0ns
#force enc 0 0ns; # This sets it to decryption
#force data_vld 1 1700ns, 0 3100ns;
##Run Simulation
#run 17us
#
##Full Screen Wave
#wave zoom full
##################################################
##Perform Key Expansion
#force din 16#0000000000000000 0ns
#force key_vld 0 0ns, 1 1700ns, 0 2300ns
##Run Simulation
#run 60us
##Perform Encryption when key is ready
#force din 16#FFFFFFFFFFFFFFFF 0ns
#force enc 1 0ns; #This sets encryption
#force data_vld 1 1700ns, 0 2300ns
#run 17us
####Perform Decryption After Encryption is completed
#force din 16#4C719ECA593EFF1F 0ns
#force enc 0 0ns; # This sets it to decryption
#force data_vld 1 1700ns, 0 3100ns;
##Run Simulation
#run 17us
#
##Full Screen Wave
#wave zoom full

##################################################
##Perform Key Expansion
#force din 16#0000000000000000 0ns
#force key_vld 0 0ns, 1 1700ns, 0 2300ns
##Run Simulation
#run 60us
##Perform Encryption when key is ready
#force din 16#FFFFFFFF00000000 0ns
#force enc 1 0ns; #This sets encryption
#force data_vld 1 1700ns, 0 2300ns
#run 17us
####Perform Decryption After Encryption is completed
#force din 16#3A39493576DB0451 0ns
#force enc 0 0ns; # This sets it to decryption
#force data_vld 1 1700ns, 0 3100ns;
##Run Simulation
#run 17us
#
##Full Screen Wave
#wave zoom full
#Perform Key Expansion
force din 16#0000000000000000 0ns
force key_vld 0 0ns, 1 1700ns, 0 2300ns
#Run Simulation
run 10us
#Perform Encryption when key is ready
force din 16#FFFFFFFF00000000 0ns
force enc 1 0ns; #This sets encryption
force data_vld 1 1700ns, 0 2300ns
run 6us
###Perform Decryption After Encryption is completed
force din 16#3A39493576DB0451 0ns
force enc 0 0ns; # This sets it to decryption
force data_vld 1 1700ns, 0 3100ns;
#Run Simulation
run 6us
wave zoom full
##################################################
##Perform Key Expansion
#force din 16#0000000000000000 0ns
#force key_vld 0 0ns, 1 1700ns, 0 2300ns
##Run Simulation
#run 10us
##Perform Encryption when key is ready
#force din 16#00000000FFFFFFFF 0ns
#force enc 1 0ns; #This sets encryption
#force data_vld 1 1700ns, 0 2300ns
#run 6us
####Perform Decryption After Encryption is completed
#force din 16#5740400D13C70A03 0ns
#force enc 0 0ns; # This sets it to decryption
#force data_vld 1 1700ns, 0 3100ns;
##Run Simulation
#run 6us
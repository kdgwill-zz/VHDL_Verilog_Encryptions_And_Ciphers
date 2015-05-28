quit -sim
vlib work
vmap work work
vcom rc5_pkg.vhd rc5_key.vhd rc5_enc.vhd rc5_dec.vhd rc5.vhd;
vsim work.rc5
view wave
do func_wave.do; #add wave *
#Base Signals
force clk 0 0ns, 1 20ns -repeat 40ns
force clr 0 0ns, 1 500ns
force data_vld 0 0ns;
#Perform Key Expansion
force din 16#0000000000000000 0ns
force key_vld 0 0ns, 1 600ns, 0 700ns
#Perform Encryption when key is ready
when {/rc5/key_rdy = 1} { # This is conditional so timing won't have to be guessed
force din 16#FEDCBA9876543210 100ns
force enc 1 200ns; #This sets encryption
force data_vld 1 600ns, 0 700ns;
}
##Perform Decryption After Encryption is completed
when {/rc5/key_rdy = 1		 
		&& /rc5/data_rdy = 1
		&& /rc5/enc = 1} { 
force din 16#EA04BFBEB6EB797B 400ns
force enc 0 500ns; # This sets it to decryption
force data_vld 1 0.9us, 0 1us;
}
#Run Simulation
run 8us

#Full Screen Wave
wave zoom full

################################################
force clr 0 0ns, 1 500ns
force data_vld 0 0ns;
#Perform Key Expansion
force din 16#0000000000000000 0ns
force key_vld 0 0ns, 1 600ns, 0 700ns
#Perform Encryption when key is ready
when {/rc5/key_rdy = 1} { # This is conditional so timing won't have to be guessed
force din 16#0000000000000000 100ns
force enc 1 200ns; #This sets encryption
force data_vld 1 600ns, 0 700ns;
}
##Perform Decryption After Encryption is completed
when {/rc5/key_rdy = 1		 
		&& /rc5/data_rdy = 1
		&& /rc5/enc = 1} { 
force din 16#EEDBA5216D8F4B15 400ns
force enc 0 500ns; # This sets it to decryption
force data_vld 1 0.9us, 0 1us;
}
#Run Simulation
run 8us
################################################
force clr 0 0ns, 1 500ns
force data_vld 0 0ns;
#Perform Key Expansion
force din 16#0000000000000000 0ns
force key_vld 0 0ns, 1 600ns, 0 700ns
#Perform Encryption when key is ready
when {/rc5/key_rdy = 1} { # This is conditional so timing won't have to be guessed
force din 16#FFFFFFFFFFFFFFFF 100ns
force enc 1 200ns; #This sets encryption
force data_vld 1 600ns, 0 700ns;
}
##Perform Decryption After Encryption is completed
when {/rc5/key_rdy = 1		 
		&& /rc5/data_rdy = 1
		&& /rc5/enc = 1} { 
force din 16#4C719ECA593EFF1F 400ns
force enc 0 500ns; # This sets it to decryption
force data_vld 1 0.9us, 0 1us;
}
#Run Simulation
run 8us
################################################
force clr 0 0ns, 1 500ns
force data_vld 0 0ns;
#Perform Key Expansion
force din 16#0000000000000000 0ns
force key_vld 0 0ns, 1 600ns, 0 700ns
#Perform Encryption when key is ready
when {/rc5/key_rdy = 1} { # This is conditional so timing won't have to be guessed
force din 16#FFFFFFFF00000000 100ns
force enc 1 200ns; #This sets encryption
force data_vld 1 600ns, 0 700ns;
}
##Perform Decryption After Encryption is completed
when {/rc5/key_rdy = 1		 
		&& /rc5/data_rdy = 1
		&& /rc5/enc = 1} { 
force din 16#3A39493576DB0451 400ns
force enc 0 500ns; # This sets it to decryption
force data_vld 1 0.9us, 0 1us;
}
#Run Simulation
run 8us
################################################
force clr 0 0ns, 1 500ns
force data_vld 0 0ns;
#Perform Key Expansion
force din 16#0000000000000000 0ns
force key_vld 0 0ns, 1 600ns, 0 700ns
#Perform Encryption when key is ready
when {/rc5/key_rdy = 1} { # This is conditional so timing won't have to be guessed
force din 16#00000000FFFFFFFF 100ns
force enc 1 200ns; #This sets encryption
force data_vld 1 600ns, 0 700ns;
}
##Perform Decryption After Encryption is completed
when {/rc5/key_rdy = 1		 
		&& /rc5/data_rdy = 1
		&& /rc5/enc = 1} { 
force din 16#5740400D13C70A03 400ns
force enc 0 500ns; # This sets it to decryption
force data_vld 1 0.9us, 0 1us;
}
#Run Simulation
run 8us

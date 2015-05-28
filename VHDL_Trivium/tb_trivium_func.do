quit -sim
vlib work
vmap work work
vcom hex2sevenseg.vhd trivium.vhd tb_trivium.vhd
vsim work.tb_trivium
view wave
add wave *;
#do tb_trivium_func_wave.do;
force clk_25 0 0ns, 1 20ns -repeat 40ns

force rst 1 1ns, 0 500ns
force input 0 0ns
force nxt 0 0ns 
#, 1 1000ns, 0 2000ns, 1 3000ns, 0 4000ns
force skp 0 0ns, 1 6000ns, 0 7000ns, 1 9000ns, 0 11000ns
force skp 1 63000ns
force skp 0 0ns, 1 1000ns -repeat 2000ns 
run 80us

wave zoom full
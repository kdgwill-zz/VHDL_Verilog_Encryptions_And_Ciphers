quit -sim
vlib work
vmap work work
vcom rc5_pkg.vhd rc5_key.vhd;
vsim work.rc5_key
view wave
do rc5_expand_wave.do; 
force clk 0 0ns, 1 20ns -repeat 40ns
force clr 0 0ns, 1 500ns
force key 0 0ns
force key_vld 0 0ns, 1 600ns, 0 700ns
run 4.5us
wave zoom full
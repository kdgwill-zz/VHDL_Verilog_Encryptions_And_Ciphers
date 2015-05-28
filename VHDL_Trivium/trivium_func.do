quit -sim
vlib work
vmap work work
vcom trivium.vhd
vsim work.trivium
view wave
#do rc5_enc_func_wave.do;
add wave *;
force clk 0 0ns, 1 20ns -repeat 40ns

force rst 1 1ns, 0 500ns
force hld 1 0ns, 0 55000ns, 1 60000ns
force -freeze sim:/trivium/key 80'h00000000000000000000 0ns
force IV 0 0ns
run 80us

wave zoom full
onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_trivium/clk_25
add wave -noupdate /tb_trivium/rst
add wave -noupdate /tb_trivium/key
add wave -noupdate /tb_trivium/IV
add wave -noupdate /tb_trivium/input
add wave -noupdate /tb_trivium/skp
add wave -noupdate /tb_trivium/nxt
add wave -noupdate /tb_trivium/trivium_z_reg
add wave -noupdate /tb_trivium/hex_digit_i
add wave -noupdate /tb_trivium/segment_a_i
add wave -noupdate /tb_trivium/segment_b_i
add wave -noupdate /tb_trivium/segment_c_i
add wave -noupdate /tb_trivium/segment_d_i
add wave -noupdate /tb_trivium/segment_e_i
add wave -noupdate /tb_trivium/segment_f_i
add wave -noupdate /tb_trivium/segment_g_i
add wave -noupdate /tb_trivium/AN
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 195
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ns} {84 us}

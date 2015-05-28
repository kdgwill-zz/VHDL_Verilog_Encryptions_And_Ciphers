onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /rc5/clk_25
add wave -noupdate /rc5/clr
add wave -noupdate /rc5/di_vld
add wave -noupdate /rc5/din_lower
add wave -noupdate /rc5/do_rdy
add wave -noupdate /rc5/dout
add wave -noupdate /rc5/segment_a_i
add wave -noupdate /rc5/segment_b_i
add wave -noupdate /rc5/segment_c_i
add wave -noupdate /rc5/segment_d_i
add wave -noupdate /rc5/segment_e_i
add wave -noupdate /rc5/segment_f_i
add wave -noupdate /rc5/segment_g_i
add wave -noupdate /rc5/AN
add wave -noupdate /rc5/swtch_led
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {571 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 117
configure wave -valuecolwidth 125
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
WaveRestoreZoom {0 ns} {6692 ns}

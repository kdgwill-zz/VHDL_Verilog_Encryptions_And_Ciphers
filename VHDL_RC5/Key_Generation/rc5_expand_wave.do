onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /rc5_key/clr
add wave -noupdate /rc5_key/clk
add wave -noupdate /rc5_key/key
add wave -noupdate /rc5_key/key_vld
add wave -noupdate /rc5_key/skey
add wave -noupdate /rc5_key/key_rdy
add wave -noupdate /rc5_key/i_cnt
add wave -noupdate /rc5_key/j_cnt
add wave -noupdate /rc5_key/r_cnt
add wave -noupdate /rc5_key/state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
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
WaveRestoreZoom {0 ns} {2100 ns}

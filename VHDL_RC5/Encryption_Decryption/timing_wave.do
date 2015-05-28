onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_rc5/clk
add wave -noupdate /tb_rc5/clr
add wave -noupdate /tb_rc5/enc
add wave -noupdate /tb_rc5/key_vld
add wave -noupdate /tb_rc5/key_rdy
add wave -noupdate /tb_rc5/data_vld
add wave -noupdate /tb_rc5/din
add wave -noupdate /tb_rc5/data_rdy
add wave -noupdate /tb_rc5/dout
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5178 ns} 0}
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
WaveRestoreZoom {0 ns} {8925 ns}

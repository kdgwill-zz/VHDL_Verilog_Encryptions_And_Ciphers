onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_trivium/clk_25
add wave -noupdate /tb_trivium/rst
add wave -noupdate /tb_trivium/state
add wave -noupdate /tb_trivium/nxt
add wave -noupdate /tb_trivium/skp
add wave -noupdate /tb_trivium/key
add wave -noupdate /tb_trivium/IV
add wave -noupdate /tb_trivium/inputCnt
add wave -noupdate /tb_trivium/trivRst
add wave -noupdate /tb_trivium/o_rdy
add wave -noupdate /tb_trivium/z_out
add wave -noupdate /tb_trivium/hld
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
WaveRestoreZoom {0 ns} {84 us}

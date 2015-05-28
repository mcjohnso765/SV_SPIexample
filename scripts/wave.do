onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_master/spi/mosi
add wave -noupdate /tb_master/spi/miso
add wave -noupdate /tb_master/spi/sck
add wave -noupdate /tb_master/spi/ss
add wave -noupdate -divider {New Divider}
add wave -noupdate /tb_master/MASTER/Buf_i
add wave -noupdate /tb_master/MASTER/Strobe_i
add wave -noupdate /tb_master/MASTER/Clk_i
add wave -noupdate /tb_master/MASTER/Rst_ni
add wave -noupdate /tb_master/MASTER/buf_r
add wave -noupdate /tb_master/MASTER/buf_nxt
add wave -noupdate -radix decimal /tb_master/MASTER/bitcnt_r
add wave -noupdate -radix decimal /tb_master/MASTER/bitcnt_nxt
add wave -noupdate -radix decimal /tb_master/MASTER/clkcnt_r
add wave -noupdate -radix decimal /tb_master/MASTER/clkcnt_nxt
add wave -noupdate /tb_master/MASTER/sck_r
add wave -noupdate /tb_master/MASTER/sck_nxt
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {168870 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 81
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
WaveRestoreZoom {0 ps} {210 ns}

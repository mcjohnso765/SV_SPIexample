onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_spi_system/XmitStrobe
add wave -noupdate /tb_spi_system/tbClk
add wave -noupdate /tb_spi_system/Rst_n
add wave -noupdate /tb_spi_system/Ready
add wave -noupdate /tb_spi_system/ToXmit
add wave -noupdate /tb_spi_system/Rcvd
add wave -noupdate /tb_spi_system/ss
add wave -noupdate -divider {New Divider}
add wave -noupdate /tb_spi_system/spi/mosi
add wave -noupdate /tb_spi_system/spi/sck
add wave -noupdate /tb_spi_system/spi/miso
add wave -noupdate /tb_spi_system/spi/ss
add wave -noupdate -divider {slave 1}
add wave -noupdate /tb_spi_system/SLAVE1/Clk_i
add wave -noupdate /tb_spi_system/SLAVE1/Rst_ni
add wave -noupdate /tb_spi_system/SLAVE1/Ready_o
add wave -noupdate /tb_spi_system/SLAVE1/Rcvd_o
add wave -noupdate /tb_spi_system/SLAVE1/sck1
add wave -noupdate /tb_spi_system/SLAVE1/sck2
add wave -noupdate /tb_spi_system/SLAVE1/bitcnt_r
add wave -noupdate /tb_spi_system/SLAVE1/bitcnt_nxt
add wave -noupdate /tb_spi_system/SLAVE1/sh_ena
add wave -noupdate /tb_spi_system/SLAVE1/done
add wave -noupdate /tb_spi_system/SLAVE1/rcvd_nxt
add wave -noupdate /tb_spi_system/SLAVE1/rcvd_r
add wave -noupdate /tb_spi_system/SLAVE1/buf_nxt
add wave -noupdate /tb_spi_system/SLAVE1/buf_r
add wave -noupdate /tb_spi_system/SLAVE1/inBuf_st
add wave -noupdate /tb_spi_system/SLAVE1/inBuf_st_nxt
add wave -noupdate /tb_spi_system/SLAVE1/inBuf_clear
add wave -noupdate /tb_spi_system/SLAVE1/xsh_ena
add wave -noupdate /tb_spi_system/SLAVE1/xmit_ctrl_st
add wave -noupdate /tb_spi_system/SLAVE1/xmit_ctrl_st_nxt
add wave -noupdate /tb_spi_system/SLAVE1/xmit_shift
add wave -noupdate /tb_spi_system/SLAVE1/xmit_load
add wave -noupdate /tb_spi_system/SLAVE1/xmit_r
add wave -noupdate /tb_spi_system/SLAVE1/xmit_nxt
add wave -noupdate /tb_spi_system/SLAVE1/inBuf
add wave -noupdate /tb_spi_system/SLAVE1/inBuf_nxt
add wave -noupdate /tb_spi_system/SLAVE1/strobe_sync
add wave -noupdate -divider {assertion vars}
add wave -noupdate /tb_spi_system/checkXmit
add wave -noupdate /tb_spi_system/checkRcvd
add wave -noupdate /tb_spi_system/checkSS
add wave -noupdate /tb_spi_system/checkReady
add wave -noupdate /tb_spi_system/sstrobe
add wave -noupdate /tb_spi_system/sToXmit
add wave -noupdate /tb_spi_system/srandToXmit
add wave -noupdate /tb_spi_system/srandSS
add wave -noupdate -divider {Slave 2}
add wave -noupdate /tb_spi_system/SLAVE2/Clk_i
add wave -noupdate /tb_spi_system/SLAVE2/Rst_ni
add wave -noupdate /tb_spi_system/SLAVE2/Ready_o
add wave -noupdate /tb_spi_system/SLAVE2/Rcvd_o
add wave -noupdate /tb_spi_system/SLAVE2/sck1
add wave -noupdate /tb_spi_system/SLAVE2/sck2
add wave -noupdate /tb_spi_system/SLAVE2/bitcnt_r
add wave -noupdate /tb_spi_system/SLAVE2/bitcnt_nxt
add wave -noupdate /tb_spi_system/SLAVE2/sh_ena
add wave -noupdate /tb_spi_system/SLAVE2/done
add wave -noupdate /tb_spi_system/SLAVE2/rcvd_nxt
add wave -noupdate /tb_spi_system/SLAVE2/rcvd_r
add wave -noupdate /tb_spi_system/SLAVE2/buf_nxt
add wave -noupdate /tb_spi_system/SLAVE2/buf_r
add wave -noupdate /tb_spi_system/SLAVE2/xsh_ena
add wave -noupdate /tb_spi_system/SLAVE2/xmit_ctrl_st
add wave -noupdate /tb_spi_system/SLAVE2/xmit_ctrl_st_nxt
add wave -noupdate /tb_spi_system/SLAVE2/xmit_shift
add wave -noupdate /tb_spi_system/SLAVE2/xmit_load
add wave -noupdate /tb_spi_system/SLAVE2/xmit_r
add wave -noupdate /tb_spi_system/SLAVE2/xmit_nxt
add wave -noupdate /tb_spi_system/SLAVE2/inBuf
add wave -noupdate /tb_spi_system/SLAVE2/inBuf_nxt
add wave -noupdate /tb_spi_system/SLAVE2/strobe_sync
add wave -noupdate -divider Master
add wave -noupdate /tb_spi_system/MASTER/Buf_i
add wave -noupdate /tb_spi_system/MASTER/ss_i
add wave -noupdate /tb_spi_system/MASTER/Strobe_i
add wave -noupdate /tb_spi_system/MASTER/Clk_i
add wave -noupdate /tb_spi_system/MASTER/Rst_ni
add wave -noupdate /tb_spi_system/MASTER/buf_r
add wave -noupdate /tb_spi_system/MASTER/buf_nxt
add wave -noupdate /tb_spi_system/MASTER/bitcnt_r
add wave -noupdate /tb_spi_system/MASTER/bitcnt_nxt
add wave -noupdate /tb_spi_system/MASTER/clkcnt_r
add wave -noupdate /tb_spi_system/MASTER/clkcnt_nxt
add wave -noupdate /tb_spi_system/MASTER/ss_r
add wave -noupdate /tb_spi_system/MASTER/ss_nxt
add wave -noupdate /tb_spi_system/MASTER/sck_r
add wave -noupdate /tb_spi_system/MASTER/sck_nxt
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {93090 ps} 0}
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
WaveRestoreZoom {0 ps} {2541900 ps}

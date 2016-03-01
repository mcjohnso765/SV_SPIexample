onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {Master ctrl}
add wave -noupdate /tb_spi_system/tb_ctrlm/toXmit
add wave -noupdate /tb_spi_system/tb_ctrlm/Rcvd
add wave -noupdate /tb_spi_system/tb_ctrlm/strobe
add wave -noupdate /tb_spi_system/tb_ctrlm/Ready
add wave -noupdate -expand /tb_spi_system/tb_ctrlm/ss
add wave -noupdate -divider {Slave ctrl 0}
add wave -noupdate {/tb_spi_system/tb_ctrls[0]/toXmit}
add wave -noupdate {/tb_spi_system/tb_ctrls[0]/XmitFull}
add wave -noupdate {/tb_spi_system/tb_ctrls[0]/Rcvd}
add wave -noupdate {/tb_spi_system/tb_ctrls[0]/strobe}
add wave -noupdate -color Yellow {/tb_spi_system/tb_ctrls[0]/Ready}
add wave -noupdate -divider {Slave ctrl 1}
add wave -noupdate {/tb_spi_system/tb_ctrls[1]/toXmit}
add wave -noupdate {/tb_spi_system/tb_ctrls[1]/XmitFull}
add wave -noupdate {/tb_spi_system/tb_ctrls[1]/Rcvd}
add wave -noupdate {/tb_spi_system/tb_ctrls[1]/strobe}
add wave -noupdate -color Yellow {/tb_spi_system/tb_ctrls[1]/Ready}
add wave -noupdate -divider SPI
add wave -noupdate /tb_spi_system/spi/mosi
add wave -noupdate /tb_spi_system/spi/sck
add wave -noupdate /tb_spi_system/spi/miso
add wave -noupdate -expand /tb_spi_system/spi/ss
add wave -noupdate -divider {Slave 1}
add wave -noupdate /tb_spi_system/SLAVE1/Clk_i
add wave -noupdate /tb_spi_system/SLAVE1/Rst_ni
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
add wave -noupdate /tb_spi_system/SLAVE1/mosi_sync1
add wave -noupdate /tb_spi_system/SLAVE1/mosi_sync2
add wave -noupdate /tb_spi_system/SLAVE1/strobe2
add wave -noupdate /tb_spi_system/SLAVE1/strobe_sync
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
add wave -noupdate /tb_spi_system/SLAVE1/ss1
add wave -noupdate /tb_spi_system/SLAVE1/ss2
add wave -noupdate /tb_spi_system/SLAVE1/ss_rise
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {20000 ps} 0}
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
WaveRestoreZoom {0 ps} {6300 ns}

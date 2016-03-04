onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider tb
add wave -noupdate /tb_spi_system/Rst_n
add wave -noupdate /tb_spi_system/tbClkm
add wave -noupdate /tb_spi_system/tbClks
add wave -noupdate /tb_spi_system/randSSxmit
add wave -noupdate -expand /tb_spi_system/slaveFull
add wave -noupdate -divider {Master ctrl}
add wave -noupdate -group {Master Ctrl} /tb_spi_system/tb_ctrlm/toXmit
add wave -noupdate -group {Master Ctrl} /tb_spi_system/tb_ctrlm/Rcvd
add wave -noupdate -group {Master Ctrl} -color Cyan /tb_spi_system/tb_ctrlm/strobe
add wave -noupdate -group {Master Ctrl} -color Yellow /tb_spi_system/tb_ctrlm/Ready
add wave -noupdate -group {Master Ctrl} -expand /tb_spi_system/tb_ctrlm/ss
add wave -noupdate -divider {Slave ctrl 0}
add wave -noupdate -expand -group {Slave Ctrl 0} {/tb_spi_system/tb_ctrls[0]/toXmit}
add wave -noupdate -expand -group {Slave Ctrl 0} {/tb_spi_system/tb_ctrls[0]/XmitFull}
add wave -noupdate -expand -group {Slave Ctrl 0} {/tb_spi_system/tb_ctrls[0]/Rcvd}
add wave -noupdate -expand -group {Slave Ctrl 0} -color Cyan {/tb_spi_system/tb_ctrls[0]/strobe}
add wave -noupdate -expand -group {Slave Ctrl 0} -color Yellow {/tb_spi_system/tb_ctrls[0]/Ready}
add wave -noupdate -expand -group {Slave Ctrl 0} {/tb_spi_system/tb_ctrls[0]/busy}
add wave -noupdate -divider {Slave ctrl 1}
add wave -noupdate -expand -group {Slave Ctrl 1} {/tb_spi_system/tb_ctrls[1]/toXmit}
add wave -noupdate -expand -group {Slave Ctrl 1} {/tb_spi_system/tb_ctrls[1]/XmitFull}
add wave -noupdate -expand -group {Slave Ctrl 1} {/tb_spi_system/tb_ctrls[1]/Rcvd}
add wave -noupdate -expand -group {Slave Ctrl 1} -color Cyan {/tb_spi_system/tb_ctrls[1]/strobe}
add wave -noupdate -expand -group {Slave Ctrl 1} -color Yellow {/tb_spi_system/tb_ctrls[1]/Ready}
add wave -noupdate -expand -group {Slave Ctrl 1} {/tb_spi_system/tb_ctrls[1]/busy}
add wave -noupdate -divider SPI
add wave -noupdate -expand -group SPI /tb_spi_system/spi/mosi
add wave -noupdate -expand -group SPI /tb_spi_system/spi/sck
add wave -noupdate -expand -group SPI /tb_spi_system/spi/miso
add wave -noupdate -expand -group SPI -expand /tb_spi_system/spi/ss
add wave -noupdate -divider {Slave 1}
add wave -noupdate -expand -group {Slave 1} /tb_spi_system/SLAVE1/bitcnt_r
add wave -noupdate -expand -group {Slave 1} /tb_spi_system/SLAVE1/bitcnt_nxt
add wave -noupdate -expand -group {Slave 1} /tb_spi_system/SLAVE1/sh_ena
add wave -noupdate -expand -group {Slave 1} /tb_spi_system/SLAVE1/done
add wave -noupdate -expand -group {Slave 1} /tb_spi_system/SLAVE1/rcvd_nxt
add wave -noupdate -expand -group {Slave 1} /tb_spi_system/SLAVE1/rcvd_r
add wave -noupdate -expand -group {Slave 1} /tb_spi_system/SLAVE1/buf_nxt
add wave -noupdate -expand -group {Slave 1} /tb_spi_system/SLAVE1/buf_r
add wave -noupdate -expand -group {Slave 1} /tb_spi_system/SLAVE1/mosi_sync1
add wave -noupdate -expand -group {Slave 1} /tb_spi_system/SLAVE1/mosi_sync2
add wave -noupdate -expand -group {Slave 1} /tb_spi_system/SLAVE1/strobe2
add wave -noupdate -expand -group {Slave 1} /tb_spi_system/SLAVE1/strobe_sync
add wave -noupdate -expand -group {Slave 1} /tb_spi_system/SLAVE1/preXmitBuf_st
add wave -noupdate -expand -group {Slave 1} /tb_spi_system/SLAVE1/preXmitBuf_st_nxt
add wave -noupdate -expand -group {Slave 1} /tb_spi_system/SLAVE1/preXmitBuf_clear
add wave -noupdate -expand -group {Slave 1} /tb_spi_system/SLAVE1/xsh_ena
add wave -noupdate -expand -group {Slave 1} /tb_spi_system/SLAVE1/xmit_ctrl_st
add wave -noupdate -expand -group {Slave 1} /tb_spi_system/SLAVE1/xmit_ctrl_st_nxt
add wave -noupdate -expand -group {Slave 1} /tb_spi_system/SLAVE1/xmit_shift
add wave -noupdate -expand -group {Slave 1} /tb_spi_system/SLAVE1/xmit_load
add wave -noupdate -expand -group {Slave 1} /tb_spi_system/SLAVE1/xmit_r
add wave -noupdate -expand -group {Slave 1} /tb_spi_system/SLAVE1/xmit_nxt
add wave -noupdate -expand -group {Slave 1} /tb_spi_system/SLAVE1/preXmitBuf
add wave -noupdate -expand -group {Slave 1} /tb_spi_system/SLAVE1/preXmitBuf_nxt
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {4617200 ps} 0}
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
configure wave -timelineunits ns
update
WaveRestoreZoom {4291262 ps} {5083968 ps}

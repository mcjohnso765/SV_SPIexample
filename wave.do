onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider tb
add wave -noupdate /tb_spi_system/tbClk
add wave -noupdate /tb_spi_system/Rst_n
add wave -noupdate /tb_spi_system/randSSxmit
add wave -noupdate /tb_spi_system/slaveFull
add wave -noupdate -divider {Master ctrl}
add wave -noupdate /tb_spi_system/tb_ctrlm/toXmit
add wave -noupdate /tb_spi_system/tb_ctrlm/Rcvd
add wave -noupdate /tb_spi_system/tb_ctrlm/strobe
add wave -noupdate -color Yellow /tb_spi_system/tb_ctrlm/Ready
add wave -noupdate -expand /tb_spi_system/tb_ctrlm/ss
add wave -noupdate -divider {Slave ctrl 0}
add wave -noupdate {/tb_spi_system/tb_ctrls[0]/toXmit}
add wave -noupdate {/tb_spi_system/tb_ctrls[0]/XmitFull}
add wave -noupdate {/tb_spi_system/tb_ctrls[0]/Rcvd}
add wave -noupdate {/tb_spi_system/tb_ctrls[0]/strobe}
add wave -noupdate -color Yellow {/tb_spi_system/tb_ctrls[0]/Ready}
add wave -noupdate {/tb_spi_system/tb_ctrls[0]/busy}
add wave -noupdate -divider {Slave ctrl 1}
add wave -noupdate {/tb_spi_system/tb_ctrls[1]/toXmit}
add wave -noupdate {/tb_spi_system/tb_ctrls[1]/XmitFull}
add wave -noupdate {/tb_spi_system/tb_ctrls[1]/Rcvd}
add wave -noupdate {/tb_spi_system/tb_ctrls[1]/strobe}
add wave -noupdate -color Yellow {/tb_spi_system/tb_ctrls[1]/Ready}
add wave -noupdate {/tb_spi_system/tb_ctrls[1]/busy}
add wave -noupdate -divider SPI
add wave -noupdate /tb_spi_system/spi/mosi
add wave -noupdate /tb_spi_system/spi/sck
add wave -noupdate /tb_spi_system/spi/miso
add wave -noupdate -expand /tb_spi_system/spi/ss
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3606522 ps} 0}
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
WaveRestoreZoom {0 ps} {1764130 ps}

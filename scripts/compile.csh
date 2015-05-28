clear
rm -r work
vlib ./work
vlog +acc -sv source/master.sv
echo " "
vlog +acc -sv source/slave.sv
echo " "
vlog +acc -sv source/tb_spi_system.sv
echo " "

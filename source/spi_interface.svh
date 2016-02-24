// Simple SPI interface example
// for now only supports Master->Save communication for 2 devices
interface SPIbus;
  logic mosi,sck;
  wire miso;
  logic [1:0] ss;
  modport Master (input miso, output mosi, sck, ss);
  modport Slave (input mosi, sck, ss, inout miso);
endinterface

interface SPIctrl;
  logic [7:0] toXmit;  // value to be transmitted by master or slave
  reg [7:0] Rcvd; // data value recieved by master or slave
  logic strobe;  // tell master or slave that there is data on toXmit available
  reg Ready;  // slave or master uses to indicate that there is data ready to use
  logic [1:0] ss;  // too master how to set slave select bits for next transmission
  modport Master (input toXmit, strobe, ss, output Rcvd, Ready);
  modport Slave  (input toXmit, strobe, output Rcvd, Ready);
  modport System (output toXmit, strobe, input Rcvd, Ready);
endinterface

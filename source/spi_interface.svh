// Simple SPI interface example
// for now only supports Master->Save communication for 2 devices
interface SPIbus;
  logic mosi,sck;
  wire miso;
  logic [1:0] ss;
  modport Master (input miso, output mosi, sck, ss);
  modport Slave (input mosi, sck, ss, inout miso);
endinterface


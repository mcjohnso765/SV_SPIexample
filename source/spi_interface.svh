// Simple SPI interface example
// for now only supports Master->Save communication for 2 devices
interface SPIbus;
  logic mosi,sck;
  wire miso;
  logic [1:0] ss;
  modport Master (input miso, output mosi, sck, ss);
  modport Slave (input mosi, sck, ss, output miso);
endinterface

interface SPIctrl;
  logic [7:0] toXmit;   // value to be transmitted by master or slave
  reg [7:0] Rcvd;       // data value recieved by master or slave
  logic strobe;         // tell device that there is data on toXmit available
  reg Ready;            // slave or master indicates data on Rcvd is ready to use
  reg XmitFull;         // = 1 if input buffer already full, not ready for new data
  logic [1:0] ss;       // tell master how to set slave select lines
  logic busy;           // 1 if master or slave already busy transmitting current byte
  modport Master (input toXmit, strobe, ss, output Rcvd, Ready, XmitFull, busy);
  modport Slave  (input toXmit, strobe, output Rcvd, Ready, XmitFull, busy);
  modport System (output toXmit, strobe, input Rcvd, Ready, XmitFull);
endinterface

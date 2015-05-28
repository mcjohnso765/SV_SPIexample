import ovm_pkg::*;
`include "ovm_macros.svh"
`include "source/spi_interface.svh"

`timescale 1ns/10ps

module tb_master#(parameter TCLK=20);

  logic XmitStrobe; // signal to Master that there is new data to xmit
  logic tbClk,Rst_n;
  logic [1:0] Ready;  // from Slave, indicates new byte received
  logic [7:0] ToXmit; // data give to master to be transmitted
  logic [1:0] [7:0] Rcvd; // data received by slaves
  logic [1:0] ss;
  SPIbus spi();

  master MASTER(.Buf_i(ToXmit),.ss_i(ss),.Strobe_i(XmitStrobe),.Spim(spi.Master),.Clk_i(tbClk), .Rst_ni(Rst_n));

  initial
    begin
    forever
      begin
      tbClk = 1'b0;
      #(TCLK/2) tbClk = 1'b1;
      #(TCLK/2);
      end
    end;

  initial
    begin
    ss = 2'b0;
    XmitStrobe = 1'b0;
    ToXmit = 8'd0;
    Rst_n = 1'b0;
    #(TCLK*0.75);
    Rst_n = 1'b1;
    #(TCLK*0.75);
    XmitStrobe = 1'b0;
    ss = 2'b10;
    ToXmit = 8'b10101010;
    @(posedge tbClk);
    #(TCLK/2);
    XmitStrobe = 1'b1;
    @(posedge tbClk);
    #(TCLK/2);
    XmitStrobe = 1'b0;
    end

endmodule

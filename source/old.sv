import ovm_pkg::*;
`include "ovm_macros.svh"
`include "source/spi_interface.svh"

`timescale 1ns/10ps

module tb_spi_system#(parameter TCLK=20);

  logic XmitStrobe; // signal to Master that there is new data to xmit
  logic tbClk,Rst_n;
  logic [1:0] Ready;  // from Slave, indicates new byte received
  logic [7:0] ToXmit,randToXmit; // data give to master to be transmitted
  logic [1:0] [7:0] Rcvd; // data received by slaves
  logic [1:0] ss,randSS;
  logic [7:0] mRcvd; // data received by master
  logic mReady; // indicates new byte received by master
  integer iRandom, testCount;

  SPIbus spi();
  SPIctrl tb_ctrlm(), tb_ctrls0(), tb_ctrls1();

  reg [7:0] checkXmit; // when master is strobed, save xmit value here
  reg [7:0] checkRcvd;
  reg [1:0] checkSS; // when master strobed, save slave select 
  reg checkReady; // becomes 1 when selected slave is ready
  reg [1:0] sstrobe; // signal to one or both slaves when value is available to load to xmit
  reg [7:0] sToXmit; // date to give to slave to be transmitted
  reg [7:0] srandToXmit; 
  reg [1:0] srandSS; // random slave select for loading slave transmit values

  master MASTER(.Ctrl(tb_ctrl.System), .Spim(spi.Master),.Clk_i(tbClk), .Rst_ni(Rst_n));
  slave #(.ID(0)) SLAVE0 (.Ctrl(tb_ctrls0.SPIside), .Spis(spi.Slave),.Clk_i(tbClk),.Rst_ni(Rst_n))
  slave #(.ID(1)) SLAVE1 (.Ctrl(tb_ctrls1.SPIside), .Spis(spi.Slave),.Clk_i(tbClk),.Rst_ni(Rst_n),

  //master MASTER(.Buf_i(ToXmit),.ss_i(ss),.Strobe_i(XmitStrobe),.Spim(spi.Master),.Clk_i(tbClk), .Rst_ni(Rst_n), 
  //              .Ready_o(mReady),.Rcvd_o(mRcvd));
  //slave #(.ID(0)) SLAVE1 (.Spis(spi.Slave),.Clk_i(tbClk),.Rst_ni(Rst_n),
  //              .strobe(sstrobe[0]),.toXmit(sToXmit),.Ready_o(Ready[0]), .Rcvd_o(Rcvd[0]));
  //slave #(.ID(1)) SLAVE2 (.Spis(spi.Slave),.Clk_i(tbClk),.Rst_ni(Rst_n),
  //              .strobe(sstrobe[1]),.toXmit(sToXmit),.Ready_o(Ready[1]), .Rcvd_o(Rcvd[1]));

  // tb assertion logic

  always @(posedge XmitStrobe) begin
    checkXmit = randToXmit;  // save value to be checked when slave receives value
    checkSS = ss;
    end

  always @* begin
    if (checkSS[0]) checkRcvd = Rcvd[0];
    else if (checkSS[1]) checkRcvd = Rcvd[1];
    end

  assign checkReady = (checkSS[0] & Ready[0]) | (checkSS[1] & Ready[1]);

  always @(posedge checkReady) begin
    @(posedge tbClk);
    assert (checkRcvd == checkXmit) else $error("incorrect value received by slave");
    end

  // stimulus generation

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
    randToXmit = $urandom(3); // set fixed seed for repeatability
    master_init();

    for (testCount = 0; testCount < 100; testCount++) begin
      randToXmit = $urandom();
      randSS[0] = $urandom();
      randSS[1] = ~randSS[0];
      master_xmit(randToXmit,randSS,50);
      end
    end

  task master_init;
    ss = 2'b0;
    XmitStrobe = 1'b0;
    ToXmit = 8'd0;
    Rst_n = 1'b0;
    #(TCLK*0.75);
    Rst_n = 1'b1;
    #(TCLK*0.75);
  endtask

  task master_xmit (input [7:0] datin, input [1:0] slave_mask, input integer delay);
    XmitStrobe = 1'b0;
    ToXmit = datin;
    ss = slave_mask;
    @(posedge tbClk);
    #(TCLK/2);
    XmitStrobe = 1'b1;
    @(posedge tbClk);
    #(TCLK/2);
    XmitStrobe = 1'b0;
    #(TCLK*delay);
  endtask

  initial
    begin
    randToXmit = $urandom(3); // set fixed seed for repeatability
    master_init();

    for (testCount = 0; testCount < 100; testCount++) begin
      srandToXmit = $urandom();
      srandSS[0] = $urandom();
      srandSS[1] = ~srandSS[0];
      slave_xmit(srandToXmit,randSS,33);
      end
    end

  task slave_xmit (input [7:0] datin, input [1:0] slave_mask, input integer delay);
    sToXmit = datin;
    sstrobe = 2'b0;
    @(posedge tbClk);
    #(TCLK/2);
    sstrobe = slave_mask;
    @(posedge tbClk);
    #(TCLK/2);
    sstrobe = 2'b0;
    #(TCLK*delay);
  endtask



endmodule

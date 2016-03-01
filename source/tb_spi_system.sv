import ovm_pkg::*;
`include "ovm_macros.svh"
`include "source/spi_interface.svh"

`timescale 1ns/10ps

module tb_spi_system#(parameter TCLK=20);

  logic tbClk,Rst_n;

  SPIbus spi();  // SPI bus between master and two slaves
  SPIctrl tb_ctrlm();  // control interfaces for SPI modules
  SPIctrl tb_ctrls[1:0](); // array of slave control interfaces

  // assertion variables
  integer iRandom, testCount;
  reg [7:0] checkXmit,srandToXmit,mrandToXmit; // when master is strobed, save copy of data in checkXmit
  reg [7:0] checkRcvd, checkSXmit[1:0]; // checkSXmit contains copy of slave xmit data for each slave
  reg [1:0] slaveFull; // 1 indicates that slave has data to transmit to master
  reg [1:0] checkSS; // when master strobed, save slave select 
  reg checkReady; // becomes 1 when selected slave is ready
  integer randSS; // used to tell master which slave to select
  integer randSSxmit; // used to select slave to receive value to be transmitted

  // Top level modules

  master MASTER(.Ctrl(tb_ctrlm.Master), .Spim(spi.Master),.Clk_i(tbClk), .Rst_ni(Rst_n));
  slave #(.ID(0)) SLAVE0 (.Ctrl(tb_ctrls[0].Slave), .Spis(spi.Slave),.Clk_i(tbClk),.Rst_ni(Rst_n));
  slave #(.ID(1)) SLAVE1 (.Ctrl(tb_ctrls[1].Slave), .Spis(spi.Slave),.Clk_i(tbClk),.Rst_ni(Rst_n));

  // tb assertion logic to check that slaves receive correct value transmitted by master

  always @(posedge tb_ctrlm.strobe) begin
    checkXmit = tb_ctrlm.toXmit;  // save value to be checked when slave receives value
    checkSS = tb_ctrlm.ss;
    end

  always @* begin // check correct received byte at whichever slave was selected
    if (checkSS[0]) checkRcvd = tb_ctrls[0].Rcvd;
    else if (checkSS[1]) checkRcvd = tb_ctrls[1].Rcvd;
    end

  assign checkReady = (checkSS[0] & tb_ctrls[0].Ready) | (checkSS[1] & tb_ctrls[1].Ready);

  always @(posedge checkReady) begin
    @(posedge tbClk);
    assert (checkRcvd == checkXmit) $display("correct value received by slave");
      else $error("incorrect value received by slave");
    end


  // assertion logic for values received by master from either slave
  always @(posedge tb_ctrls[0].strobe) begin
    if (!tb_ctrls[0].XmitFull & !slaveFull[0]) begin // ignore new xmit value if slave already full
      checkSXmit[0] = tb_ctrls[0].toXmit; // to be compared when master receives value from slave 0
      if (tb_ctrls[0].busy) begin
        @(negedge tb_ctrls[0].busy);
        end
      slaveFull[0] = 1;
      end
    end

  always @(posedge tb_ctrls[1].strobe) begin
    if (!tb_ctrls[1].XmitFull & !slaveFull[1]) begin // ignore new xmit value if slave already full
      checkSXmit[1] = tb_ctrls[1].toXmit; // to be compared when master receives value from slave 1
      if (tb_ctrls[1].busy) begin
        @(negedge tb_ctrls[1].busy);
        end
      slaveFull[1] = 1;
      end
    end 

  always @(posedge tb_ctrlm.Ready) begin
    @(posedge tbClk);
    if (tb_ctrlm.ss[0] && slaveFull[0]) begin
      assert (tb_ctrlm.Rcvd == checkSXmit[0]) $display("correct value received by master");
        else $error("incorrect value received by master");
      slaveFull[0] = 0;
      end
    else if (tb_ctrlm.ss[1] && slaveFull[1]) begin
      assert (tb_ctrlm.Rcvd == checkSXmit[1]) $display("correct value received by master");
        else $error("incorrect value received by master");
      slaveFull[1] = 0;
      end
    end

  // stimulus generation

  initial begin // Clock generation
    forever
      begin
      tbClk = 1'b0;
      #(TCLK/2) tbClk = 1'b1;
      #(TCLK/2);
      end
    end

  initial  // give SPI master something to transmit
    begin
    mrandToXmit = $urandom(3); // set fixed seed for repeatability
    master_init();

    for (testCount = 0; testCount < 100; testCount++) begin
      @(posedge tbClk)
      mrandToXmit = $urandom();
      randSS = $dist_uniform($urandom(),0,1);
      master_xmit(mrandToXmit,randSS,50);
      end
    end

  task master_init;
    tb_ctrlm.ss = 2'b0;
    tb_ctrlm.strobe = 1'b0;
    tb_ctrlm.toXmit = 8'd0;
    Rst_n = 1'b0;
    #(TCLK*0.75);
    Rst_n = 1'b1;
    #(TCLK*0.75);
  endtask

  task master_xmit (input [7:0] datin, input [1:0] slave_index, input integer delay);
    tb_ctrlm.strobe = 1'b0;
    tb_ctrlm.toXmit = datin;
    tb_ctrlm.ss = 2'b00;
    tb_ctrlm.ss[slave_index] = 2'b01;
    @(posedge tbClk);
    #(TCLK/2);
    tb_ctrlm.strobe = 1'b1;
    @(posedge tbClk);
    #(TCLK/2);
    tb_ctrlm.strobe = 1'b0;
    #(TCLK*delay);
  endtask

  initial  // Give the slave SPIs something to transmit
    begin
    srandToXmit = $urandom(4); // set fixed seed for repeatability
                               // but want different sequence from master SPI
    slaveFull = 2'b00;
    tb_ctrls[0].toXmit = 'b0;
    tb_ctrls[1].toXmit = 'b0;
    tb_ctrls[0].strobe = 1'b0;
    tb_ctrls[1].strobe = 1'b0;
    for (testCount = 0; testCount < 100; testCount++) begin
      @(posedge tbClk)
      srandToXmit = $urandom();
      randSSxmit = $dist_uniform($urandom(),0,1);
      slave_xmit(srandToXmit,randSSxmit,33);
      end
    end

  task slave_xmit (input [7:0] datin, input integer slave_index, input integer delay);
  // Clumsy but SV won't allow variable index into array of instances
  // More elegant option is to create an array of "virtual" interfaces
    if (slave_index == 0) begin
      tb_ctrls[0].toXmit = datin;
      tb_ctrls[0].strobe = 2'b0;
      @(posedge tbClk);
      #(TCLK/2);
      tb_ctrls[0].strobe = 1'b1;
      @(posedge tbClk);
      #(TCLK/2);
      tb_ctrls[0].strobe = 2'b0;
      #(TCLK*delay);
      end
    else begin
      tb_ctrls[1].toXmit = datin;
      tb_ctrls[1].strobe = 2'b0;
      @(posedge tbClk);
      #(TCLK/2);
      tb_ctrls[1].strobe = 1'b1;
      @(posedge tbClk);
      #(TCLK/2);
      tb_ctrls[1].strobe = 2'b0;
      #(TCLK*delay);
      end
  endtask

endmodule

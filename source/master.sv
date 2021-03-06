//`include "source/spi_interface.svh" 
// master
//   Ctrl = SPI module view of control interface. see spi_interface.svh
//   Spim = master view of SPIbus interface
// 
// Components: 
//    SPI clock generator: a 0 to 8 x CLKDIV counter, generates
//      one SCK cycle per CLKDIV clock cycles. Ctrl.strobe triggers
//      it to start counting
//    parallel to serial shift register with shift enable

module master #(CLKDIV=8'd4)(SPIctrl.Master Ctrl, SPIbus.Master Spim, 
                              input Clk_i, Rst_ni);

  logic [7:0] buf_r,buf_nxt, rcv_buf_r;
  // flag to indicate whether input buffer is full
  logic inFull_r, inFull_nxt; 
  logic [3:0] bitcnt_r,bitcnt_nxt;
  logic [7:0] clkcnt_r,clkcnt_nxt;
  logic [1:0] ss_r,ss_nxt;
  logic sck_r,sck_nxt;
  logic [7:0] clkdiv2;

  assign clkdiv2 = CLKDIV >> 1;

  //Transmitter

  always_ff @(posedge Clk_i, negedge Rst_ni) begin
    if (Rst_ni == 1'b0) begin
      clkcnt_r <= 8'd0;
      bitcnt_r <= 8'd0;
      sck_r <= 1'b0;
      buf_r <=  8'd0;
      ss_r <= 2'd0;
      inFull_r <= 1'b0;
      end
    else begin
      clkcnt_r <= clkcnt_nxt;
      bitcnt_r <= bitcnt_nxt;
      sck_r <= sck_nxt;
      buf_r <= buf_nxt;
      ss_r <= ss_nxt;
      inFull_r <= inFull_nxt;
    end
  end

  // load shift reg ond ss n strobe
  always_comb begin
    buf_nxt = buf_r;
    ss_nxt = ss_r;
    if (Ctrl.strobe) begin
      ss_nxt = Ctrl.ss;
      buf_nxt = Ctrl.toXmit;
    end else if (clkcnt_r == CLKDIV) begin
      buf_nxt = {buf_r[6:0],1'b0};
    end
  end

  // update input full flag
  always_comb begin
    Ctrl.XmitFull = inFull_r;
    inFull_nxt = inFull_r;
    if (Ctrl.strobe) 
      inFull_nxt = 1'b1;
    else if (bitcnt_r == 4'd9) 
      inFull_nxt = 1'b0;
  end

  // pulse sck while output bit is stable
  always_comb begin
      sck_nxt = sck_r;
    if (clkcnt_r == CLKDIV) begin
      sck_nxt = 1'b0;
      end
    else if (clkcnt_r == clkdiv2) begin
      sck_nxt = 1'b1;
    end 
  end

  assign Spim.mosi = buf_r[7];
  assign Spim.sck = sck_r;
  assign Spim.ss = ss_r;

  // bitcnt holds at 0 waiting for strobe, starts counting after strobe, 
  // at 9 wrap to 0. Only increment after CLKDIV clock cycles
  always_comb begin
    bitcnt_nxt = bitcnt_r;
    // hold at 0 until strobe, then count can proceed at 1
    if (bitcnt_r == 0 && Ctrl.strobe == 1'b1) begin
      bitcnt_nxt = 1;
    // once per bit period, increment bit count, halt at 9
    end else if (clkcnt_r == CLKDIV - 1) begin
      if (bitcnt_r > 0 && bitcnt_r < 9) begin
        bitcnt_nxt = bitcnt_r + 1;
      end
    end else if (bitcnt_r == 9) begin
      bitcnt_nxt = 0;
      end
    end

  always_ff @(posedge Clk_i, negedge Rst_ni) begin
    if (Rst_ni == 1'b0) begin
      Ctrl.busy = 1'b0;
      end
    else begin
      if (Ctrl.strobe) begin
        Ctrl.busy = 1'b1;
        end
      else if (bitcnt_r == 9) begin
        Ctrl.busy = 1'b0; 
        end
      end
    end

  // clkcnt continuously loops from 1 to CLKDIV after strobe
  always_comb begin
    // hold at 0 until Strobe
    if ((clkcnt_r == 8'd0) && (~Ctrl.strobe) || bitcnt_r == 9) begin
      clkcnt_nxt = 0;
    // start at count of 1 upon Strobe
    end else if ((clkcnt_r == 8'd0) && Ctrl.strobe) begin
      clkcnt_nxt = 1;
    // wrap-around to 1 at max clkcnt, or start at 1 on Strobe
    end else if ((clkcnt_r == CLKDIV) || Ctrl.strobe) begin
      clkcnt_nxt = 1;
    end else begin
      clkcnt_nxt = clkcnt_r + 1;
      end
    end

  //Receiver

  always_ff @(posedge Clk_i, negedge Rst_ni) begin
    if (Rst_ni == 1'b0) begin
      Ctrl.Ready <= 1'b0;
      rcv_buf_r <= 8'd0;
      Ctrl.Rcvd <= 8'd0;
      end
    else begin
      if (clkcnt_r == clkdiv2) rcv_buf_r <= {rcv_buf_r[6:0],Spim.miso};
      if (bitcnt_r == 8'd9) begin
        Ctrl.Rcvd <= rcv_buf_r;
        Ctrl.Ready <= 1'b1;
        end
      //else if (clkcnt_r == clkdiv2) Ctrl.Ready <= 1'b0;
      else Ctrl.Ready <= 1'b0;
      end
    end

endmodule

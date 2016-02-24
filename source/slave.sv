`include "source/spi_interface.svh"

// components:
//   sck rising edge detector, output as sh_ena only when slave select asserted
//   serial to parallel shift reg with shift enable (sh_ena)
//   bit counter: 0 to 7 counter, reset to 0, assert Done on count of 7, enabled by sh_ena, wrap-around 7 to 0
//   output buffer Ctrl.Rcvd with enable. Loads shift reg contents on Done from bit counter
//   Ctrl.Ready = Done from bit counter

module slave #(parameter ID=0) (SPIbus.Slave Spis, SPIctrl.Slave Ctrl, input Clk_i, Rst_ni);

  logic sck1,sck2;
  logic [3:0] bitcnt_r,bitcnt_nxt;
  logic sh_ena,done; // shift enable for receive, receive done
  logic [7:0] rcvd_nxt,rcvd_r,buf_nxt,buf_r;
  logic mosi_sync1, mosi_sync2;

  logic strobe2, strobe_sync; // indicate new data available on Ctrl.toXmit;
  typedef enum {IS_EMPTY,IS_FULL} inBuf_st_t;
  inBuf_st_t inBuf_st, inBuf_st_nxt;
  logic inBuf_clear;
  logic xsh_ena; // shift enable for transmit;
  typedef enum {STROBE_WAIT, LOAD_WAIT, LOAD, XMIT} xmit_ctrl_st_t;
  xmit_ctrl_st_t xmit_ctrl_st, xmit_ctrl_st_nxt;
  logic xmit_shift, xmit_load;
  logic [7:0] xmit_r, xmit_nxt, inBuf,inBuf_nxt;
  logic ss1, ss2, ss_rise; // = 1 for one clock cycle after this slave goes from not selected to selected


  // Receiving 

  always_ff @(posedge Clk_i, negedge Rst_ni) begin
    if (Rst_ni == 1'b0) begin
      bitcnt_r <= 4'd0; // count == 0 when idle
      sck1 <= 1'b0;
      sck2 <= 1'b0;
      mosi_sync1 <= 1'b0;
      mosi_sync2 <= 1'b0;
      rcvd_r <= 8'b0;
      buf_r <= 8'b0;
      end
    else begin
      bitcnt_r <= bitcnt_nxt;
      sck1 <= Spis.sck;
      sck2 <= sck1;
      mosi_sync1 <= Spis.mosi;
      mosi_sync2 <= mosi_sync1;
      rcvd_r <= rcvd_nxt;
      buf_r <= buf_nxt;
    end
  end

  assign sh_ena = sck1 && !sck2 && (Spis.ss[ID]==1'b1);

  always_comb begin
    bitcnt_nxt = bitcnt_r;
    if (sh_ena) begin
      if (~done)
        bitcnt_nxt = bitcnt_r + 1;
      else
        bitcnt_nxt = 4'd1;
      end
    else if (bitcnt_r == 4'd8)
      bitcnt_nxt = 4'd0;
  end 

  always_comb begin
    buf_nxt = buf_r;
    if (sh_ena)
      buf_nxt = {buf_r[6:0],mosi_sync2};
  end

  assign done = (bitcnt_r == 4'd8);

  always_comb begin
    rcvd_nxt = rcvd_r;
    if (done)
      rcvd_nxt = buf_r;
  end

  assign Ctrl.Rcvd = rcvd_r;
  
  always_ff @(posedge Clk_i, negedge Rst_ni) begin
    if (Rst_ni == 1'b0) Ctrl.Ready <= 1'b0;
    else Ctrl.Ready <= done;
    end

  // Transmitting


  always_ff @(posedge Clk_i, negedge Rst_ni) begin
    if (Rst_ni == 1'b0) begin
      strobe2 <= 1'b0;
      strobe_sync <= 1'b0;
      inBuf <= 8'b0;
      inBuf_st <= IS_EMPTY;
      xmit_ctrl_st <= STROBE_WAIT;
      xmit_r <= 8'b0;
      ss1 <= 1'b0;
      ss2 <= 1'b0;
    end else begin
      strobe2 <= Ctrl.strobe;
      strobe_sync <= strobe2;
      inBuf <= inBuf_nxt;
      inBuf_st <= inBuf_st_nxt;
      xmit_ctrl_st <= xmit_ctrl_st_nxt;
      xmit_r <= xmit_nxt;
      ss1 <= Spis.ss[ID];
      ss2 <= ss1;
    end
  end

  assign ss_rise = !ss2 && ss1;

  // buff NS
  always_comb begin
    inBuf_nxt = inBuf;
    if (strobe_sync) inBuf_nxt = Ctrl.toXmit; 
  end

  // Buff ctrl NS
  always_comb begin
    inBuf_st_nxt = inBuf_st;
    case (inBuf_st)
      IS_EMPTY:
        if (strobe_sync) inBuf_st_nxt = IS_FULL;
      IS_FULL:
        if (inBuf_clear) inBuf_st_nxt = IS_EMPTY;
    endcase
  end

  //sck fall edge
  //assign xsh_ena = !sck1 && sck2 && (Spis.ss[ID]==1'b1);
  assign xsh_ena = sh_ena && (xmit_ctrl_st == XMIT);

  // xmit ctrl
  always_comb begin
    xmit_ctrl_st_nxt = xmit_ctrl_st;
    case (xmit_ctrl_st)
      STROBE_WAIT:
        if (inBuf_st == IS_FULL) xmit_ctrl_st_nxt = LOAD_WAIT;
      LOAD_WAIT:
        if ((bitcnt_r == 4'd8) || ss_rise) xmit_ctrl_st_nxt = LOAD;
      LOAD:
        xmit_ctrl_st_nxt = XMIT;
      XMIT:
        if (done) xmit_ctrl_st_nxt = STROBE_WAIT;
    endcase
  end

  // xmit output
  always_comb begin
    xmit_shift = 1'b0;
    xmit_load = 1'b0;
    inBuf_clear = 1'b0;
    case (xmit_ctrl_st)
      LOAD: begin
        xmit_load = 1'b1;
        inBuf_clear = 1'b1;
        end
      XMIT:
        xmit_shift = 1'b1;
    endcase
  end

  always_comb begin
    xmit_nxt = xmit_r;
    if (xmit_load) begin
      xmit_nxt = inBuf;
      end
    else if (xsh_ena) begin
      xmit_nxt = xmit_r << 1;
      end
  end

  assign Spis.miso = (Spis.ss[ID]==1'b1) ? xmit_r[7] : 1'bz;

endmodule

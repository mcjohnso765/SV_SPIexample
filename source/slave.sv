`include "source/spi_interface.svh"

// components:
//   sck rising edge detector, output as sh_ena only when slave select asserted
//   serial to parallel shift reg with shift enable (sh_ena)
//   bit counter: 0 to 7 counter, reset to 0, assert Done on count of 7, enabled by sh_ena, wrap-around 7 to 0
//   output buffer Rcvd_o with enable. Loads shift reg contents on Done from bit counter
//   Ready_o = Done from bit counter

// currently only a receiver design

module slave #(parameter ID=0) (SPIbus.Slave Spis, input Clk_i, Rst_ni, output reg Ready_o, output [7:0] Rcvd_o); 

  logic sck1,sck2;
  logic [3:0] bitcnt_r,bitcnt_nxt;
  logic sh_ena,done;
  logic [7:0] rcvd_nxt,rcvd_r,buf_nxt,buf_r;
  logic mosi_sync1, mosi_sync2;

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
    if (sh_ena) 
      if (~done)
        bitcnt_nxt = bitcnt_r + 1;
      else
        bitcnt_nxt = 4'd1;
  end 

  always_comb begin
    buf_nxt = buf_r;
    if (sh_ena)
      buf_nxt = {mosi_sync2,buf_r[7:1]};
  end

  assign done = (bitcnt_r == 4'd8);

  always_comb begin
    rcvd_nxt = rcvd_r;
    if (done)
      rcvd_nxt = buf_r;
  end

  assign Rcvd_o = rcvd_r;
  
  // stub for miso assert value of ID when ss[ID] is enabled, else Z
  assign Spis.miso = (Spis.ss[ID]==1'b1) ? ID : 1'bz;

  always_ff @(posedge Clk_i, negedge Rst_ni) begin
    if (Rst_ni == 1'b0) Ready_o <= 1'b0;
    else Ready_o <= done;
    end

endmodule

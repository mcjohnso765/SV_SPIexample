// Description: General Purpose FSM based controller
//
// Author: Mark Johnson
//
// Sens = sensor/control inputs, I(0) doubles as SPIdat
// SPIck = clock for loading FSM code in config register
// Clk_i = system clock
// Rst_ni = async assert, sync release reset. Resets all
//   but config register
// Q = control outputs
//
`include "source/gpf_defines.inc"


module timer(Trig_i, Time_i, Clk_i, Rst_ni, TimeOut_o);
  input Trig_i;
  input [`NCNT:0] Time_i;
  input Clk_i, Rst_ni;
  output TimeOut_o;

  reg [`NCNT:0] Count_ff;

  always @ (posedge Clk_i, negedge Rst_ni)
    begin
    if (Rst_ni==0) 
      Count_ff <= `NCNT1'd0;
    else // clock edge branch
      if (Trig_i==1) Count_ff <= Time_i;
      else if (Count_ff > 0) Count_ff <= Count_ff - 1;
      else Count_ff <= `NCNT1'd0;
    end

  assign TimeOut_o = (Count_ff==1) ? 1 : 0;

endmodule



// Description: General Purpose FSM based controller
// Configuration Register - defines next state and output logic
// for FSM.
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

module sync(Async_ai,Clk_i,Rst_ni,Sync_so);
  input [`NIN:0] Async_ai;
  input Clk_i, Rst_ni;
  output [`NIN:0] Sync_so;
  reg [`NIN:0] Q1_ff,Q2_ff;

  always @ (posedge Clk_i, negedge Rst_ni)
    begin
    if (Rst_ni==0) 
      begin 
        Q1_ff <= `NIN1'd0; 
        Q2_ff <= `NIN1'd0; 
      end
    else
      begin 
        Q1_ff <= Async_ai; 
        Q2_ff <= Q1_ff; 
       end
    end
  assign Sync_so = Q2_ff;    
endmodule


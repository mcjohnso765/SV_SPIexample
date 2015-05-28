// Description: General Purpose FSM based controller
// Author: Mark Johnson
//
// Sens = sensor/control inputs, I(0) doubles as SPIdat
// SPIck = clock for loading FSM code in config register
// Clk = system clock
// nRst = async assert, sync release reset. Resets all
//   but config register
// Q = control outputs
//
`include "source/gpf_defines.inc"

module decode(Sens_ai, Instr_i, TimeOut_i, State_i, State_nso, NextOut_o, Trig_o, Time_o);
  input [`NIN:0]    Sens_ai;
  input [`ILEN:0]   Instr_i;
  input             TimeOut_i;
  input [`NST:0]    State_i;
  
  output [`NST:0]   State_nso;  reg    [`NST:0]   State_nso;
  output [`NOUT:0]  NextOut_o; reg    [`NOUT:0]  NextOut_o;
  output            Trig_o;    reg               Trig_o;
  output [`NCNT:0]  Time_o;    reg    [`NCNT:0]  Time_o;

  reg [`NIN+1:0] AllInputs,InMask,InMasked;
  reg dInDetect;

  always_comb
    begin
    NextOut_o = Instr_i[`OUTPUTS];
    State_nso = Instr_i[`NEXTST];
    Trig_o = 0;
    Time_o = 0;
    AllInputs = {Sens_ai,TimeOut_i};
    InMask = Instr_i[`INMASK];
    InMasked = InMask & AllInputs;
    dInDetect = |InMasked;

    case  (Instr_i[`OPCODE])
     `BAND : // branch if all inputs 1, else go to instr++
       begin
       if (~(InMasked == InMask))
         State_nso = State_i + 1;
       end
     `BOR :  // branch if any input 1, else instr++
       begin
       if (~dInDetect)
         State_nso = State_i + 1;
       end
     `SETT : // set timer count, start count down
       begin
       Time_o = Instr_i[`DURAT];
       State_nso = State_i + 1; 
       Trig_o = 1;
       end
     `WAND : // spin wait until all inputs 1
       begin
       if (~(InMasked == InMask))
         State_nso = State_i;
       end
       // else hold at current state
     `WOR : // spin wait until some input is 1
       begin
       if (~dInDetect)
         State_nso = State_i;
       end
       // else hold at current state
    endcase
    end
endmodule


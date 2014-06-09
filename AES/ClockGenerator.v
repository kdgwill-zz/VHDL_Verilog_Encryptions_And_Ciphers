//---------------------------------------------------------------------------
//--clockGenerator.v---------------------------------------------------------
//--By Kyle Williams, 11/20/2012---------------------------------------------
//--PROJECT DESCRIPTION------------------------------------------------------
//----This module Acts as a crystal and influences prescion in timing--------
//This line is important in a Verilog simulation, because it sets up the time scale and
//operating precision for a module. It causes the unit delays to be in nanoseconds (ns) and
//the precision at which the simulator will round the events down to at 100 ps. This causes
//a #5 or #1 in a Verilog assignment to be a 5 ns or 1 ns delay respectively. The rounding
//of the events will be to .1ns or 100 pico seconds.
`timescale 1 ns / 100ps //time unit = 1ns; precision = 1/10 ns
module ClockGenerator(
  output reg clock,
  output reg reset
);
   
  always begin
    //10 MHz clock as defined in tb(50*1 ns*2) with 50% duty-cycle
    #50 clock = ~clock;
	//executes every 50 nanoseconds this causes a period of 100ns or frequency of 
	
	//if use 10 then will have a period of 20ns which is equivalent to 50 Mhz
	//quick formula p = period 1/((p*2)*(10^(-9)))/1e6 = the frequency in Mhz
  end
  
 initial 
  begin
    clock = 0;
    reset = 1;
    #20 reset = 0;//active high reset
  end
    
endmodule
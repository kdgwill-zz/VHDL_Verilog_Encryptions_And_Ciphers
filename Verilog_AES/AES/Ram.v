//-----------------------------------------------------------------------------------
//--RAM.v----------------------------------------------------------------------------
//--By Kyle Williams, 11/20/2012-----------------------------------------------------
//--MODULE DESCRIPTION---------------------------------------------------------------
//----------------Simple Dual Port Ram used to store data--------------------------
//----------------reset is not required ram can be filled with useless data----------
module Ram
  #(
      parameter ADDR_WIDTH = 4,
      parameter DATA_WIDTH = 8,
      parameter MEM_DEPTH = 64
  )(
//------------Input Ports------------
  input clk,
  input[ADDR_WIDTH-1:0] addrA,
  input[ADDR_WIDTH-1:0] addrB,
  input wr_enaA,
  input wr_enaB,
  input[DATA_WIDTH-1:0] ram_inA,
  input[DATA_WIDTH-1:0] ram_inB,
//------------Output Ports-----------
  output reg[DATA_WIDTH-1:0] ram_outA,
  output reg[DATA_WIDTH-1:0] ram_outB
  );
  
//------------Reg/ Wires-------------
  reg [DATA_WIDTH-1:0] mem [0:MEM_DEPTH-1];
  
  always@(posedge clk)
  begin:Port_One
    if(wr_enaA == 1'b1)
    begin:MEM_WRITE
        mem[addrA] <= ram_inA;
    end       
    //MEM_READ
    ram_outA <= mem[addrA];  
  end
  
  always@(posedge clk)
  begin:Port_Two
    if(wr_enaB == 1'b1)
    begin:MEM_WRITE
        mem[addrB] <= ram_inB;
    end       
    //MEM_READ
    ram_outB <= mem[addrB];  
  end
   
endmodule
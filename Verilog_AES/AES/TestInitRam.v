//-----------------------------------------------------------------------------------
//--TestInitRam.v----------------------------------------------------------------------------
//--By Kyle Williams, 11/20/2012-----------------------------------------------------
//--MODULE DESCRIPTION---------------------------------------------------------------
//----------------Loads Memory With Dummy Data---------------------------------------
module TestInitRam
  #(
      parameter ADDR_WIDTH = 4,
      parameter DATA_WIDTH = 8,
      parameter MEM_DEPTH = 64
  )(
//------------Input Ports------------
  input clk,
  input rst,
//------------Output Ports-----------
  output reg[DATA_WIDTH-1:0] key,
  output reg finished,
  output reg [ADDR_WIDTH-1:0] addrA,
  output reg [ADDR_WIDTH-1:0] addrB,
  output reg wr_enaA,
  output reg wr_enaB,
  output reg[DATA_WIDTH-1:0] data_outA,
  output reg[DATA_WIDTH-1:0] data_outB
  );
  
//------------Reg/ Wires-------------
  reg [DATA_WIDTH-1:0] tempMem [0:MEM_DEPTH-1];
  reg [ADDR_WIDTH-1:0] addr;
  always@(posedge clk)//we don't care about synthesizable change whenever clk changes
  begin:TransferData
    if(tempMem[addr][DATA_WIDTH-1]==1'b1 || tempMem[addr][DATA_WIDTH-1]==1'b0)begin
      wr_enaA <= 1'b1;
      wr_enaB <= 1'b1;
      addrA <= addr;
      addrB <= addr+1;
      data_outA <= tempMem[addr];
      data_outB <= tempMem[addr+1];      
      addr <= addr+2;//increment address by two we have two ports lets use them both
    end else begin
      finished <= 1'b1;
      wr_enaA <= 1'b0;
      wr_enaB <= 1'b0;
      addrA <= 0;
      addrB <= 0;
      wr_enaA<=0;
      wr_enaB<=0;
      data_outA<=0;
      data_outB<=0;
    end
  end
  
  always@(posedge clk)
  begin:Reset
    if(rst)
    begin
      addr <= 0;
      addrA <= 0;
      addrB <= 0;
      wr_enaA<=0;
      wr_enaB<=0;
      finished<=0;
      data_outA<=0;
      data_outB<=0;
    end       
  end
  
  integer r1,c1;
  initial
  begin
    r1 = $fopen("Input","rb");
    c1 = $fread(tempMem,r1);
    $fclose(r1);
  end
  initial
  begin
    key = "PASS";
  end 
endmodule

//-------------------------------------------------------------------------------
//--tb_FinalProject.v---------------------------------------------------------
//--By Kyle Williams, 11/20/2012-------------------------------------------------
//--PROJECT DESCRIPTION----------------------------------------------------------
//----------------Define Modules to be used-------------------------------------- 
`include "ClockGenerator.v"
`include "Ram.v"
`include "TestInitRam.v"
`include "Encryption.v"
`include "Decryption.v"
module tb_FinalProject
  #(
      parameter BYTE = 8,
      parameter ADDR_WIDTH = BYTE,
      parameter WORD = 4*BYTE,//4 ascii letters
      parameter DATA_WIDTH = WORD,
      parameter MEM_DEPTH = 256
      //256 * 32 bytes = 8 kilobyte ram
  );
 
  wire clk;
  wire rst;
  wire[DATA_WIDTH-1:0] key;
  wor wr_enaA;
  wor wr_enaB;
  wor[ADDR_WIDTH-1:0] addrA;
  wor[ADDR_WIDTH-1:0] addrB;  
  wor[DATA_WIDTH-1:0] ram_inA;
  wor[DATA_WIDTH-1:0] ram_inB;
  wor[DATA_WIDTH-1:0] ram_outA;
  wor[DATA_WIDTH-1:0] ram_outB;
  wire finished;
  reg enableEncryption;
  wire encryptionFinished;
  reg enableDecryption;
  wire decryptionFinished;
  wire stage1;
  wire stage2;
  wire stage3;
  
  assign stage1 = finished;
  assign stage2 = encryptionFinished;
  assign stage3 = decryptionFinished;
  
  always@(*)
  begin
    if(encryptionFinished)begin
      enableEncryption <= 1'b0;
    end else if(stage1)begin
      enableEncryption <= 1'b1;
    end
    if(decryptionFinished)begin
      enableDecryption <= 1'b0;
    end else if(stage2)begin
      enableDecryption <= 1'b1;
    end
  end
  
  ClockGenerator cG(.clock(clk),
                    .reset(rst));
  
  Ram  #(.ADDR_WIDTH(ADDR_WIDTH),
         .DATA_WIDTH(DATA_WIDTH),
         .MEM_DEPTH(MEM_DEPTH))
  memory(.clk(clk),
         .addrA(addrA),
         .wr_enaA(wr_enaA),
         .ram_inA(ram_inA),
         .ram_outA(ram_outA),
         .addrB(addrB),
         .wr_enaB(wr_enaB),
         .ram_inB(ram_inB),
         .ram_outB(ram_outB));
         
  TestInitRam #(.ADDR_WIDTH(ADDR_WIDTH),
                .DATA_WIDTH(DATA_WIDTH),
                .MEM_DEPTH(MEM_DEPTH))  
  testMemory(.clk(clk),
             .rst(rst),
             .key(key),
             .finished(stage1),
             .addrA(addrA),
             .addrB(addrB),
             .wr_enaA(wr_enaA),
             .wr_enaB(wr_enaB),
             .data_outA(ram_inA),
             .data_outB(ram_inB));
     
  Encryption #(.ADDR_WIDTH(ADDR_WIDTH),
               .DATA_WIDTH(DATA_WIDTH),
              .MEM_DEPTH(MEM_DEPTH))
         AES  (.clk(clk),
               .rst(rst),
               .key(key),
               .ena(enableEncryption),
               .finished(encryptionFinished),
               .data_in(ram_outA),
               .memIn_addr(addrA),
               .mem_wr_ena(wr_enaB),
               .memOut_addr(addrB),
               .data_out(ram_inB));
              
  Decryption #(.ADDR_WIDTH(ADDR_WIDTH),
               .DATA_WIDTH(DATA_WIDTH),
              .MEM_DEPTH(MEM_DEPTH))
         DES  (.clk(clk),
               .rst(rst),
               .key(key),
               .ena(enableDecryption),
               .finished(decryptionFinished),
               .data_in(ram_outA),
               .memIn_addr(addrA),
               .mem_wr_ena(wr_enaB),
               .memOut_addr(addrB),
              .data_out(ram_inB));

endmodule
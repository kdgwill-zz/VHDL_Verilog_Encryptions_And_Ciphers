//----------------------------------------------------------------------------
//--By Kyle Williams, 11/20/2012-----------------------------------------------------
//--MODULE DESCRIPTION---------------------------------------------------------------
//----------------Simple single Port Ram used to store data--------------------------
//----------------reset is not required ram can be filled with useless data----------
//Instead of using a case statement it would be quicker to act on multiple data at once
//SHOULD BE MADE ABUNDANTLY CLEAR ANY BANK THAT IS ONLY PARTIALLY FILLED WILL BE DROPPED 
///ie 1011xxxx will be dropped since it is not fully displaying a word
module Decryption
  #(
      parameter ADDR_WIDTH = 4,
      parameter DATA_WIDTH = 8,
      parameter MEM_DEPTH = 64
  )(
//------------Input Ports------------
  input clk,
  input rst,
  input ena,
  input[DATA_WIDTH-1:0] key,
  input[DATA_WIDTH-1:0] data_in,
//------------Output Ports-----------
  output reg finished,
  output reg mem_wr_ena,
  output reg[ADDR_WIDTH-1:0] memIn_addr,
  output reg[ADDR_WIDTH-1:0] memOut_addr,
  output reg[DATA_WIDTH-1:0] data_out
  );
  parameter shift = DATA_WIDTH/2;//swap by nibbles instead of shift by address since Range must be bounded by constant expressions.
// ------------- Regs/ wires -----------
  //internal memory for encryption
  //store address then data in a memory module instead of seperate busses to keep design tidy and easier to follow
  parameter MEM_WIDTH = ADDR_WIDTH+DATA_WIDTH; 
  reg [MEM_WIDTH-1:0] mem [0:8];
  reg start;//need to be used to make sure initial statements are correct
  reg done;//needs to know when data becomes irrelevant and can stop hardware
  always@(posedge clk)
  begin:Main_Module
    case(rst)
    1'b0:
    if(ena==1'b1 && start==1'b0)begin
      start <= 1'b1;
      done <= 1'b0;
      memIn_addr <= {ADDR_WIDTH{1'b0}};
      memOut_addr <= {ADDR_WIDTH{1'b0}};
      data_out <= {DATA_WIDTH{1'b0}};
      mem_wr_ena <= 1'b0;
    end else 
    if(ena==1'b1) begin:Encryption
        begin:Stage_FetchData
          if(data_in!=={DATA_WIDTH{1'bx}})begin//bad practice but good assumption
            mem[0] <= {memIn_addr-1,data_in};//decrement address since process happens one clock cycle in the future
            memIn_addr <= memIn_addr+1;//increment m  ram address
          end else begin
            done <= 1'b1;
            mem[0] <= {MEM_WIDTH{1'b0}};
          end
        end
        begin:Stage0_Stage3_Stage7_AddRoundKey//XOR with pin append address to the end
              
              mem[1] <= |mem[0]==1'b0 ? mem[0] : {mem[0][ADDR_WIDTH+DATA_WIDTH-1:DATA_WIDTH],
                                                  mem[0][DATA_WIDTH-1:0] ^ key};
            
              mem[4] <= |mem[3]==1'b0 ? mem[3] : {mem[3][ADDR_WIDTH+DATA_WIDTH-1:DATA_WIDTH],
                                                  mem[3][DATA_WIDTH-1:0] ^ key};  
                                                 
              mem[8] <= |mem[7]==1'b0 ? mem[7] : {mem[7][ADDR_WIDTH+DATA_WIDTH-1:DATA_WIDTH],
                                                  mem[7][DATA_WIDTH-1:0] ^ key};
        end
        begin:Stage2_Stage6_SubBytes//Replace each byte according to loopup table
          //Due to complexity and time constraint instead use 2's compliment      
             mem[3] <= |mem[2]==1'b0 ? mem[2] : {mem[2][ADDR_WIDTH+DATA_WIDTH-1:DATA_WIDTH],
                                                 ~mem[2][DATA_WIDTH-1:0]+1'b1};
                   
             mem[7] <= |mem[6]==1'b0 ? mem[6] : {mem[6][ADDR_WIDTH+DATA_WIDTH-1:DATA_WIDTH],
                                                ~mem[6][DATA_WIDTH-1:0]+1'b1};
        end
        begin:Stage1_Stage5_ShiftRows
             mem[2] <= |mem[1]==1'b0 ? mem[1] : {mem[1][ADDR_WIDTH+DATA_WIDTH-1:DATA_WIDTH],
                        mem[1][shift:0],mem[1][DATA_WIDTH-1:shift+1]};//>>mem[1][ADDR_WIDTH+DATA_WIDTH-1:DATA_WIDTH]};
                                                 
             mem[6] <= |mem[5]==1'b0 ? mem[5] : {mem[5][ADDR_WIDTH+DATA_WIDTH-1:DATA_WIDTH],
                        mem[5][shift:0],mem[5][DATA_WIDTH-1:shift+1]};//<<mem[5][ADDR_WIDTH+DATA_WIDTH-1:DATA_WIDTH]};
        end
        begin:Stage4_MixColumns//multMatrix by a set amount...this section is not implimented correctly
        //due to time constraints data data by address
             mem[5] <= |mem[4]==1'b0 ? mem[4] : {mem[4][ADDR_WIDTH+DATA_WIDTH-1:DATA_WIDTH],
                         mem[4][DATA_WIDTH-1:0]-mem[4][ADDR_WIDTH+DATA_WIDTH-1:DATA_WIDTH]};
        end
        begin:Stage8_Push_Data//if Performing Bitwise & on all bits doesn't return 0 or 1 then no more data needs to be processed
          //placing & infront of a signal performs the AND operator on all bits
          if(mem[8]!=={MEM_WIDTH{1'b0}})begin
            mem_wr_ena  <= 1'b1;
            memOut_addr <= mem[8][ADDR_WIDTH+DATA_WIDTH-1:DATA_WIDTH];
            data_out    <= mem[8][DATA_WIDTH-1:0]; 
          end
          else if (done==1'b1) begin
            finished <= 1'b1;
            start <=1'b0;
            done <= 1'b0;
            mem_wr_ena <= 1'b0;
            memIn_addr <= {ADDR_WIDTH{1'b0}};
            memOut_addr <= {ADDR_WIDTH{1'b0}};
            data_out <= {DATA_WIDTH{1'b0}};
            $display("Decryption Completed");
          end 
        end
    end    
    1'b1: 
    begin:Reset    
      start <=1'b0;
      done <= 1'b0;
      finished <= 1'b0;  
      mem_wr_ena <= 1'b0;
      memIn_addr <= {ADDR_WIDTH{1'b0}};   
      memOut_addr <= {ADDR_WIDTH{1'b0}};
      data_out <= {DATA_WIDTH{1'b0}};
      mem[0] <= {MEM_WIDTH{1'b0}};
      mem[1] <= {MEM_WIDTH{1'b0}};
      mem[2] <= {MEM_WIDTH{1'b0}};
      mem[3] <= {MEM_WIDTH{1'b0}};
      mem[4] <= {MEM_WIDTH{1'b0}};
      mem[5] <= {MEM_WIDTH{1'b0}};
      mem[6] <= {MEM_WIDTH{1'b0}};
      mem[7] <= {MEM_WIDTH{1'b0}};
      mem[8] <= {MEM_WIDTH{1'b0}};
    end
    endcase
  end
endmodule

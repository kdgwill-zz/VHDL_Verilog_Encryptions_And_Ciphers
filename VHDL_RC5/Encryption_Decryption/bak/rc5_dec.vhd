LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;   -- we will use CONV_INTEGER
USE	WORK.RC5_PKG.ALL;

ENTITY rc5_dec IS
    PORT (
	clr,clk	: IN STD_LOGIC;  -- Asynchronous reset and Clock Signal
	din		: IN STD_LOGIC_VECTOR(63 DOWNTO 0);  -- 64-bit input
	di_vld	: IN STD_LOGIC; -- Valid Input
	key_rdy	: IN STD_LOGIC;
	skey	: IN  rc5_rom_26;
	dout	: OUT STD_LOGIC_VECTOR(63 DOWNTO 0); -- 64-bit output
	do_rdy	: OUT STD_LOGIC --Output is Ready
    );
END rc5_dec;

ARCHITECTURE rtl OF rc5_dec IS
    SIGNAL i_cnt	: STD_LOGIC_VECTOR(3 DOWNTO 0); -- round counter

	SIGNAL ba_xor	: STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL b_rot	: STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL b		: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL b_post	: STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL b_reg	: STD_LOGIC_VECTOR(31 DOWNTO 0); -- register B

    SIGNAL ab_xor	: STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL a_rot	: STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL a		: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL a_post	: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL a_reg	: STD_LOGIC_VECTOR(31 DOWNTO 0); -- register A

    ---- define a type for round keys
    --TYPE rom IS ARRAY (0 TO 25) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
    --CONSTANT skey : rom:=rom'(	X"9BBBD8C8", X"1A37F7FB", X"46F8E8C5", X"460C6085",
	--			X"70F83B8A", X"284B8303", X"513E1454", X"F621ED22",
	--			X"3125065D", X"11A83A5D", X"D427686B", X"713AD82D",
	--			X"4B792F99", X"2799A4DD", X"A7901C49", X"DEDE871A",
	--			X"36C03196", X"A7EFC249", X"61A78BB8", X"3B0A1D2B",
	--			X"4DBFCA76", X"AE162167", X"30D76B0A", X"43192304",
	--			X"F6CC1431",X"65046380");
				
	----RC5 state machine has five states
	--TYPE StateType IS(ST_IDLE, 		-- In this state RC5 is ready for input
    --                  ST_ROUND_OP,  -- In this state RC5 round op is performed. 
	--							    -- The state machine remains in this state
	--							    -- for twelve clock cycles.
	--				  ST_POST_ROUND, -- In this state RC5 post-round op is performed 
    --                  ST_READY 		-- In this state RC5 has completed encryption
    --                  );
   -- RC5 state machine has five states: idle, round, post_round and ready
   SIGNAL  state   :   dec_StateType;

BEGIN
    --B = ((B - S[2×i +1]) >>> A) xor A;
	b<=b_reg - skey(CONV_INTEGER(i_cnt & '1'));  -- S[2*i+1]
	WITH a_reg(4 DOWNTO 0) SELECT
      b_rot<= b(0)   & b(31 DOWNTO 01) WHEN "00001", --01
      b(01 DOWNTO 0) & b(31 DOWNTO 02) WHEN "00010", --02
      b(02 DOWNTO 0) & b(31 DOWNTO 03) WHEN "00011", --03
      b(03 DOWNTO 0) & b(31 DOWNTO 04) WHEN "00100", --04
      b(04 DOWNTO 0) & b(31 DOWNTO 05) WHEN "00101", --05
	  b(05 DOWNTO 0) & b(31 DOWNTO 06) WHEN "00110", --06
	  b(06 DOWNTO 0) & b(31 DOWNTO 07) WHEN "00111", --07
	  b(07 DOWNTO 0) & b(31 DOWNTO 08) WHEN "01000", --08
	  b(08 DOWNTO 0) & b(31 DOWNTO 09) WHEN "01001", --09
	  b(09 DOWNTO 0) & b(31 DOWNTO 10) WHEN "01010", --10
	  b(10 DOWNTO 0) & b(31 DOWNTO 11) WHEN "01011", --11
	  b(11 DOWNTO 0) & b(31 DOWNTO 12) WHEN "01100", --12
	  b(12 DOWNTO 0) & b(31 DOWNTO 13) WHEN "01101", --13
	  b(13 DOWNTO 0) & b(31 DOWNTO 14) WHEN "01110", --14
	  b(14 DOWNTO 0) & b(31 DOWNTO 15) WHEN "01111", --15
	  b(15 DOWNTO 0) & b(31 DOWNTO 16) WHEN "10000", --16
	  b(16 DOWNTO 0) & b(31 DOWNTO 17) WHEN "10001", --17
	  b(17 DOWNTO 0) & b(31 DOWNTO 18) WHEN "10010", --18
	  b(18 DOWNTO 0) & b(31 DOWNTO 19) WHEN "10011", --19
	  b(19 DOWNTO 0) & b(31 DOWNTO 20) WHEN "10100", --20
	  b(20 DOWNTO 0) & b(31 DOWNTO 21) WHEN "10101", --21
	  b(21 DOWNTO 0) & b(31 DOWNTO 22) WHEN "10110", --22
	  b(22 DOWNTO 0) & b(31 DOWNTO 23) WHEN "10111", --23
	  b(23 DOWNTO 0) & b(31 DOWNTO 24) WHEN "11000", --24
	  b(24 DOWNTO 0) & b(31 DOWNTO 25) WHEN "11001", --25
	  b(25 DOWNTO 0) & b(31 DOWNTO 26) WHEN "11010", --26
	  b(26 DOWNTO 0) & b(31 DOWNTO 27) WHEN "11011", --27
	  b(27 DOWNTO 0) & b(31 DOWNTO 28) WHEN "11100", --28
	  b(28 DOWNTO 0) & b(31 DOWNTO 29) WHEN "11101", --29  
      b(29 DOWNTO 0) & b(31 DOWNTO 30) WHEN "11110", --30
      b(30 DOWNTO 0) & b(31)           WHEN "11111", --31
      b 				    		   WHEN OTHERS;  --32		
	ba_xor <= b_rot XOR a_reg;
	b_post<=b_reg - skey(1); --B = B - S[1]			
	
    --A = ((A - S[2×i]) >>> B) xor B;
	a<=a_reg - skey(CONV_INTEGER(i_cnt & '0'));  -- S[2*i]
	WITH ba_xor(4 DOWNTO 0) SELECT
	a_rot<= a(0) 	  & a(31 DOWNTO 01) WHEN "00001", --01
      a(01 DOWNTO 0) & a(31 DOWNTO 02) WHEN "00010", --02
      a(02 DOWNTO 0) & a(31 DOWNTO 03) WHEN "00011", --03
      a(03 DOWNTO 0) & a(31 DOWNTO 04) WHEN "00100", --04
      a(04 DOWNTO 0) & a(31 DOWNTO 05) WHEN "00101", --05
	  a(05 DOWNTO 0) & a(31 DOWNTO 06) WHEN "00110", --06
	  a(06 DOWNTO 0) & a(31 DOWNTO 07) WHEN "00111", --07
	  a(07 DOWNTO 0) & a(31 DOWNTO 08) WHEN "01000", --08
	  a(08 DOWNTO 0) & a(31 DOWNTO 09) WHEN "01001", --09
	  a(09 DOWNTO 0) & a(31 DOWNTO 10) WHEN "01010", --10
	  a(10 DOWNTO 0) & a(31 DOWNTO 11) WHEN "01011", --11
	  a(11 DOWNTO 0) & a(31 DOWNTO 12) WHEN "01100", --12
	  a(12 DOWNTO 0) & a(31 DOWNTO 13) WHEN "01101", --13
	  a(13 DOWNTO 0) & a(31 DOWNTO 14) WHEN "01110", --14
	  a(14 DOWNTO 0) & a(31 DOWNTO 15) WHEN "01111", --15
	  a(15 DOWNTO 0) & a(31 DOWNTO 16) WHEN "10000", --16
	  a(16 DOWNTO 0) & a(31 DOWNTO 17) WHEN "10001", --17
	  a(17 DOWNTO 0) & a(31 DOWNTO 18) WHEN "10010", --18
	  a(18 DOWNTO 0) & a(31 DOWNTO 19) WHEN "10011", --19
	  a(19 DOWNTO 0) & a(31 DOWNTO 20) WHEN "10100", --20
	  a(20 DOWNTO 0) & a(31 DOWNTO 21) WHEN "10101", --21
	  a(21 DOWNTO 0) & a(31 DOWNTO 22) WHEN "10110", --22
	  a(22 DOWNTO 0) & a(31 DOWNTO 23) WHEN "10111", --23
	  a(23 DOWNTO 0) & a(31 DOWNTO 24) WHEN "11000", --24
	  a(24 DOWNTO 0) & a(31 DOWNTO 25) WHEN "11001", --25
	  a(25 DOWNTO 0) & a(31 DOWNTO 26) WHEN "11010", --26
	  a(26 DOWNTO 0) & a(31 DOWNTO 27) WHEN "11011", --27
	  a(27 DOWNTO 0) & a(31 DOWNTO 28) WHEN "11100", --28
	  a(28 DOWNTO 0) & a(31 DOWNTO 29) WHEN "11101", --29  
      a(29 DOWNTO 0) & a(31 DOWNTO 30) WHEN "11110", --30
      a(30 DOWNTO 0) & a(31)           WHEN "11111", --31
      a 				     		   WHEN OTHERS;  --32
	ab_xor <= a_rot XOR ba_xor;
	a_post<=a_reg - skey(0); --A = A - S[0]
	
A_register:
    PROCESS(clr, clk)  BEGIN
        IF(clr='0') THEN
           a_reg<=din(63 DOWNTO 32);
        ELSIF(rising_edge(clk)) THEN --clk'EVENT AND clk='1' can introduce error
           IF(state=ST_POST_ROUND) THEN   
				a_reg<=a_post;
			ELSIF(state=ST_ROUND_OP) THEN   
				a_reg<=ab_xor;   
			END IF;
        END IF;
    END PROCESS;

B_register:
    PROCESS(clr, clk)  BEGIN
        IF(clr='0') THEN
           b_reg<=din(31 DOWNTO 0);
        ELSIF(rising_edge(clk)) THEN
           IF(state=ST_POST_ROUND) THEN
				b_reg<=b_post;
			ELSIF(state=ST_ROUND_OP) THEN
				b_reg<=ba_xor;   
			END IF;
        END IF;
    END PROCESS;   

State_Control:
PROCESS(clr, clk)
   BEGIN
      IF(clr='0') THEN
         state<=ST_IDLE;
      ELSIF(clk'EVENT AND clk='1') THEN
         CASE state IS
            WHEN ST_IDLE=>      IF(di_vld='1' and key_rdy='1') THEN 
							    	state<=ST_ROUND_OP;  
							    END IF;
            WHEN ST_ROUND_OP=>  IF(i_cnt="0001") THEN 
									state<=ST_POST_ROUND;  
								END IF;
            WHEN ST_POST_ROUND=> state<=ST_READY;
            WHEN ST_READY=> IF(di_vld='1' and key_rdy='1') THEN 
										state<=ST_ROUND_OP;--can assume new keys and skip idle state
									--state<=ST_IDLE; --If Input Changes then restart
								END IF;
         END CASE;
      END IF;
   END PROCESS;

round_counter:
    PROCESS(clr, clk)  BEGIN
        IF(clr='0') THEN
           i_cnt<="1100";
        ELSIF(rising_edge(clk) AND state=ST_ROUND_OP) THEN
			IF(i_cnt="0001") THEN   
				i_cnt<="1100";
			ELSE
				i_cnt<=i_cnt-'1';    
			END IF;
        END IF;
    END PROCESS;
	
    dout<=a_reg & b_reg;
	
	WITH state SELECT
		do_rdy<='1' WHEN ST_READY,
				'0' WHEN OTHERS;
END rtl;
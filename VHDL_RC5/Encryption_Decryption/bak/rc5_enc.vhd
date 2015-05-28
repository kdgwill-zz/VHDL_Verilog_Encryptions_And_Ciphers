LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;   -- we will use CONV_INTEGER
USE	WORK.RC5_PKG.ALL;

ENTITY rc5_enc IS
    PORT (
	clr,clk	: IN STD_LOGIC;  -- Asynchronous reset and Clock Signal
	din		: IN STD_LOGIC_VECTOR(63 DOWNTO 0);  -- 64-bit input
	di_vld	: IN STD_LOGIC; -- Valid Input
	key_rdy	: IN STD_LOGIC;
	skey	: IN  rc5_rom_26;
	dout	: OUT STD_LOGIC_VECTOR(63 DOWNTO 0); -- 64-bit output
	do_rdy	: OUT STD_LOGIC --Output is Ready
     );
END rc5_enc;

ARCHITECTURE rtl OF rc5_enc IS
    SIGNAL i_cnt	: STD_LOGIC_VECTOR(3 DOWNTO 0); -- round counter

    SIGNAL ab_xor	: STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL a_rot	: STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL a		: STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL a_pre	: STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL a_reg	: STD_LOGIC_VECTOR(31 DOWNTO 0); -- register A

    SIGNAL ba_xor	: STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL b_rot	: STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL b		: STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL b_pre	: STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL b_reg	: STD_LOGIC_VECTOR(31 DOWNTO 0); -- register B

    ---- define a type for round keys
    --TYPE rom IS ARRAY (0 TO 25) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
    --CONSTANT skey : rom:=rom'(	X"9BBBD8C8", X"1A37F7FB", X"46F8E8C5", X"460C6085",
	--			X"70F83B8A", X"284B8303", X"513E1454", X"F621ED22",
	--			X"3125065D", X"11A83A5D", X"D427686B", X"713AD82D",
	--			X"4B792F99", X"2799A4DD", X"A7901C49", X"DEDE871A",
	--			X"36C03196", X"A7EFC249", X"61A78BB8", X"3B0A1D2B",
	--			X"4DBFCA76", X"AE162167", X"30D76B0A", X"43192304",
	--			X"F6CC1431",X"65046380");
	--			
	----RC5 state machine has five states
	--TYPE StateType IS(ST_IDLE, 		-- In this state RC5 is ready for input
    --                  ST_PRE_ROUND, -- In this state RC5 pre-round op is performed 
    --                  ST_ROUND_OP,  -- In this state RC5 round op is performed. 
	--							    -- The state machine remains in this state
	--							    -- for twelve clock cycles.
    --                  ST_READY 		-- In this state RC5 has completed encryption
    --                  );
   
   -- RC5 state machine has five states: idle, pre_round, round and ready
   SIGNAL  state   :   enc_StateType;

BEGIN
    -- A=((A XOR B)<<<B) + S[2*i];
	ab_xor <= a_reg XOR b_reg;
	WITH b_reg(4 DOWNTO 0) SELECT
		a_rot<= ab_xor(30 DOWNTO 0) & 	ab_xor(31) WHEN "00001", --01
		ab_xor(29 DOWNTO 0) & ab_xor(31 DOWNTO 30) WHEN "00010", --02
		ab_xor(28 DOWNTO 0) & ab_xor(31 DOWNTO 29) WHEN "00011", --03
		ab_xor(27 DOWNTO 0) & ab_xor(31 DOWNTO 28) WHEN "00100", --04
		ab_xor(26 DOWNTO 0) & ab_xor(31 DOWNTO 27) WHEN "00101", --05
		ab_xor(25 DOWNTO 0) & ab_xor(31 DOWNTO 26) WHEN "00110", --06
		ab_xor(24 DOWNTO 0) & ab_xor(31 DOWNTO 25) WHEN "00111", --07
		ab_xor(23 DOWNTO 0) & ab_xor(31 DOWNTO 24) WHEN "01000", --08
		ab_xor(22 DOWNTO 0) & ab_xor(31 DOWNTO 23) WHEN "01001", --09
		ab_xor(21 DOWNTO 0) & ab_xor(31 DOWNTO 22) WHEN "01010", --10
		ab_xor(20 DOWNTO 0) & ab_xor(31 DOWNTO 21) WHEN "01011", --11
		ab_xor(19 DOWNTO 0) & ab_xor(31 DOWNTO 20) WHEN "01100", --12
		ab_xor(18 DOWNTO 0) & ab_xor(31 DOWNTO 19) WHEN "01101", --13
		ab_xor(17 DOWNTO 0) & ab_xor(31 DOWNTO 18) WHEN "01110", --14
		ab_xor(16 DOWNTO 0) & ab_xor(31 DOWNTO 17) WHEN "01111", --15
		ab_xor(15 DOWNTO 0) & ab_xor(31 DOWNTO 16) WHEN "10000", --16
		ab_xor(14 DOWNTO 0) & ab_xor(31 DOWNTO 15) WHEN "10001", --17
		ab_xor(13 DOWNTO 0) & ab_xor(31 DOWNTO 14) WHEN "10010", --18
		ab_xor(12 DOWNTO 0) & ab_xor(31 DOWNTO 13) WHEN "10011", --19
		ab_xor(11 DOWNTO 0) & ab_xor(31 DOWNTO 12) WHEN "10100", --20
		ab_xor(10 DOWNTO 0) & ab_xor(31 DOWNTO 11) WHEN "10101", --21
		ab_xor(09 DOWNTO 0) & ab_xor(31 DOWNTO 10) WHEN "10110", --22
		ab_xor(08 DOWNTO 0) & ab_xor(31 DOWNTO 09) WHEN "10111", --23
		ab_xor(07 DOWNTO 0) & ab_xor(31 DOWNTO 08) WHEN "11000", --24
		ab_xor(06 DOWNTO 0) & ab_xor(31 DOWNTO 07) WHEN "11001", --25
		ab_xor(05 DOWNTO 0) & ab_xor(31 DOWNTO 06) WHEN "11010", --26
		ab_xor(04 DOWNTO 0) & ab_xor(31 DOWNTO 05) WHEN "11011", --27
		ab_xor(03 DOWNTO 0) & ab_xor(31 DOWNTO 04) WHEN "11100", --28
		ab_xor(02 DOWNTO 0) & ab_xor(31 DOWNTO 03) WHEN "11101", --29  
		ab_xor(01 DOWNTO 0) & ab_xor(31 DOWNTO 02) WHEN "11110", --30
		ab_xor(0) 	        & ab_xor(31 DOWNTO 01) WHEN "11111", --31
        ab_xor									   WHEN OTHERS;
	a_pre<=din(63 DOWNTO 32) + skey(0); --A = A + S[0]
	a<=a_rot + skey(CONV_INTEGER(i_cnt & '0'));  -- S[2*i]

    -- B=((B XOR A) <<<A)	+ S[2*i+1]
	ba_xor <= b_reg XOR a;
	WITH a(4 DOWNTO 0) SELECT
        b_rot<= ba_xor(30 DOWNTO 0) & ba_xor(31)   WHEN "00001", --01
		ba_xor(29 DOWNTO 0) & ba_xor(31 DOWNTO 30) WHEN "00010", --02
		ba_xor(28 DOWNTO 0) & ba_xor(31 DOWNTO 29) WHEN "00011", --03
		ba_xor(27 DOWNTO 0) & ba_xor(31 DOWNTO 28) WHEN "00100", --04
		ba_xor(26 DOWNTO 0) & ba_xor(31 DOWNTO 27) WHEN "00101", --05
		ba_xor(25 DOWNTO 0) & ba_xor(31 DOWNTO 26) WHEN "00110", --06
		ba_xor(24 DOWNTO 0) & ba_xor(31 DOWNTO 25) WHEN "00111", --07
		ba_xor(23 DOWNTO 0) & ba_xor(31 DOWNTO 24) WHEN "01000", --08
		ba_xor(22 DOWNTO 0) & ba_xor(31 DOWNTO 23) WHEN "01001", --09
		ba_xor(21 DOWNTO 0) & ba_xor(31 DOWNTO 22) WHEN "01010", --10
		ba_xor(20 DOWNTO 0) & ba_xor(31 DOWNTO 21) WHEN "01011", --11
		ba_xor(19 DOWNTO 0) & ba_xor(31 DOWNTO 20) WHEN "01100", --12
		ba_xor(18 DOWNTO 0) & ba_xor(31 DOWNTO 19) WHEN "01101", --13
		ba_xor(17 DOWNTO 0) & ba_xor(31 DOWNTO 18) WHEN "01110", --14
		ba_xor(16 DOWNTO 0) & ba_xor(31 DOWNTO 17) WHEN "01111", --15
		ba_xor(15 DOWNTO 0) & ba_xor(31 DOWNTO 16) WHEN "10000", --16
		ba_xor(14 DOWNTO 0) & ba_xor(31 DOWNTO 15) WHEN "10001", --17
		ba_xor(13 DOWNTO 0) & ba_xor(31 DOWNTO 14) WHEN "10010", --18
		ba_xor(12 DOWNTO 0) & ba_xor(31 DOWNTO 13) WHEN "10011", --19
		ba_xor(11 DOWNTO 0) & ba_xor(31 DOWNTO 12) WHEN "10100", --20
		ba_xor(10 DOWNTO 0) & ba_xor(31 DOWNTO 11) WHEN "10101", --21
		ba_xor(09 DOWNTO 0) & ba_xor(31 DOWNTO 10) WHEN "10110", --22
		ba_xor(08 DOWNTO 0) & ba_xor(31 DOWNTO 09) WHEN "10111", --23
		ba_xor(07 DOWNTO 0) & ba_xor(31 DOWNTO 08) WHEN "11000", --24
		ba_xor(06 DOWNTO 0) & ba_xor(31 DOWNTO 07) WHEN "11001", --25
		ba_xor(05 DOWNTO 0) & ba_xor(31 DOWNTO 06) WHEN "11010", --26
		ba_xor(04 DOWNTO 0) & ba_xor(31 DOWNTO 05) WHEN "11011", --27
		ba_xor(03 DOWNTO 0) & ba_xor(31 DOWNTO 04) WHEN "11100", --28
		ba_xor(02 DOWNTO 0) & ba_xor(31 DOWNTO 03) WHEN "11101", --29  
		ba_xor(01 DOWNTO 0) & ba_xor(31 DOWNTO 02) WHEN "11110", --30
		ba_xor(0)	    	& ba_xor(31 DOWNTO 01) WHEN "11111", --31
		ba_xor 									   WHEN OTHERS;
	b_pre<=din(31 DOWNTO 0) + skey(1); --B = B + S[1]
	b<=b_rot + skey(CONV_INTEGER(i_cnt & '1'));  -- S[2*i+1]

A_register:
    PROCESS(clr, clk)  BEGIN
        IF(clr='0') THEN 
			a_reg<=din(63 DOWNTO 32);
        ELSIF(rising_edge(clk)) THEN --clk'EVENT AND clk='1' can introduce error
			IF(state=ST_PRE_ROUND) THEN   
				a_reg<=a_pre;
			ELSIF(state=ST_ROUND_OP) THEN   
				a_reg<=a;   
			END IF;
		END IF;
    END PROCESS;

B_register:
    PROCESS(clr, clk)  BEGIN
        IF(clr='0') THEN
           b_reg<=din(31 DOWNTO 0);
        ELSIF(rising_edge(clk)) THEN
			IF(state=ST_PRE_ROUND) THEN
				b_reg<=b_pre;
			ELSIF(state=ST_ROUND_OP) THEN
				b_reg<=b;   
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
							    	state<=ST_PRE_ROUND;  
							    END IF;
            WHEN ST_PRE_ROUND=> state<=ST_ROUND_OP;
            WHEN ST_ROUND_OP=>  IF(i_cnt="1100") THEN 
									state<=ST_READY;  
								END IF;
            WHEN ST_READY=> IF(di_vld='1' and key_rdy='1') THEN 
										state<=ST_PRE_ROUND;--can assume new keys and skip idle state  
									--state<=ST_IDLE;--If Input Changes then restart
								END IF;
         END CASE;
      END IF;
   END PROCESS;

round_counter:
    PROCESS(clr, clk)  BEGIN
        IF(clr='0') THEN
           i_cnt<="0001";
        ELSIF(rising_edge(clk) AND state=ST_ROUND_OP) THEN
			IF(i_cnt="1100") THEN   
				i_cnt<="0001";
			ELSE
				i_cnt<=i_cnt+'1';    
			END IF;
        END IF;
    END PROCESS;
	
    dout<=a_reg & b_reg;
	
	WITH state SELECT
		do_rdy<='1' WHEN ST_READY,
				'0' WHEN OTHERS;
END rtl;
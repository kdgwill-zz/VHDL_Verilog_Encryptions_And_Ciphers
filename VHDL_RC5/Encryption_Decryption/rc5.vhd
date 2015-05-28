--RC5 Encryption
--A = A + S[0];
--B = B + S[1];
--for i=1 to 12 do
----A = ((A XOR B) <<< B) + S[2*i];
----B = ((B XOR A) <<< A) + S[2*1+1];
--RC5 Decryption
--for i=12 to 1 do
----B = ((B - S[2×i +1]) >>> A) xor A;
----A = ((A - S[2×i]) >>> B) xor B;
--B = B - S[1];
--A = A - S[0];


LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;   -- we will use CONV_INTEGER
USE	WORK.RC5_PKG.ALL;

ENTITY rc5 IS
    PORT (
		clr,clk	: IN STD_LOGIC;  -- Asynchronous reset and Clock Signal
		enc		: IN STD_LOGIC;  --1 for encryption 0 for decryption
		din		: IN STD_LOGIC_VECTOR(63 DOWNTO 0);  -- 64-bit input
		di_vld	: IN STD_LOGIC; -- Valid Input
		key_rdy	: IN STD_LOGIC;
		skey	: IN  rc5_rom_26;
		dout	: OUT STD_LOGIC_VECTOR(63 DOWNTO 0); -- 64-bit output
		do_rdy	: OUT STD_LOGIC --Output is Ready
    );
END rc5;

ARCHITECTURE rtl OF rc5 IS
    SIGNAL i_cnt	: STD_LOGIC_VECTOR(3 DOWNTO 0); -- round counter

    SIGNAL ab_xor	 	: STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL a_rot_left	: STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL a_rot_right	: STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL a		 	: STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL a_round	 	: STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL a_reg	 	: STD_LOGIC_VECTOR(31 DOWNTO 0); -- register A

    SIGNAL ba_xor		: STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL b_rot_left	: STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL b_rot_right	: STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL b			: STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL b_round		: STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL b_reg		: STD_LOGIC_VECTOR(31 DOWNTO 0); -- register B

   -- RC5 state machine has five states: idle, pre_round, round and ready
   SIGNAL  state   :   StateType;

BEGIN
	WITH enc SELECT 
		a_round	<=	din(63 DOWNTO 32) + skey(0) WHEN '1',--A = A + S[0]
					a_reg - skey(0) WHEN OTHERS; --A = A - S[0]
	
	WITH enc SELECT 
		b_round	<=	din(31 DOWNTO 0) + skey(1) WHEN '1', --B = B + S[1]
					b_reg - skey(1) WHEN OTHERS; --B = B - S[1]		

	WITH enc SELECT --A XOR B
		ab_xor<=a_reg XOR b_reg WHEN '1',
		        a_rot_right XOR ba_xor WHEN OTHERS;
	
	WITH enc SELECT --B XOR A
		ba_xor <= b_reg XOR a WHEN '1',
		          b_rot_right XOR a_reg WHEN OTHERS;
	
	WITH enc SELECT --B XOR A
		a	<=	a_rot_left + skey(CONV_INTEGER(i_cnt & '0')) WHEN '1',  --A + S[2*i]
				a_reg - skey(CONV_INTEGER(i_cnt & '0')) WHEN OTHERS; 	-- A - S[2*i]
	
	WITH enc SELECT --B XOR A
		b	<=	b_rot_left + skey(CONV_INTEGER(i_cnt & '1')) WHEN '1',  --B + S[2*i+1]
				b_reg - skey(CONV_INTEGER(i_cnt & '1')) WHEN OTHERS; 	--B - S[2*i+1]
	
	
	ROT_A_LEFT: rotLeft
	PORT MAP(din=>ab_xor,amnt=>b_reg(4 DOWNTO 0),dout=>a_rot_left);--A <<< B
	
	ROT_B_LEFT: rotLeft
	PORT MAP(din=>ba_xor,amnt=>a(4 DOWNTO 0),dout=>b_rot_left);--B <<< A
	
	ROT_B_RIGHT: rotRight
	PORT MAP(din=>b,amnt=>a_reg(4 DOWNTO 0),dout=>b_rot_right);--B >>> A
	
	ROT_A_RIGHT: rotRight
	PORT MAP(din=>a,amnt=>ba_xor(4 DOWNTO 0),dout=>a_rot_right);--A >>> B
	
	
A_register:
    PROCESS(clr, clk)  BEGIN
        IF(clr='0') THEN 
			a_reg<=din(63 DOWNTO 32);
        ELSIF(rising_edge(clk)) THEN --clk'EVENT AND clk='1' can introduce error
			IF(state=ST_PRE_ROUND OR state=ST_POST_ROUND) THEN   
				a_reg<=a_round;
			ELSIF(state=ST_ROUND_OP) THEN   
				if(enc = '1')then
					a_reg<=a;   
				else
					a_reg<=ab_xor;   
				end if;				
			END IF;
		END IF;
    END PROCESS;

B_register:
    PROCESS(clr, clk)  BEGIN
        IF(clr='0') THEN
           b_reg<=din(31 DOWNTO 0);
        ELSIF(rising_edge(clk)) THEN
			IF(state=ST_PRE_ROUND OR state=ST_POST_ROUND) THEN 
				b_reg<=b_round;
			ELSIF(state=ST_ROUND_OP) THEN
				if(enc = '1')then
					b_reg<=b;
				else
					b_reg<=ba_xor;   
				end if;
			END IF;
        END IF;
    END PROCESS;   

State_Control:
PROCESS(clr, clk)
   BEGIN
      IF(clr='0') THEN
         state<=ST_IDLE;
      ELSIF(rising_edge(clk)) THEN
         CASE state IS
            WHEN ST_IDLE=>      IF(di_vld='1' and key_rdy='1') THEN 
									IF(enc = '1') THEN
										state<=ST_PRE_ROUND;  
									ELSE
										state<=ST_ROUND_OP;  
									END IF;
							    END IF;
            WHEN ST_PRE_ROUND=> state<=ST_ROUND_OP;--Left because makes sense
            WHEN ST_ROUND_OP=>  IF(enc = '1') THEN
									IF(i_cnt="1100") THEN 
										state<=ST_READY;  
									END IF;
								ELSE
									IF(i_cnt="0001") THEN 
										state<=ST_POST_ROUND;  
									END IF;
								END IF;
            WHEN ST_POST_ROUND=> state<=ST_READY; --Left because makes sense
            WHEN ST_READY=> IF(di_vld='1' and key_rdy='1') THEN 
								state<=ST_IDLE;
							END IF;
         END CASE;
      END IF;
   END PROCESS;

round_counter:
    PROCESS(clk, enc)  BEGIN
		IF(clr='0') THEN
			i_cnt<="0001";
		ELSIF(rising_edge(clk)) THEN
			IF (state=ST_ROUND_OP) THEN
				if(enc='1')then
					IF(i_cnt="1100") THEN   
						i_cnt<="0001";
					ELSE
						i_cnt<=i_cnt+'1';    
					END IF;
				else
					IF(i_cnt="0001") THEN   
						i_cnt<="1100";
					ELSE
						i_cnt<=i_cnt-'1';    
					END IF;
				END IF;
			ELSIF(state=ST_PRE_ROUND)THEN
				i_cnt<="0001";
			ELSIF(state=ST_IDLE OR state = ST_READY)THEN
				i_cnt<="1100";
			END IF;
		END IF;
    END PROCESS;

    dout<=a_reg & b_reg;
	
	WITH state SELECT
		do_rdy<='1' WHEN ST_READY,
				'0' WHEN OTHERS;
END rtl;





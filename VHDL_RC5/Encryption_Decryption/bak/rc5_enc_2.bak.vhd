--RC5 Encryption
--A = A + S[0];
--B = B + S[1];
--for i=1 to 12 do
----A = ((A XOR B) <<< B) + S[2*i];
----B = ((B XOR A) <<< A) + S[2*1+1];

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

   -- RC5 state machine has five states: idle, pre_round, round and ready
   SIGNAL  state   :   enc_StateType;

BEGIN
	a_pre<=din(63 DOWNTO 32) + skey(0);--A = A + S[0]
	b_pre<=din(31 DOWNTO 0) + skey(1); --B = B + S[1]

    -- A=((A XOR B)<<<B) + S[2*i];
	ab_xor <= a_reg XOR b_reg;--A XOR B
	ROT_A_LEFT: rotLeft
	PORT MAP(din=>ab_xor,amnt=>b_reg(4 DOWNTO 0),dout=>a_rot);--A <<< B
	a<=a_rot + skey(CONV_INTEGER(i_cnt & '0'));  --A + S[2*i]

    -- B=((B XOR A) <<<A)	+ S[2*i+1]
	ba_xor <= b_reg XOR a; -- B XOR A
	ROT_B_LEFT: rotLeft
	PORT MAP(din=>ba_xor,amnt=>a(4 DOWNTO 0),dout=>b_rot);--B <<< A
	b<=b_rot + skey(CONV_INTEGER(i_cnt & '1'));  --B + S[2*i+1]

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
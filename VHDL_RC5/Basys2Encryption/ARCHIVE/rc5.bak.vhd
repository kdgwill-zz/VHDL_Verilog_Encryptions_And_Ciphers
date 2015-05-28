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

ENTITY rc5 IS
    PORT (
	-- Asynchronous reset and 25HzClock Signal
		clr,clk_25	 : IN STD_LOGIC;  
	--0 for encryption 1 for decryption
		enc		 	 : IN STD_LOGIC;  
	-- 8-bit input
		din_lower	 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);  
	-- Input is Valid
		di_vld	 	 : IN STD_LOGIC; 
	-- 7 Segment Display-bit output
		segment_a_i	 : OUT STD_LOGIC; 
		segment_b_i	 : OUT STD_LOGIC; 
		segment_c_i	 : OUT STD_LOGIC; 
		segment_d_i	 : OUT STD_LOGIC; 
		segment_e_i	 : OUT STD_LOGIC; 
		segment_f_i	 : OUT STD_LOGIC; 
		segment_g_i	 : OUT STD_LOGIC; 
	-- 7 Segment Control
	--Control Which of the four 7-Segment Display is active
		AN			 : OUT STD_LOGIC_VECTOR(3 downto 0);
	--Output is Ready
		do_rdy		 : OUT STD_LOGIC;
	--In Decryption Mode
		dec_mode	 : OUT STD_LOGIC
    );
END rc5;

ARCHITECTURE rtl OF rc5 IS
	SIGNAL din	 	: STD_LOGIC_VECTOR(63 DOWNTO 0);
	SIGNAL dout	 	: STD_LOGIC_VECTOR(63 DOWNTO 0);

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
	
	type rc5_rom_26 is array (0 to 25) of std_logic_vector(31 downto 0);
	CONSTANT skey		:rc5_rom_26:=rc5_rom_26'(
				X"9BBBD8C8", X"1A37F7FB", X"46F8E8C5", X"460C6085",
				X"70F83B8A", X"284B8303", X"513E1454", X"F621ED22",
				X"3125065D", X"11A83A5D", X"D427686B", X"713AD82D",
				X"4B792F99", X"2799A4DD", X"A7901C49", X"DEDE871A",
				X"36C03196", X"A7EFC249", X"61A78BB8", X"3B0A1D2B",
				X"4DBFCA76", X"AE162167", X"30D76B0A", X"43192304",
				X"F6CC1431", X"65046380");

   -- RC5 state machine has five states: idle, pre_round, round and ready
   TYPE StateType IS(
			ST_IDLE, 		-- In this state RC5 is ready for input
            ST_PRE_ROUND, 	-- In this state RC5 pre-round op is performed 
			ST_ROUND_OP,  	-- In this state RC5 round op is performed. 12 rounds
			ST_POST_ROUND, 	-- In this state RC5 post-round op is performed 
            ST_READY 		-- In this state RC5 has completed encryption
    );	
   SIGNAL  state   :   StateType;

	--LED Control
	SIGNAL hex_digit_i	 	: STD_LOGIC_VECTOR(3 DOWNTO 0);
	--Count to flash the LED
	SIGNAL LED_flash_cnt	 	: STD_LOGIC_VECTOR(9 DOWNTO 0);
BEGIN
	din <= X"00000000000000" & din_lower;
	
	WITH enc SELECT 
		a_round	<=	din(63 DOWNTO 32) + skey(0) WHEN '0',--A = A + S[0]
					a_reg - skey(0) WHEN OTHERS; --A = A - S[0]
	
	WITH enc SELECT 
		b_round	<=	din(31 DOWNTO 0) + skey(1) WHEN '0', --B = B + S[1]
					b_reg - skey(1) WHEN OTHERS; --B = B - S[1]		
    
	WITH enc SELECT --A XOR B
		ab_xor<=a_reg XOR b_reg WHEN '0',
		        a_rot_right XOR ba_xor WHEN OTHERS;
	
	WITH enc SELECT --B XOR A
		ba_xor <= b_reg XOR a WHEN '0',
		          b_rot_right XOR a_reg WHEN OTHERS;
	
	WITH enc SELECT --B XOR A
		a	<=	a_rot_left + skey(CONV_INTEGER(i_cnt & '0')) WHEN '0',  --A + S[2*i]
				a_reg - skey(CONV_INTEGER(i_cnt & '0')) WHEN OTHERS; 	-- A - S[2*i]
	
	WITH enc SELECT --B XOR A
		b	<=	b_rot_left + skey(CONV_INTEGER(i_cnt & '1')) WHEN '0',  --B + S[2*i+1]
				b_reg - skey(CONV_INTEGER(i_cnt & '1')) WHEN OTHERS; 	--B - S[2*i+1]
	
	----------------------ENCRYPTION
	ROT_A_LEFT : ENTITY work.rotLeft
	PORT MAP(din=>ab_xor,amnt=>b_reg(4 DOWNTO 0),dout=>a_rot_left);--A <<< B
	ROT_B_LEFT : ENTITY work.rotLeft
	PORT MAP(din=>ba_xor,amnt=>a(4 DOWNTO 0),dout=>b_rot_left);    --B <<< A
	
	------------------------DECRYPTION
	ROT_B_RIGHT : ENTITY work.rotRight
	PORT MAP(din=>b,amnt=>a_reg(4 DOWNTO 0),dout=>b_rot_right); 	--B >>> A
	ROT_A_RIGHT : ENTITY work.rotRight
	PORT MAP(din=>a,amnt=>ba_xor(4 DOWNTO 0),dout=>a_rot_right);	--A >>> B
	
	
A_register:
    PROCESS(clr, clk_25,din)  BEGIN
        IF(clr='1') THEN 
			a_reg<=din(63 DOWNTO 32);
        ELSIF(rising_edge(clk_25)) THEN
			IF(state=ST_PRE_ROUND OR state=ST_POST_ROUND) THEN   
				a_reg<=a_round;
			ELSIF(state=ST_ROUND_OP) THEN   
				if(enc = '0')then
					a_reg<=a;   
				else
					a_reg<=ab_xor;   
				end if;				
			END IF;
		END IF;
    END PROCESS;

B_register:
    PROCESS(clr, clk_25,din)  BEGIN
        IF(clr='1') THEN
           b_reg<=din(31 DOWNTO 0);
        ELSIF(rising_edge(clk_25)) THEN
			IF(state=ST_PRE_ROUND OR state=ST_POST_ROUND) THEN 
				b_reg<=b_round;
			ELSIF(state=ST_ROUND_OP) THEN
				if(enc = '0')then
					b_reg<=b;
				else
					b_reg<=ba_xor;   
				end if;
			END IF;
        END IF;
    END PROCESS;   

State_Control:
PROCESS(clr, clk_25)
   BEGIN
      IF(clr='1') THEN
         state<=ST_IDLE;
      ELSIF(rising_edge(clk_25)) THEN
         CASE state IS
            WHEN ST_IDLE=>      IF(di_vld='1') THEN 
									IF(enc = '0') THEN
										state<=ST_PRE_ROUND;  
									ELSE
										state<=ST_ROUND_OP;  
									END IF;
							    END IF;
            WHEN ST_PRE_ROUND=> state<=ST_ROUND_OP;--Left because makes sense
            WHEN ST_ROUND_OP=>  IF(enc = '0') THEN
									IF(i_cnt="1100") THEN 
										state<=ST_READY;  
									END IF;
								ELSE
									IF(i_cnt="0001") THEN 
										state<=ST_POST_ROUND;  
									END IF;
								END IF;
            WHEN ST_POST_ROUND=> state<=ST_READY; --Left because makes sense
            WHEN ST_READY=> IF(di_vld='1') THEN 
								state<=ST_IDLE;
							END IF;
         END CASE;
      END IF;
   END PROCESS;

round_counter:
    PROCESS(clk_25,clr, enc)  BEGIN
		IF(clr='1') THEN
			i_cnt<="0001";
		ELSIF(rising_edge(clk_25)) THEN
			IF (state=ST_ROUND_OP) THEN
				if(enc='0')then
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
		do_rdy<='1'	WHEN ST_READY,
				'0' WHEN OTHERS;
				
	dec_mode <= enc;
				
-------------------------------------------------
-------------------LED CONTROL-------------------
-------------------------------------------------

	--hex to 7 Segment Display
	hex2_7seg : ENTITY work.hex_7seg
	--This is a new effective way to instantiate
	--Rolls component and port map together
		PORT MAP(
			hex_digit => hex_digit_i,
			segment_a => segment_a_i,
			segment_b => segment_b_i,
			segment_c => segment_c_i,
			segment_d => segment_d_i,
			segment_e => segment_e_i,
			segment_f => segment_f_i,
			segment_g => segment_g_i
		);
	--Flash the LED with the last 4 bytes of dout
	PROCESS(clr,clk_25)
	BEGIN
		IF(clr='1')THEN
			hex_digit_i 	<= (others => '0');
			LED_flash_cnt	<= (others => '0');
			AN 				<= (others => '1');--All LED OFF
		ELSIF(rising_edge(clk_25)) THEN
			LED_flash_cnt <= LED_flash_cnt + '1';
			CASE LED_flash_cnt(9 downto 8) IS
				when "00" =>
					--First 7-Seg-LED
					hex_digit_i <= dout(15 downto 12);--LED output
					AN			<= "0111";			  --Enables LED
				when "01" =>
					--Second 7-Seg-LED
					hex_digit_i <= dout(11 downto 8);
					AN			<= "1011";
				when "10" =>
					--Third 7-Seg-LED
					hex_digit_i <= dout(7 downto 4);
					AN			<= "1101";
				when "11" =>
					--Fourth 7-Seg-LED
					hex_digit_i <= dout(3 downto 0);
					AN			<= "1110";
				when others => null;
			END CASE;
		END IF;
	END PROCESS;
END rtl;
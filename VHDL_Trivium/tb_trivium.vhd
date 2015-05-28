-----------------------------------------------------------------------------------
--Project Main Module--------------------------------------------------------------
--By Kyle D. Williams, 05/10/2015--------------------------------------------------
--PROJECT DESCRIPTION--------------------------------------------------------------
--1--Trivium Cipher----------------------------------------------------------------
--2--LOAD KEY DATA-----------------------------------------------------------------
--2--1--Use switches to set data---------------------------------------------------
--2--2--Use BTN-3 to shift data over 8 bits at a time until 10 shifts--------------
--2--3--Use BTN-2 to Skip or quickly complete data input---------------------------
--3--LOAD INITIALIZATION VECTOR----------------------------------------------------
--3--1--Use switches to set data---------------------------------------------------
--3--2--Use BTN-3 to shift data over 8 bits at a time until 10 shifts--------------
--3--3--Use BTN-2 to Skip or quickly complete data input---------------------------
--4--CIPHER STREAM APPEARS ON LED--------------------------------------------------
--4--1--use BT3 ir BT2 to cycle endless stream-------------------------------------
--5--USE BTN0 to reset-------------------------------------------------------------
-----------------------------------------------------------------------------------
----------------Define Libraries to be used----------------------------------------
library ieee ;
use ieee.std_logic_1164.all ;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;--used for conv_std_logic_vector

entity tb_trivium is
	port(	
		--Basic System Clock
	    clk_25		 : in std_logic; 	
		--Active low reset
		rst			 : in std_logic; 	
		--Next 8 bit input
		nxt 		 : in std_logic;
		--Skip to next input i.e complete shift and go to iv input
		skp 		 : in std_logic;
		--Use switches to shift in either
		--80-bit in key or
		--80-bit Initialization vector  
		input		 : in std_logic_vector(7 downto 0);		
		-- 7 Segment Display-bit output
		segment_a_i	 : out std_logic; 
		segment_b_i	 : out std_logic; 
		segment_c_i	 : out std_logic; 
		segment_d_i	 : out std_logic; 
		segment_e_i	 : out std_logic; 
		segment_f_i	 : out std_logic; 
		segment_g_i	 : out std_logic; 
		-- 7 Segment Control
		--Control Which of the four 7-Segment Display is active
		AN			 : out std_logic_vector(3 downto 0);
		--OUTPUT FOR DISPLAYING LED ON
		swtch_led 	 : out std_logic_vector(7 DOWNTO 0));
end tb_trivium;

architecture behavioral of tb_trivium is 
--I/O CONTROLS
	--used to check prev button state to determine button press
	signal nxt_buf_cur : std_logic;
	signal nxt_buf_prev : std_logic;
	--used to check prev button state to determine button press
	signal skp_buf_cur : std_logic;
	signal skp_buf_prev : std_logic;
--STATE CONTROLS
	-- trivium state machine has five states: keyInput, iv_input, run
   TYPE StateType IS(
			ST_IDLE,	 -- In this The System in powering on
			ST_KEY_INPUT,-- In this state the key is added
            ST_IV_INPUT, -- In this state the initialization vector is added
			ST_RUN_SYST, -- In this Trivium is free to run its cipher
			ST_READY 	 -- In this state Trivium is producing proper encryption pattern
    );	
	signal  state   :   StateType;
--TRIVIUM CONTROLS
	--Secret 80-bit key input port
	signal key	    : std_logic_vector(79 downto 0); 
	--80-bit Initialization vector input port
	signal IV	    : std_logic_vector(79 downto 0); 
	--shift in input counter for key and iv since input is 8 and size is 80
	signal inputCnt : integer;	
	--reset for trivium active low
	signal trivRst : std_logic;
	--Output Data Valid 
	signal o_rdy : std_logic;
	--Bit Stream
	signal z_out : std_logic_vector(15 downto 0);
	--This grants the ability to cycle through the buttons
	signal hld : std_logic;
--LED CONTROLS
	--LED Control
	signal hex_digit_i	 		: std_logic_vector(4 DOWNTO 0);
	--Count to flash the LED
	signal LED_flash_cnt	 	: std_logic_vector(9 DOWNTO 0);
begin

state_control:
	process(rst, clk_25) begin
		if(rst='1') then
			state<=ST_IDLE;
			trivRst <= '1';
		elsif(rising_edge(clk_25))then
			case state is
				when ST_IDLE=> 
					state<=ST_KEY_INPUT;
					trivRst <= '1';
				when ST_KEY_INPUT=>
					--need to add or skip to if block
					if(inputCnt = 10)then --10 = 80bits/(8 input bits)
						state<=ST_IV_INPUT;
					else 
						state<=ST_KEY_INPUT;
					end if;
					trivRst <= '1';
				when ST_IV_INPUT=>
					--need to add or skip to if block
					if(inputCnt = 10)then --10 = 80bits/(8 input bits)
						state<=ST_RUN_SYST;
						trivRst <= '0';
					else 
						state<= ST_IV_INPUT;
						trivRst <= '1';
					end if;
				when ST_RUN_SYST=>
					if(o_rdy = '1')then --Output ready to propogate
						state<=ST_READY;
					else
						state<=ST_RUN_SYST; 
					end if;
					trivRst <= '0';
				when ST_READY=>
					state<= ST_READY;
					trivRst <= '0';
			end case;
		end if;
	end process;

shift_in_input:
		process(rst,clk_25)begin
			if(rst='1')then
				key <= (others => '0');
				IV <= (others => '0');
				inputCnt <= 0;
				nxt_buf_cur <= '0';
				skp_buf_cur <= '0';
				nxt_buf_prev <= '0';
				skp_buf_prev <= '0';
				hld <= '1';
			elsif(rising_edge(clk_25))then
				case state is 
					when ST_KEY_INPUT | ST_IV_INPUT =>
						--we check button press by determining if current state is 0 and prev state is 1
						--first we impliment skp if it is tru then input count is automatically 10
						if(skp_buf_prev = '1' and skp_buf_cur = '0')then
							inputCnt <= 10;
						elsif(nxt_buf_prev = '1' and nxt_buf_cur = '0')then
							--count button presses
							inputCnt  <= inputCnt  + 1;
							--always shift into input 
							if(state = ST_KEY_INPUT)then
								key(79 downto 0) <= key(71 downto 0) & input(7 downto 0);
							else
								IV(79 downto 0)  <= IV(71 downto 0) & input(7 downto 0);
							end if;
						end if;	
						--Reset input count if it is too high
						if(inputCnt = 10)then
							inputCnt<=0;
						end if;
					when ST_READY =>
						--Lets give the user the ability to cycle through the cipher 16 bits at a time
						--And only if the previous 16 bits had already been ciphered
						if(((skp_buf_prev = '1' and skp_buf_cur = '0') or
						    (nxt_buf_prev = '1' and nxt_buf_cur = '0'))
						)then
							hld <= '0';
						else
							hld <= '1';
						end if;
					when others =>
						inputCnt <= 0;
				end case;
				--The press buttons on the Basys2 have capacitors in parallel with them
				--As such their is no issue with bouncing and no debounce logic is needed.
				nxt_buf_cur <= nxt;
				skp_buf_cur <= skp;
				--update prev button press
				nxt_buf_prev <= nxt_buf_cur;
				skp_buf_prev <= skp_buf_cur;
			end if;
		end process;
-------------------------------------------------
-------------------TRIVIUM-----------------------
-------------------------------------------------
	--Trivium encryption algorithm
	trivium : entity work.trivium
		port map(
			clk  => clk_25,
			rst  => trivRst,  
			hld  => hld,
			key  => key,	 	  --Secret 80-bit key input port
			IV   => IV,	 	  --80-bit Initialization vector input port
			o_vld=> o_rdy,		  --Output Data Ready
			z	 => z_Out --Cipher stream output
		);
-------------------------------------------------
-------------------LED CONTROL-------------------
-------------------------------------------------
	--hex to 7 Segment Display
	hex2_7seg : entity work.hex_7seg
		port map(
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
	process(rst,clk_25)
	begin
		if(rst='1')then
			hex_digit_i 	<= (others => '0');
			LED_flash_cnt	<= (others => '0');
			AN 				<= (others => '1');--All LED OFF
		elsif(rising_edge(clk_25)) then
			LED_flash_cnt <= LED_flash_cnt + '1';
			if(state=ST_READY)then
				case LED_flash_cnt(9 downto 8) is
					when "00" =>
						--First 7-Seg-LED
						hex_digit_i <= '0' & z_out(15 downto 12);--LED output  
						AN			<= "0111";			  			--Enables LED active low
					when "01" =>
						--Second 7-Seg-LED
						hex_digit_i <= '0' & z_out(11 downto 8);
						AN			<= "1011";
					when "10" =>
						--Third 7-Seg-LED
						hex_digit_i <= '0' & z_out( 7 downto 4);
						AN			<= "1101";
					when "11" =>
						--Fourth 7-Seg-LED
						hex_digit_i <= '0' & z_out( 3 downto 0);
						AN			<= "1110";
					when others => null;
				end case;
			elsif(state=ST_KEY_INPUT OR state=ST_IV_INPUT)then
				--In the event that the system is in keyinput or iv state
				--make the first two leds display LD and the last two count the numbers up
				case LED_flash_cnt(9 downto 8) is
					when "00" =>
						--First 7-Seg-LED
						hex_digit_i <= "10000";--Display 'L'  
						AN			<= "0111";--Enables LED active low
					when "01" =>
						--Second 7-Seg-LED
						hex_digit_i <= "01101";--Display 'd'
						AN			<= "1011";
					when "10" =>
						--Third 7-Seg-LED
						hex_digit_i <= "10001";--Display '-'
						AN			<= "1101";
					when "11" =>
						--Fourth 7-Seg-LED
						--the Mod operator and conv_integer function is incredibly costly 
						hex_digit_i <= conv_std_logic_vector(inputCnt,5);
						AN			<= "1110";
					when others => null;
				end case;
			else 
				--Just turn everything off otherwise
				hex_digit_i <= (others=>'1');
				AN			<= (others=>'1');
			end if;
		end if;
	end process;
	
--Quick trick to enable led over switches if active
swtch_led <= input;
end behavioral;
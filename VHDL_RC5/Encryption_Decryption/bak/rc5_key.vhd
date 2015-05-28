LIBRARY	IEEE;
USE	IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;   -- we will use CONV_INTEGER
USE	WORK.RC5_PKG.ALL;

entity rc5_key is
	port(	clr,clk	: in std_logic;  -- Asynchronous reset and Clock Signal
			key		: in std_logic_vector(127 downto 0);
			key_vld	: in std_logic;
			skey	: out rc5_rom_26;
			key_rdy	: out std_logic);
end rc5_key;

architecture key_exp of rc5_key is
	signal i_cnt  : std_logic_vector(04 downto 00); -- s_array counter
	signal j_cnt  : std_logic_vector(04 downto 00); -- l_array counter
	signal r_cnt  : std_logic_vector(06 downto 00); -- overall counterer; counts to 78
	
	signal a	  : std_logic_vector(31 downto 00);
	signal a_circ : std_logic_vector(31 downto 00);  
	signal a_reg  : std_logic_vector(31 downto 00); -- register A
                                                
	signal b	  : std_logic_vector(31 downto 00);
	signal b_circ : std_logic_vector(31 downto 00);
	signal b_reg  : std_logic_vector(31 downto 00); -- register B
	signal temp	  : std_logic_vector(31 downto 00);
	
	--Key Expansion state machine has five states: idle, key in, expansion and ready
	signal state  : rc5_key_StateType;
	signal l : rc5_rom_4;
	signal s : rc5_rom_26;

begin

	-- it is not a data-dependent rotation!
	--A = S[i] = (S[i] + A + B) <<< 3;
	a <= s(conv_integer(i_cnt)) + a_reg + b_reg; --S + A + B
	a_circ <= a(28 downto 0) & a(31 downto 29);  --rot by 3

	-- this is a data-dependent rotation!
	--B = L[j] = (L[j] + A + B) <<< (A + B);
	b <= l(conv_integer(j_cnt)) + a_circ + b_reg; --L + A + B	
	-- rot by A + B
	temp <= a_circ + b_reg;						  	
	with temp(4 downto 0) select
		  b_circ <= b(30 downto 0) & b(31) 			 when "00001", --01
					b(29 downto 0) & b(31 downto 30) when "00010", --02
					b(28 downto 0) & b(31 downto 29) when "00011", --03
					b(27 downto 0) & b(31 downto 28) when "00100", --04
					b(26 downto 0) & b(31 downto 27) when "00101", --05
					b(25 downto 0) & b(31 downto 26) when "00110", --06
					b(24 downto 0) & b(31 downto 25) when "00111", --07
					b(23 downto 0) & b(31 downto 24) when "01000", --08
					b(22 downto 0) & b(31 downto 23) when "01001", --09
					b(21 downto 0) & b(31 downto 22) when "01010", --10
					b(20 downto 0) & b(31 downto 21) when "01011", --11
					b(19 downto 0) & b(31 downto 20) when "01100", --12
					b(18 downto 0) & b(31 downto 19) when "01101", --13
					b(17 downto 0) & b(31 downto 18) when "01110", --14
					b(16 downto 0) & b(31 downto 17) when "01111", --15
					b(15 downto 0) & b(31 downto 16) when "10000", --16
					b(14 downto 0) & b(31 downto 15) when "10001", --17
					b(13 downto 0) & b(31 downto 14) when "10010", --18
					b(12 downto 0) & b(31 downto 13) when "10011", --19
					b(11 downto 0) & b(31 downto 12) when "10100", --20
					b(10 downto 0) & b(31 downto 11) when "10101", --21
					b(09 downto 0) & b(31 downto 10) when "10110", --22
					b(08 downto 0) & b(31 downto 09) when "10111", --23
					b(07 downto 0) & b(31 downto 08) when "11000", --24
					b(06 downto 0) & b(31 downto 07) when "11001", --25
					b(05 downto 0) & b(31 downto 06) when "11010", --26
					b(04 downto 0) & b(31 downto 05) when "11011", --27
					b(03 downto 0) & b(31 downto 04) when "11100", --28
					b(02 downto 0) & b(31 downto 03) when "11101", --29  
					b(01 downto 0) & b(31 downto 02) when "11110", --30
					b(0)	       & b(31 downto 01) when "11111", --31
					b 								 when others;

	state_block:
	process(clr, clk)
	begin
		if (clr = '0') then
			state <= st_idle;
		elsif (rising_edge(clk)) then
			case state is
				when st_idle =>
					if(key_vld = '1') then
						state <= st_key_in;
					end if;
				when st_key_in =>
					state <= st_key_exp;
				when st_key_exp =>
					if (r_cnt = "1001101") then
						state <= st_ready;
					end if;
				when st_ready =>
								IF( key_vld='1') THEN -- /= is not equals to
									state <= st_key_in; --in event of new key start at key_in 
														--state otherwise would be a timing issue
									--state<=ST_IDLE; --If Input Changes then restart
								END IF;
			end case;
		end if;
	end process;

	a_reg_block:
	process(clr, clk)
	begin
		if(clr = '0') then
			a_reg <= (others => '0');
		elsif (rising_edge(clk)) then
			if (state = st_key_exp) then
				a_reg <= a_circ;
			end if;
		end if;
	end process;

	b_reg_block:
	process(clr, clk)
	begin
		if(clr = '0') then
			b_reg <= (others => '0');
		elsif (rising_edge(clk)) then
			if (state = st_key_exp) then
				b_reg <= b_circ;
			end if;
		end if;
	end process;

	s_array_counter_block:
	process(clr, clk)
	begin
	if(clr='0') then  i_cnt<=(others=>'0');
	elsif(rising_edge(clk)) then
	   if(state=ST_KEY_EXP) then
		 if(i_cnt="11001")  then i_cnt <= (others=>'0');
		 else i_cnt <= i_cnt + 1;
		 end if;
	   end if;
	end if;
	end process;

	l_array_counter_block:
	process(clr, clk)
	begin
		if(clr='0') then  j_cnt<=(others=>'0');
		elsif(rising_edge(clk)) then
			 if(j_cnt="00011")  then j_cnt<=(others=>'0');
			 else   j_cnt <= j_cnt + 1;
			 end if;
		end if;
	end process;

	overall_counter_block:
	process(clr, clk)
	begin
		if (clr = '0') then
			r_cnt <= "0000000";
		elsif (rising_edge(clk)) then
			if (state = st_key_exp) then
				r_cnt <= r_cnt + 1; 
			end if;		
		end if;
	end process;

	--S[0] = 0xB7E15163 (Pw)
	--for i=1 to 25 do  S[i] = S[i-1]+ 0x9E3779B9 (Qw)
	--array s
	process(clr, clk)
	begin
		if (clr = '0') then
			s(0) <= X"b7e15163"; s(1) <= X"5618cb1c";s(2) <= X"f45044d5";
			s(3) <= X"9287be8e";s(4) <= X"30bf3847";s(5) <= X"cef6b200";
			s(6) <= X"6d2e2bb9";s(7) <= X"0b65a572";s(8) <= X"a99d1f2b";
			s(9) <= X"47d498e4";s(10) <= X"e60c129d";s(11) <= X"84438c56";
			s(12) <= X"227b060f";s(13) <= X"c0b27fc8";s(14) <= X"5ee9f981";
			s(15) <= X"fd21733a";s(16) <= X"9b58ecf3";s(17) <= X"399066ac";
			s(18) <= X"d7c7e065";s(19) <= X"75ff5a1e";s(20) <= X"1436d3d7";
			s(21) <= X"b26e4d90";s(22) <= X"50a5c749";s(23) <= X"eedd4102";
			s(24) <= X"8d14babb";s(25) <= X"2b4c3474";
		elsif (rising_edge(clk)) then
			if (state = st_key_exp) then
				 s(conv_integer(i_cnt)) <= a_circ;--i = (i + 1) mod 26; 
			end if;
		end if;
	end process;

	--l array
	process(clr, clk)
	begin
		if(clr = '0') then
		   l(0) <= (others=>'0');
		   l(1) <= (others=>'0');
		   l(2) <= (others=>'0');
		   l(3) <= (others=>'0');
		elsif (rising_edge(clk)) then
			if(state =  st_key_in) then
				l(0) <= key(31 downto 0);
				l(1) <= key(63 downto 32);
				l(2) <= key(95 downto 64);
				l(3) <= key(127 downto 96);
			elsif(state = st_key_exp) then
				l(conv_integer(j_cnt)) <= b_circ; --j = (j + 1) mod 4;
			end if;
		end if;
	end process;

	skey <= s;

	with state select
		 key_rdy <= '1' when st_ready,
					'0' when others;

end key_exp;
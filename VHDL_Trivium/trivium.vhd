--This software is provided 'as-is', without any express or implied warranty.
--In no event will the authors be held liable for any damages arising from the use of this software.
--
--Permission is granted to anyone to use this software for any purpose,
--excluding commercial applications, and to alter it and redistribute
--it freely except for commercial applications. 
--File:            trivium.vhd
--Original Author: Richard Stern (rstern01@utopia.poly.edu)
--Author	 : Kyle D. Williams (kdw281@nyu.edu)
--Organization:    Polytechnic University
--------------------------------------------------------
--Description: Trivium encryption algorithm
--------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity trivium is
	port(	
	   clk, rst : in std_logic; 				
		hld		: in std_logic; --active low if this is true then output is delayed until high again
		key	    : in std_logic_vector(79 downto 0); --Secret 80-bit key input port
		IV	    : in std_logic_vector(79 downto 0); --80-bit Initialization vector input port
		o_vld	: out std_logic;					--Cipher Ready
		z	    : out std_logic_vector(15 downto 0)	--Cipher stream output
	);
end trivium;

--key 	 = 0x00000000000000000000
--IV  	 = 0x00000000000000000000
--stream  = 0xFBE0BF265859051B517A...
architecture rtl of trivium is
signal z_reg     : std_logic_vector(15 downto 0);
signal z_reg_Buf : std_logic_vector(15 downto 0);

type state_type is (setup, run,hold);
signal state 			: state_type;					 --Current State
signal s, s_reg 		: std_logic_vector(288 downto 1);--Cipher's LFSR
signal count 			: integer;						 --Main Counter

signal count2			: integer;						 --buffer Counter
signal dat_rdy_buf	: std_logic;

--Cipher requires bigendian so flip bits
signal key_flip    :std_logic_vector(79 downto 0); --Secret 80-bit key input port
signal IV_flip	    :std_logic_vector(79 downto 0); --80-bit Initialization vector input port

function little_endian (b: std_logic_vector) return std_logic_vector is -- 80-bit Big Endian to Little Endian Convert (bit reverses each byte)
       variable result : std_logic_vector(79 downto 0);                 --ex 0x0123456789 -> 0x084C2A6E19 
begin
	for i in 0 to 9 loop
		result(((i*8)+7) downto (i*8)) :=       
			b(i*8) &
			b((i*8) + 1) &
            b((i*8) + 2) &
            b((i*8) + 3) &
            b((i*8) + 4) &
            b((i*8) + 5) &
            b((i*8) + 6) &
            b((i*8) + 7);
	end loop;
	return result;
end;

begin

z<=z_reg;
--z <= s_reg(66) xor s_reg(93) xor s_reg(162) xor s_reg(177) xor s_reg(243) xor s_reg(288);	
s(93 downto 1) <= s_reg(92 downto 1) & (s_reg(243) xor s_reg(288) xor (s_reg(286) and s_reg(287)) xor s_reg(69));
s(177 downto 94) <= s_reg(176 downto 94) & (s_reg(66) xor s_reg(93) xor (s_reg(91) and s_reg(92)) xor s_reg(171));
s(288 downto 178) <= s_reg(287 downto 178) & (s_reg(162) xor s_reg(177) xor (s_reg(175) and s_reg(176)) xor s_reg(264));

z_reg_process:
process(rst, clk) begin
	if(rst = '1') then
		z_reg <= (others => '0');
		z_reg_Buf <= (others => '0');
		count2 <= 0;
		dat_rdy_buf <= '0';
	elsif(rising_edge(clk)) then
		if(state = run)then
			if(count2 = 15)then--shift in 16 at a time
				count2 <= 0;		
				dat_rdy_buf <= '1';
				--in little endian form switch to little endian
				z_reg(7 downto 0) <= ((s_reg(66) xor s_reg(93) xor s_reg(162) xor s_reg(177) xor s_reg(243) xor s_reg(288)) & z_reg_Buf(15 downto 9));
				z_reg(15 downto 8)<=   z_reg_Buf(8 downto 1);
			else		
				count2 <= count2 + 1;
				dat_rdy_buf <= '0';
			end if;
			--Bits are in little endian reverse nibbles 
			z_reg_Buf <= (s_reg(66) xor s_reg(93) xor s_reg(162) xor s_reg(177) xor s_reg(243) xor s_reg(288)) & z_reg_Buf(15 downto 1);
		end if;
	end if;
end process;

s_reg_process:
process(rst, clk) begin
	if(rst = '1') then
		s_reg(80 downto 1) <= key_flip(79 downto 0);
		s_reg(93 downto 81) <= (others => '0');
		s_reg(173 downto 94) <= IV_flip(79 downto 0);
		s_reg(285 downto 174) <= (others => '0');
		s_reg(288 downto 286) <= (others => '1');
	elsif(rising_edge(clk)) then
		if(state /= hold)then
			s_reg <= s;
		end if;
	end if;
end process;

state_machine_process:
process(rst, clk) begin
	if (rst = '1') then
		state <= setup;
		count <= 1;
		o_vld <= '0';
	elsif(rising_edge(clk)) then
		case state is
			when setup =>
				if(count >= 1152) then --4 Cycles on 288 bits i.e. 4*288= 1152 passes
					state <= run;
					o_vld <= '1';
				else
					count <= count + 1;
					state <= setup;
					o_vld <= '0';
				end if;
			when run =>
				if(count2 = 15)then
					state <= hold;
				else
					state <= run;
				end if;
			when hold =>--this stops the data for the board to cycle
				if(hld = '0')then --button press
					state <= run;
				else
					state <= hold;
				end if;
		end case;
	end if;
end process;	

--Change input values to "little endian" so output matches offical test vectors
key_flip <= little_endian(key);
IV_flip  <= little_endian(iv);
end rtl;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY rotLeft IS
    PORT (
			din		: IN STD_LOGIC_VECTOR(31 DOWNTO 0);  -- Input to be rotated
			amnt 	: IN STD_LOGIC_VECTOR(4 DOWNTO 0);   --Amount to Rotate by
			dout	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0) -- Rotated Input
     );
END rotLeft;

ARCHITECTURE rtl OF rotLeft IS
BEGIN	
	WITH amnt SELECT -- din <<< amnt
		dout<= 
			din(30 DOWNTO 0) & din(31)			 WHEN "00001", --01
			din(29 DOWNTO 0) & din(31 DOWNTO 30) WHEN "00010", --02
			din(28 DOWNTO 0) & din(31 DOWNTO 29) WHEN "00011", --03
			din(27 DOWNTO 0) & din(31 DOWNTO 28) WHEN "00100", --04
			din(26 DOWNTO 0) & din(31 DOWNTO 27) WHEN "00101", --05
			din(25 DOWNTO 0) & din(31 DOWNTO 26) WHEN "00110", --06
			din(24 DOWNTO 0) & din(31 DOWNTO 25) WHEN "00111", --07
			din(23 DOWNTO 0) & din(31 DOWNTO 24) WHEN "01000", --08
			din(22 DOWNTO 0) & din(31 DOWNTO 23) WHEN "01001", --09
			din(21 DOWNTO 0) & din(31 DOWNTO 22) WHEN "01010", --10
			din(20 DOWNTO 0) & din(31 DOWNTO 21) WHEN "01011", --11
			din(19 DOWNTO 0) & din(31 DOWNTO 20) WHEN "01100", --12
			din(18 DOWNTO 0) & din(31 DOWNTO 19) WHEN "01101", --13
			din(17 DOWNTO 0) & din(31 DOWNTO 18) WHEN "01110", --14
			din(16 DOWNTO 0) & din(31 DOWNTO 17) WHEN "01111", --15
			din(15 DOWNTO 0) & din(31 DOWNTO 16) WHEN "10000", --16
			din(14 DOWNTO 0) & din(31 DOWNTO 15) WHEN "10001", --17
			din(13 DOWNTO 0) & din(31 DOWNTO 14) WHEN "10010", --18
			din(12 DOWNTO 0) & din(31 DOWNTO 13) WHEN "10011", --19
			din(11 DOWNTO 0) & din(31 DOWNTO 12) WHEN "10100", --20
			din(10 DOWNTO 0) & din(31 DOWNTO 11) WHEN "10101", --21
			din(09 DOWNTO 0) & din(31 DOWNTO 10) WHEN "10110", --22
			din(08 DOWNTO 0) & din(31 DOWNTO 09) WHEN "10111", --23
			din(07 DOWNTO 0) & din(31 DOWNTO 08) WHEN "11000", --24
			din(06 DOWNTO 0) & din(31 DOWNTO 07) WHEN "11001", --25
			din(05 DOWNTO 0) & din(31 DOWNTO 06) WHEN "11010", --26
			din(04 DOWNTO 0) & din(31 DOWNTO 05) WHEN "11011", --27
			din(03 DOWNTO 0) & din(31 DOWNTO 04) WHEN "11100", --28
			din(02 DOWNTO 0) & din(31 DOWNTO 03) WHEN "11101", --29  
			din(01 DOWNTO 0) & din(31 DOWNTO 02) WHEN "11110", --30
			din(0) 	         & din(31 DOWNTO 01) WHEN "11111", --31
			din									 WHEN OTHERS;
END rtl;

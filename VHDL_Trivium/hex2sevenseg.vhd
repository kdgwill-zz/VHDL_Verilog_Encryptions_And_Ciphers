------------  A
------------F 	B
------------  G
------------E	C
------------  D
------------ABCDEFG
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;
-- Hexadecimal to 7 Segment Decoder for LED Display
ENTITY hex_7seg IS
	PORT(
		hex_digit : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		segment_a, 
		segment_b, 
		segment_c, 
		segment_d, 
		segment_e,
		segment_f, 
		segment_g : OUT std_logic);
END hex_7seg;

ARCHITECTURE behavioral OF hex_7seg IS
	SIGNAL segment_data : STD_LOGIC_VECTOR(6 DOWNTO 0);
	BEGIN
	PROCESS (Hex_digit)
	-- HEX to 7 Segment Decoder for LED Display
	BEGIN
		-- Hex-digit is the four bit binary value to display in hexadecimal
		CASE Hex_digit IS
			WHEN "00000" =>			
				segment_data <= "0000001";--0
			WHEN "00001" =>
				segment_data <= "1001111";--1
			WHEN "00010" =>
				segment_data <= "0010010";--2
			WHEN "00011" =>
				segment_data <= "0000110";--3
			WHEN "00100" =>
				segment_data <= "1001100";--4
			WHEN "00101" =>
				segment_data <= "0100100";--5
			WHEN "00110" =>
				segment_data <= "0100000";--6
			WHEN "00111" =>
				segment_data <= "0001111";--7
			WHEN "01000" =>
				segment_data <= "0000000";--8
			WHEN "01001" =>
				segment_data <= "0000100";--9
			WHEN "01010" =>
				segment_data <= "0001000";--10 - A 
			WHEN "01011" =>
				segment_data <= "1100000";--11 - B
			WHEN "01100" =>
				segment_data <= "0110001";--12 - C
			WHEN "01101" =>
				segment_data <= "1000010";--13 - D
			WHEN "01110" =>
				segment_data <= "0110000";--14 - E
			WHEN "01111" =>
				segment_data <= "0111000";--15 - F
			WHEN "10000" =>
				segment_data <= "1110001";--L
			WHEN "10001" =>
				segment_data <= "1111110";--'-'
			WHEN OTHERS =>
				segment_data <= "1111111";
		END CASE;
	END PROCESS;
	-- extract segment data bits
	-- LED driver circuit
	segment_a <= segment_data(6);
	segment_b <= segment_data(5);
	segment_c <= segment_data(4);
	segment_d <= segment_data(3);
	segment_e <= segment_data(2);
	segment_f <= segment_data(1);
	segment_g <= segment_data(0);
END behavioral;
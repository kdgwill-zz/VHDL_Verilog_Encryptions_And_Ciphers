LIBRARY	IEEE;
USE	IEEE.STD_LOGIC_1164.ALL;

PACKAGE rc5_pkg IS
	type rc5_rom_26 is array (0 to 25) of std_logic_vector(31 downto 0);
	type rc5_rom_4 is array (0 to 3) of std_logic_vector(31 downto 0);
	type rc5_key_StateType is (ST_IDLE,    -- In this state RC5 key expansion is ready for input
							   ST_KEY_IN,  -- In this state key has been fully loaded
							   ST_KEY_EXP, -- In this state key expansion is in progress
							   ST_READY);  -- In this state RC5  key expansion has completed
END rc5_pkg;

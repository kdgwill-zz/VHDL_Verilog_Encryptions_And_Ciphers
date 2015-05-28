LIBRARY	IEEE;
USE	IEEE.STD_LOGIC_1164.ALL;

PACKAGE rc5_pkg IS
	type rc5_rom_26 is array (0 to 25) of std_logic_vector(31 downto 0);
	type rc5_rom_4 is array (0 to 3) of std_logic_vector(31 downto 0);
	type rc5_key_StateType is (ST_IDLE,    -- In this state RC5 key expansion is ready for input
							   ST_KEY_IN,  -- In this state key has been fully loaded
							   ST_KEY_EXP, -- In this state key expansion is in progress
							   ST_READY);  -- In this state RC5  key expansion has completed
	--RC5 state machine has five key states
	TYPE StateType IS(
			ST_IDLE, 		-- In this state RC5 is ready for input
            ST_PRE_ROUND, 	-- In this state RC5 pre-round op is performed 
							-- ENCRYPTION ONLY
							-- The reason it wasn't converged to only ST_ROUND
							----Is for logical reasons
            ST_ROUND_OP,  	-- In this state RC5 round op is performed. 
							-- The state machine remains in this state
							-- for twelve clock cycles.
			ST_POST_ROUND, 	-- In this state RC5 post-round op is performed 
							-- DECRYPTION ONLY
							-- The reason it wasn't converged to only ST_ROUND
							----Is for logical reasons
            ST_READY 		-- In this state RC5 has completed encryption
    );	
	
	COMPONENT rotLeft	-- Left Rotate Module
		PORT (
			din		: IN STD_LOGIC_VECTOR(31 DOWNTO 0);  -- Input to be rotated
			amnt 	: IN STD_LOGIC_VECTOR(4 DOWNTO 0);   --Amount to Rotate by
			dout	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0) -- Rotated Input
		 );
	END COMPONENT;
	
	COMPONENT rotRight	-- Right Rotate Module
		PORT (
				din		: IN STD_LOGIC_VECTOR(31 DOWNTO 0);  -- Input to be rotated
				amnt 	: IN STD_LOGIC_VECTOR(4 DOWNTO 0);   --Amount to Rotate by
				dout	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0) -- Rotated Input
			);
	END COMPONENT;
	
	COMPONENT  rc5_key  -- Key expansion module
		PORT(
				clr,clk	: IN STD_LOGIC;  -- Asynchronous reset and Clock Signal
				key		: in std_logic_vector(127 downto 0);
				key_vld	: in std_logic;
				skey	: out rc5_rom_26;
				key_rdy	: out std_logic
			);
	END COMPONENT;

	COMPONENT  rc5  -- Encryption module
		PORT(
				clr,clk	: IN STD_LOGIC;  -- Asynchronous reset and Clock Signal
				enc		: IN STD_LOGIC;  --1 for encryption 0 for decryption
				din		: IN STD_LOGIC_VECTOR(63 DOWNTO 0);  -- 64-bit input
				di_vld	: IN STD_LOGIC; -- Valid Input
				key_rdy	: IN STD_LOGIC;
				skey	: IN  rc5_rom_26;
				dout	: OUT STD_LOGIC_VECTOR(63 DOWNTO 0); -- 64-bit output
				do_rdy	: OUT STD_LOGIC --Output is Ready
			);
	END COMPONENT;
	
END rc5_pkg;

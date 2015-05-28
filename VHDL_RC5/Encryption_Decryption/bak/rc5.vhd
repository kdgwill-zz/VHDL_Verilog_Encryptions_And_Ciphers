LIBRARY	IEEE;
USE	IEEE.STD_LOGIC_1164.ALL;
USE	WORK.RC5_PKG.ALL;

ENTITY rc5 IS
   PORT (
      clr, clk	: IN  STD_LOGIC; -- Asynchronous reset and Clock Signal
      enc		: IN  STD_LOGIC; -- Encryption or decryption?
      key_vld	: IN  STD_LOGIC; -- Indicate the input is user key
      data_vld	: IN  STD_LOGIC; -- Indicate the input is user data
      din		: IN  STD_LOGIC_VECTOR(63 downto 0);
      dout		: OUT STD_LOGIC_VECTOR(63 downto 0);
      data_rdy	: OUT STD_LOGIC   -- Indicate the output data is ready
   );
END rc5;

ARCHITECTURE struct OF rc5 IS  -- Structural description
	signal skey		: rc5_rom_26;
    signal key_rdy	: std_logic;
    signal dout_enc	: std_logic_vector(63 downto 0);
    signal dout_dec	: std_logic_vector(63 downto 0);
    signal dec_rdy	: std_logic;
    signal enc_rdy	: std_logic;
	signal enc_clr 	: std_logic;
	signal dec_clr	: std_logic;
	--Key will be attached to din twice 
	signal key		: std_logic_vector(127 downto 0);
	

BEGIN
	enc_clr <= clr AND enc;
	dec_clr <= clr AND NOT enc;
	key(127 downto 64) <= din;
    key( 63 downto  0) <= din;

	U1: rc5_key 
	PORT MAP(clr=>clr, clk=>clk, key=>key, key_vld=>key_vld, --Input
							  skey=>skey, key_rdy=>key_rdy); --Output
	
	U2: rc5_enc 
	PORT MAP(clr=>enc_clr, clk=>clk, din=>din, di_vld=>data_vld, key_rdy=>key_rdy, skey=>skey, --Input
									  dout=>dout_enc, do_rdy=>enc_rdy); --Output
	U3: rc5_dec 
	PORT MAP(clr=>dec_clr, clk=>clk, din=>din, di_vld=>data_vld, key_rdy=>key_rdy, skey=>skey, --Input 
									  dout=>dout_dec, do_rdy=>dec_rdy); --Output

	
	WITH enc SELECT
		dout<=dout_enc WHEN '1',
		      dout_dec WHEN OTHERS;

	WITH enc SELECT
		data_rdy<=enc_rdy WHEN '1',
                  dec_rdy WHEN OTHERS;

END struct;

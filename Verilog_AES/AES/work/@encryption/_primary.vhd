library verilog;
use verilog.vl_types.all;
entity Encryption is
    generic(
        ADDR_WIDTH      : integer := 4;
        DATA_WIDTH      : integer := 8;
        MEM_DEPTH       : integer := 64
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        ena             : in     vl_logic;
        key             : in     vl_logic_vector;
        data_in         : in     vl_logic_vector;
        finished        : out    vl_logic;
        mem_wr_ena      : out    vl_logic;
        memIn_addr      : out    vl_logic_vector;
        memOut_addr     : out    vl_logic_vector;
        data_out        : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of ADDR_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of DATA_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of MEM_DEPTH : constant is 1;
end Encryption;

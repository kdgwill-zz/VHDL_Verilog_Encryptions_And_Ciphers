library verilog;
use verilog.vl_types.all;
entity TestInitRam is
    generic(
        ADDR_WIDTH      : integer := 4;
        DATA_WIDTH      : integer := 8;
        MEM_DEPTH       : integer := 64
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        key             : out    vl_logic_vector;
        finished        : out    vl_logic;
        addrA           : out    vl_logic_vector;
        addrB           : out    vl_logic_vector;
        wr_enaA         : out    vl_logic;
        wr_enaB         : out    vl_logic;
        data_outA       : out    vl_logic_vector;
        data_outB       : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of ADDR_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of DATA_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of MEM_DEPTH : constant is 1;
end TestInitRam;

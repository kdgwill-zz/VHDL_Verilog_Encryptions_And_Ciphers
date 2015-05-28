library verilog;
use verilog.vl_types.all;
entity Ram is
    generic(
        ADDR_WIDTH      : integer := 4;
        DATA_WIDTH      : integer := 8;
        MEM_DEPTH       : integer := 64
    );
    port(
        clk             : in     vl_logic;
        addrA           : in     vl_logic_vector;
        addrB           : in     vl_logic_vector;
        wr_enaA         : in     vl_logic;
        wr_enaB         : in     vl_logic;
        ram_inA         : in     vl_logic_vector;
        ram_inB         : in     vl_logic_vector;
        ram_outA        : out    vl_logic_vector;
        ram_outB        : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of ADDR_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of DATA_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of MEM_DEPTH : constant is 1;
end Ram;

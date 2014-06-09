library verilog;
use verilog.vl_types.all;
entity tb_FinalProject is
    generic(
        BYTE            : integer := 8;
        ADDR_WIDTH      : vl_notype;
        WORD            : vl_notype;
        DATA_WIDTH      : vl_notype;
        MEM_DEPTH       : integer := 256
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of BYTE : constant is 1;
    attribute mti_svvh_generic_type of ADDR_WIDTH : constant is 3;
    attribute mti_svvh_generic_type of WORD : constant is 3;
    attribute mti_svvh_generic_type of DATA_WIDTH : constant is 3;
    attribute mti_svvh_generic_type of MEM_DEPTH : constant is 1;
end tb_FinalProject;

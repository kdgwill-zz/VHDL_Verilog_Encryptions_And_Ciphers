library verilog;
use verilog.vl_types.all;
entity ClockGenerator is
    port(
        clock           : out    vl_logic;
        reset           : out    vl_logic
    );
end ClockGenerator;

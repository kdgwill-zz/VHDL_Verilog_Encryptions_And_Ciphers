--------------------------------------------------------------------------------
-- Copyright (c) 1995-2013 Xilinx, Inc.  All rights reserved.
--------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor: Xilinx
-- \   \   \/     Version: P.20131013
--  \   \         Application: netgen
--  /   /         Filename: rc5_key_timesim.vhd
-- /___/   /\     Timestamp: Tue Mar 17 12:20:07 2015
-- \   \  /  \ 
--  \___\/\___\
--             
-- Command	: -intstyle ise -s 4 -pcf rc5_key.pcf -rpw 100 -tpw 0 -ar Structure -tm rc5_key -insert_pp_buffers true -w -dir netgen/par -ofmt vhdl -sim rc5_key.ncd rc5_key_timesim.vhd 
-- Device	: 3s250eft256-4 (PRODUCTION 1.27 2013-10-13)
-- Input file	: rc5_key.ncd
-- Output file	: C:\SkyDrive\School\Polytechnic\EL6463_AdvancedHardwareDesign\Labs\Lab5\rc5_key_expansion\netgen\par\rc5_key_timesim.vhd
-- # of Entities	: 1
-- Design Name	: rc5_key
-- Xilinx	: C:\Xilinx\14.7\ISE_DS\ISE\
--             
-- Purpose:    
--     This VHDL netlist is a verification model and uses simulation 
--     primitives which may not represent the true implementation of the 
--     device, however the netlist is functionally correct and should not 
--     be modified. This file cannot be synthesized and should only be used 
--     with supported simulation tools.
--             
-- Reference:  
--     Command Line Tools User Guide, Chapter 23
--     Synthesis and Simulation Design Guide, Chapter 6
--             
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library SIMPRIM;
use SIMPRIM.VCOMPONENTS.ALL;
use SIMPRIM.VPACKAGE.ALL;

entity rc5_key is
  port (
    clk : in STD_LOGIC := 'X'; 
    clr : in STD_LOGIC := 'X'; 
    key_vld : in STD_LOGIC := 'X'; 
    key_rdy : out STD_LOGIC; 
    key : in STD_LOGIC_VECTOR ( 127 downto 0 ) 
  );
end rc5_key;

architecture Structure of rc5_key is
  signal clr_IBUF_96 : STD_LOGIC; 
  signal key_vld_IBUF_97 : STD_LOGIC; 
  signal clk_BUFGP : STD_LOGIC; 
  signal state_cmp_eq0001_0 : STD_LOGIC; 
  signal state_FSM_FFd2_109 : STD_LOGIC; 
  signal state_FSM_FFd2_In16_O : STD_LOGIC; 
  signal state_FSM_FFd2_In40_0 : STD_LOGIC; 
  signal state_FSM_FFd2_In4_0 : STD_LOGIC; 
  signal state_FSM_FFd1_113 : STD_LOGIC; 
  signal clk_INBUF : STD_LOGIC; 
  signal key_rdy_O : STD_LOGIC; 
  signal clr_INBUF : STD_LOGIC; 
  signal key_vld_INBUF : STD_LOGIC; 
  signal clk_BUFGP_BUFG_S_INVNOT : STD_LOGIC; 
  signal clk_BUFGP_BUFG_I0_INV : STD_LOGIC; 
  signal r_cnt_4_FFX_RST : STD_LOGIC; 
  signal r_cnt_4_DXMUX_175 : STD_LOGIC; 
  signal Mcount_r_cnt_cy_3_pack_2 : STD_LOGIC; 
  signal r_cnt_4_CLKINV_157 : STD_LOGIC; 
  signal r_cnt_4_CEINV_156 : STD_LOGIC; 
  signal r_cnt_3_DXMUX_221 : STD_LOGIC; 
  signal r_cnt_3_DYMUX_206 : STD_LOGIC; 
  signal r_cnt_3_SRINVNOT : STD_LOGIC; 
  signal r_cnt_3_CLKINV_196 : STD_LOGIC; 
  signal r_cnt_3_CEINV_195 : STD_LOGIC; 
  signal r_cnt_6_DXMUX_267 : STD_LOGIC; 
  signal r_cnt_6_DYMUX_252 : STD_LOGIC; 
  signal r_cnt_6_SRINVNOT : STD_LOGIC; 
  signal r_cnt_6_CLKINV_242 : STD_LOGIC; 
  signal r_cnt_6_CEINV_241 : STD_LOGIC; 
  signal state_FSM_FFd2_DXMUX_313 : STD_LOGIC; 
  signal state_FSM_FFd2_In : STD_LOGIC; 
  signal state_FSM_FFd2_DYMUX_299 : STD_LOGIC; 
  signal state_FSM_FFd2_In16_O_pack_3 : STD_LOGIC; 
  signal state_FSM_FFd2_SRINVNOT : STD_LOGIC; 
  signal state_FSM_FFd2_CLKINV_289 : STD_LOGIC; 
  signal state_cmp_eq0001 : STD_LOGIC; 
  signal state_FSM_FFd2_In40_332 : STD_LOGIC; 
  signal r_cnt_1_DXMUX_385 : STD_LOGIC; 
  signal r_cnt_1_DYMUX_368 : STD_LOGIC; 
  signal state_FSM_FFd2_In4_365 : STD_LOGIC; 
  signal r_cnt_1_SRINVNOT : STD_LOGIC; 
  signal r_cnt_1_CLKINV_357 : STD_LOGIC; 
  signal r_cnt_1_CEINV_356 : STD_LOGIC; 
  signal key_rdy_OBUF_402 : STD_LOGIC; 
  signal GND : STD_LOGIC; 
  signal VCC : STD_LOGIC; 
  signal r_cnt : STD_LOGIC_VECTOR ( 6 downto 0 ); 
  signal Mcount_r_cnt_cy : STD_LOGIC_VECTOR ( 3 downto 3 ); 
  signal Result : STD_LOGIC_VECTOR ( 6 downto 1 ); 
begin
  clk_BUFGP_IBUFG : X_BUF
    generic map(
      LOC => "IPAD21",
      PATHPULSE => 638 ps
    )
    port map (
      I => clk,
      O => clk_INBUF
    );
  key_rdy_OBUF : X_OBUF
    generic map(
      LOC => "PAD39"
    )
    port map (
      I => key_rdy_O,
      O => key_rdy
    );
  clr_IBUF : X_BUF
    generic map(
      LOC => "PAD43",
      PATHPULSE => 638 ps
    )
    port map (
      I => clr,
      O => clr_INBUF
    );
  key_vld_IBUF : X_BUF
    generic map(
      LOC => "PAD42",
      PATHPULSE => 638 ps
    )
    port map (
      I => key_vld,
      O => key_vld_INBUF
    );
  clk_BUFGP_BUFG : X_BUFGMUX
    generic map(
      LOC => "BUFGMUX_X2Y10"
    )
    port map (
      I0 => clk_BUFGP_BUFG_I0_INV,
      I1 => GND,
      S => clk_BUFGP_BUFG_S_INVNOT,
      O => clk_BUFGP
    );
  clk_BUFGP_BUFG_SINV : X_INV
    generic map(
      LOC => "BUFGMUX_X2Y10",
      PATHPULSE => 638 ps
    )
    port map (
      I => '1',
      O => clk_BUFGP_BUFG_S_INVNOT
    );
  clk_BUFGP_BUFG_I0_USED : X_BUF
    generic map(
      LOC => "BUFGMUX_X2Y10",
      PATHPULSE => 638 ps
    )
    port map (
      I => clk_INBUF,
      O => clk_BUFGP_BUFG_I0_INV
    );
  r_cnt_4_FFX_RSTOR : X_INV
    generic map(
      LOC => "SLICE_X40Y65",
      PATHPULSE => 638 ps
    )
    port map (
      I => clr_IBUF_96,
      O => r_cnt_4_FFX_RST
    );
  r_cnt_4 : X_FF
    generic map(
      LOC => "SLICE_X40Y65",
      INIT => '0'
    )
    port map (
      I => r_cnt_4_DXMUX_175,
      CE => r_cnt_4_CEINV_156,
      CLK => r_cnt_4_CLKINV_157,
      SET => GND,
      RST => r_cnt_4_FFX_RST,
      O => r_cnt(4)
    );
  r_cnt_4_DXMUX : X_BUF
    generic map(
      LOC => "SLICE_X40Y65",
      PATHPULSE => 638 ps
    )
    port map (
      I => Result(4),
      O => r_cnt_4_DXMUX_175
    );
  r_cnt_4_YUSED : X_BUF
    generic map(
      LOC => "SLICE_X40Y65",
      PATHPULSE => 638 ps
    )
    port map (
      I => Mcount_r_cnt_cy_3_pack_2,
      O => Mcount_r_cnt_cy(3)
    );
  r_cnt_4_CLKINV : X_BUF
    generic map(
      LOC => "SLICE_X40Y65",
      PATHPULSE => 638 ps
    )
    port map (
      I => clk_BUFGP,
      O => r_cnt_4_CLKINV_157
    );
  r_cnt_4_CEINV : X_BUF
    generic map(
      LOC => "SLICE_X40Y65",
      PATHPULSE => 638 ps
    )
    port map (
      I => state_cmp_eq0001_0,
      O => r_cnt_4_CEINV_156
    );
  Mcount_r_cnt_xor_4_11 : X_LUT4
    generic map(
      INIT => X"3C3C",
      LOC => "SLICE_X40Y65"
    )
    port map (
      ADR0 => VCC,
      ADR1 => r_cnt(4),
      ADR2 => Mcount_r_cnt_cy(3),
      ADR3 => VCC,
      O => Result(4)
    );
  r_cnt_3_DXMUX : X_BUF
    generic map(
      LOC => "SLICE_X41Y67",
      PATHPULSE => 638 ps
    )
    port map (
      I => Result(3),
      O => r_cnt_3_DXMUX_221
    );
  r_cnt_3_DYMUX : X_BUF
    generic map(
      LOC => "SLICE_X41Y67",
      PATHPULSE => 638 ps
    )
    port map (
      I => Result(2),
      O => r_cnt_3_DYMUX_206
    );
  r_cnt_3_SRINV : X_INV
    generic map(
      LOC => "SLICE_X41Y67",
      PATHPULSE => 638 ps
    )
    port map (
      I => clr_IBUF_96,
      O => r_cnt_3_SRINVNOT
    );
  r_cnt_3_CLKINV : X_BUF
    generic map(
      LOC => "SLICE_X41Y67",
      PATHPULSE => 638 ps
    )
    port map (
      I => clk_BUFGP,
      O => r_cnt_3_CLKINV_196
    );
  r_cnt_3_CEINV : X_BUF
    generic map(
      LOC => "SLICE_X41Y67",
      PATHPULSE => 638 ps
    )
    port map (
      I => state_cmp_eq0001_0,
      O => r_cnt_3_CEINV_195
    );
  Mcount_r_cnt_xor_5_11 : X_LUT4
    generic map(
      INIT => X"3CF0",
      LOC => "SLICE_X41Y64"
    )
    port map (
      ADR0 => VCC,
      ADR1 => Mcount_r_cnt_cy(3),
      ADR2 => r_cnt(5),
      ADR3 => r_cnt(4),
      O => Result(5)
    );
  r_cnt_6_DXMUX : X_BUF
    generic map(
      LOC => "SLICE_X41Y64",
      PATHPULSE => 638 ps
    )
    port map (
      I => Result(6),
      O => r_cnt_6_DXMUX_267
    );
  r_cnt_6_DYMUX : X_BUF
    generic map(
      LOC => "SLICE_X41Y64",
      PATHPULSE => 638 ps
    )
    port map (
      I => Result(5),
      O => r_cnt_6_DYMUX_252
    );
  r_cnt_6_SRINV : X_INV
    generic map(
      LOC => "SLICE_X41Y64",
      PATHPULSE => 638 ps
    )
    port map (
      I => clr_IBUF_96,
      O => r_cnt_6_SRINVNOT
    );
  r_cnt_6_CLKINV : X_BUF
    generic map(
      LOC => "SLICE_X41Y64",
      PATHPULSE => 638 ps
    )
    port map (
      I => clk_BUFGP,
      O => r_cnt_6_CLKINV_242
    );
  r_cnt_6_CEINV : X_BUF
    generic map(
      LOC => "SLICE_X41Y64",
      PATHPULSE => 638 ps
    )
    port map (
      I => state_cmp_eq0001_0,
      O => r_cnt_6_CEINV_241
    );
  state_FSM_FFd2_DXMUX : X_BUF
    generic map(
      LOC => "SLICE_X40Y67",
      PATHPULSE => 638 ps
    )
    port map (
      I => state_FSM_FFd2_In,
      O => state_FSM_FFd2_DXMUX_313
    );
  state_FSM_FFd2_DYMUX : X_BUF
    generic map(
      LOC => "SLICE_X40Y67",
      PATHPULSE => 638 ps
    )
    port map (
      I => state_FSM_FFd2_109,
      O => state_FSM_FFd2_DYMUX_299
    );
  state_FSM_FFd2_YUSED : X_BUF
    generic map(
      LOC => "SLICE_X40Y67",
      PATHPULSE => 638 ps
    )
    port map (
      I => state_FSM_FFd2_In16_O_pack_3,
      O => state_FSM_FFd2_In16_O
    );
  state_FSM_FFd2_SRINV : X_INV
    generic map(
      LOC => "SLICE_X40Y67",
      PATHPULSE => 638 ps
    )
    port map (
      I => clr_IBUF_96,
      O => state_FSM_FFd2_SRINVNOT
    );
  state_FSM_FFd2_CLKINV : X_BUF
    generic map(
      LOC => "SLICE_X40Y67",
      PATHPULSE => 638 ps
    )
    port map (
      I => clk_BUFGP,
      O => state_FSM_FFd2_CLKINV_289
    );
  state_cmp_eq0001_XUSED : X_BUF
    generic map(
      LOC => "SLICE_X40Y64",
      PATHPULSE => 638 ps
    )
    port map (
      I => state_cmp_eq0001,
      O => state_cmp_eq0001_0
    );
  state_cmp_eq0001_YUSED : X_BUF
    generic map(
      LOC => "SLICE_X40Y64",
      PATHPULSE => 638 ps
    )
    port map (
      I => state_FSM_FFd2_In40_332,
      O => state_FSM_FFd2_In40_0
    );
  r_cnt_1_DXMUX : X_BUF
    generic map(
      LOC => "SLICE_X41Y65",
      PATHPULSE => 638 ps
    )
    port map (
      I => Result(1),
      O => r_cnt_1_DXMUX_385
    );
  r_cnt_1_DYMUX : X_INV
    generic map(
      LOC => "SLICE_X41Y65",
      PATHPULSE => 638 ps
    )
    port map (
      I => r_cnt(0),
      O => r_cnt_1_DYMUX_368
    );
  r_cnt_1_YUSED : X_BUF
    generic map(
      LOC => "SLICE_X41Y65",
      PATHPULSE => 638 ps
    )
    port map (
      I => state_FSM_FFd2_In4_365,
      O => state_FSM_FFd2_In4_0
    );
  r_cnt_1_SRINV : X_INV
    generic map(
      LOC => "SLICE_X41Y65",
      PATHPULSE => 638 ps
    )
    port map (
      I => clr_IBUF_96,
      O => r_cnt_1_SRINVNOT
    );
  r_cnt_1_CLKINV : X_BUF
    generic map(
      LOC => "SLICE_X41Y65",
      PATHPULSE => 638 ps
    )
    port map (
      I => clk_BUFGP,
      O => r_cnt_1_CLKINV_357
    );
  r_cnt_1_CEINV : X_BUF
    generic map(
      LOC => "SLICE_X41Y65",
      PATHPULSE => 638 ps
    )
    port map (
      I => state_cmp_eq0001_0,
      O => r_cnt_1_CEINV_356
    );
  r_cnt_1 : X_FF
    generic map(
      LOC => "SLICE_X41Y65",
      INIT => '0'
    )
    port map (
      I => r_cnt_1_DXMUX_385,
      CE => r_cnt_1_CEINV_356,
      CLK => r_cnt_1_CLKINV_357,
      SET => GND,
      RST => r_cnt_1_SRINVNOT,
      O => r_cnt(1)
    );
  state_FSM_FFd2 : X_FF
    generic map(
      LOC => "SLICE_X40Y67",
      INIT => '0'
    )
    port map (
      I => state_FSM_FFd2_DXMUX_313,
      CE => VCC,
      CLK => state_FSM_FFd2_CLKINV_289,
      SET => GND,
      RST => state_FSM_FFd2_SRINVNOT,
      O => state_FSM_FFd2_109
    );
  clr_IFF_IMUX : X_BUF
    generic map(
      LOC => "PAD43",
      PATHPULSE => 638 ps
    )
    port map (
      I => clr_INBUF,
      O => clr_IBUF_96
    );
  key_vld_IFF_IMUX : X_BUF
    generic map(
      LOC => "PAD42",
      PATHPULSE => 638 ps
    )
    port map (
      I => key_vld_INBUF,
      O => key_vld_IBUF_97
    );
  Mcount_r_cnt_cy_3_11 : X_LUT4
    generic map(
      INIT => X"8000",
      LOC => "SLICE_X40Y65"
    )
    port map (
      ADR0 => r_cnt(3),
      ADR1 => r_cnt(2),
      ADR2 => r_cnt(0),
      ADR3 => r_cnt(1),
      O => Mcount_r_cnt_cy_3_pack_2
    );
  Mcount_r_cnt_xor_2_11 : X_LUT4
    generic map(
      INIT => X"5AAA",
      LOC => "SLICE_X41Y67"
    )
    port map (
      ADR0 => r_cnt(2),
      ADR1 => VCC,
      ADR2 => r_cnt(1),
      ADR3 => r_cnt(0),
      O => Result(2)
    );
  r_cnt_2 : X_FF
    generic map(
      LOC => "SLICE_X41Y67",
      INIT => '0'
    )
    port map (
      I => r_cnt_3_DYMUX_206,
      CE => r_cnt_3_CEINV_195,
      CLK => r_cnt_3_CLKINV_196,
      SET => GND,
      RST => r_cnt_3_SRINVNOT,
      O => r_cnt(2)
    );
  Mcount_r_cnt_xor_3_11 : X_LUT4
    generic map(
      INIT => X"7F80",
      LOC => "SLICE_X41Y67"
    )
    port map (
      ADR0 => r_cnt(1),
      ADR1 => r_cnt(0),
      ADR2 => r_cnt(2),
      ADR3 => r_cnt(3),
      O => Result(3)
    );
  r_cnt_3 : X_FF
    generic map(
      LOC => "SLICE_X41Y67",
      INIT => '0'
    )
    port map (
      I => r_cnt_3_DXMUX_221,
      CE => r_cnt_3_CEINV_195,
      CLK => r_cnt_3_CLKINV_196,
      SET => GND,
      RST => r_cnt_3_SRINVNOT,
      O => r_cnt(3)
    );
  r_cnt_5 : X_FF
    generic map(
      LOC => "SLICE_X41Y64",
      INIT => '0'
    )
    port map (
      I => r_cnt_6_DYMUX_252,
      CE => r_cnt_6_CEINV_241,
      CLK => r_cnt_6_CLKINV_242,
      SET => GND,
      RST => r_cnt_6_SRINVNOT,
      O => r_cnt(5)
    );
  Mcount_r_cnt_xor_6_11 : X_LUT4
    generic map(
      INIT => X"6AAA",
      LOC => "SLICE_X41Y64"
    )
    port map (
      ADR0 => r_cnt(6),
      ADR1 => Mcount_r_cnt_cy(3),
      ADR2 => r_cnt(5),
      ADR3 => r_cnt(4),
      O => Result(6)
    );
  r_cnt_6 : X_FF
    generic map(
      LOC => "SLICE_X41Y64",
      INIT => '0'
    )
    port map (
      I => r_cnt_6_DXMUX_267,
      CE => r_cnt_6_CEINV_241,
      CLK => r_cnt_6_CLKINV_242,
      SET => GND,
      RST => r_cnt_6_SRINVNOT,
      O => r_cnt(6)
    );
  state_FSM_FFd2_In16 : X_LUT4
    generic map(
      INIT => X"FF7F",
      LOC => "SLICE_X40Y67"
    )
    port map (
      ADR0 => r_cnt(3),
      ADR1 => r_cnt(2),
      ADR2 => r_cnt(6),
      ADR3 => r_cnt(1),
      O => state_FSM_FFd2_In16_O_pack_3
    );
  state_FSM_FFd1 : X_FF
    generic map(
      LOC => "SLICE_X40Y67",
      INIT => '0'
    )
    port map (
      I => state_FSM_FFd2_DYMUX_299,
      CE => VCC,
      CLK => state_FSM_FFd2_CLKINV_289,
      SET => GND,
      RST => state_FSM_FFd2_SRINVNOT,
      O => state_FSM_FFd1_113
    );
  state_FSM_FFd2_In43 : X_LUT4
    generic map(
      INIT => X"FECC",
      LOC => "SLICE_X40Y67"
    )
    port map (
      ADR0 => state_FSM_FFd2_In4_0,
      ADR1 => state_FSM_FFd2_In40_0,
      ADR2 => state_FSM_FFd2_In16_O,
      ADR3 => state_FSM_FFd2_109,
      O => state_FSM_FFd2_In
    );
  state_FSM_FFd2_In40 : X_LUT4
    generic map(
      INIT => X"0F0C",
      LOC => "SLICE_X40Y64"
    )
    port map (
      ADR0 => VCC,
      ADR1 => state_FSM_FFd2_109,
      ADR2 => state_FSM_FFd1_113,
      ADR3 => key_vld_IBUF_97,
      O => state_FSM_FFd2_In40_332
    );
  state_FSM_Out01 : X_LUT4
    generic map(
      INIT => X"CC00",
      LOC => "SLICE_X40Y64"
    )
    port map (
      ADR0 => VCC,
      ADR1 => state_FSM_FFd2_109,
      ADR2 => VCC,
      ADR3 => state_FSM_FFd1_113,
      O => state_cmp_eq0001
    );
  state_FSM_FFd2_In4 : X_LUT4
    generic map(
      INIT => X"FFF3",
      LOC => "SLICE_X41Y65"
    )
    port map (
      ADR0 => VCC,
      ADR1 => r_cnt(0),
      ADR2 => r_cnt(5),
      ADR3 => r_cnt(4),
      O => state_FSM_FFd2_In4_365
    );
  r_cnt_0 : X_FF
    generic map(
      LOC => "SLICE_X41Y65",
      INIT => '0'
    )
    port map (
      I => r_cnt_1_DYMUX_368,
      CE => r_cnt_1_CEINV_356,
      CLK => r_cnt_1_CLKINV_357,
      SET => GND,
      RST => r_cnt_1_SRINVNOT,
      O => r_cnt(0)
    );
  Mcount_r_cnt_xor_1_11 : X_LUT4
    generic map(
      INIT => X"5A5A",
      LOC => "SLICE_X41Y65"
    )
    port map (
      ADR0 => r_cnt(1),
      ADR1 => VCC,
      ADR2 => r_cnt(0),
      ADR3 => VCC,
      O => Result(1)
    );
  state_FSM_Out31 : X_LUT4
    generic map(
      INIT => X"0F00",
      LOC => "SLICE_X45Y67"
    )
    port map (
      ADR0 => VCC,
      ADR1 => VCC,
      ADR2 => state_FSM_FFd2_109,
      ADR3 => state_FSM_FFd1_113,
      O => key_rdy_OBUF_402
    );
  key_rdy_OUTPUT_OFF_OMUX : X_BUF
    generic map(
      LOC => "PAD39",
      PATHPULSE => 638 ps
    )
    port map (
      I => key_rdy_OBUF_402,
      O => key_rdy_O
    );
  NlwBlock_rc5_key_GND : X_ZERO
    port map (
      O => GND
    );
  NlwBlock_rc5_key_VCC : X_ONE
    port map (
      O => VCC
    );
  NlwBlockROC : X_ROC
    generic map (ROC_WIDTH => 100 ns)
    port map (O => GSR);
  NlwBlockTOC : X_TOC
    port map (O => GTS);

end Structure;


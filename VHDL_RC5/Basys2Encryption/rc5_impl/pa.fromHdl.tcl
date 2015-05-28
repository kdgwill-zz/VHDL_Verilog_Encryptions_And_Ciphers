
# PlanAhead Launch Script for Pre-Synthesis Floorplanning, created by Project Navigator

create_project -name rc5_impl -dir "C:/SkyDrive/School/Polytechnic/EL6463_AdvancedHardwareDesign/Labs/Lab7/rc5_impl/planAhead_run_1" -part xc3s100ecp132-4
set_param project.pinAheadLayout yes
set srcset [get_property srcset [current_run -impl]]
set_property target_constrs_file "C:/SkyDrive/School/Polytechnic/EL6463_AdvancedHardwareDesign/Labs/Lab7/rc5.ucf" [current_fileset -constrset]
set hdlfile [add_files [list {../rotRight.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../rotLeft.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../hex2sevenseg.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../rc5.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set_property top rc5 $srcset
add_files [list {C:/SkyDrive/School/Polytechnic/EL6463_AdvancedHardwareDesign/Labs/Lab7/rc5.ucf}] -fileset [get_property constrset [current_run]]
open_rtl_design -part xc3s100ecp132-4

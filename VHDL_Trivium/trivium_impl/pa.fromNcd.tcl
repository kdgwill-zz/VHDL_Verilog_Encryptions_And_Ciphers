
# PlanAhead Launch Script for Post PAR Floorplanning, created by Project Navigator

create_project -name trivium -dir "C:/SkyDrive/School/Polytechnic/EL6463_AdvancedHardwareDesign/Labs/FinalProject/trivium_impl/planAhead_run_1" -part xc3s100ecp132-4
set srcset [get_property srcset [current_run -impl]]
set_property design_mode GateLvl $srcset
set_property edif_top_file "C:/SkyDrive/School/Polytechnic/EL6463_AdvancedHardwareDesign/Labs/FinalProject/trivium_impl/tb_trivium.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {C:/SkyDrive/School/Polytechnic/EL6463_AdvancedHardwareDesign/Labs/FinalProject/trivium_impl} }
set_property target_constrs_file "tb_trivium.ucf" [current_fileset -constrset]
add_files [list {tb_trivium.ucf}] -fileset [get_property constrset [current_run]]
link_design
read_xdl -file "C:/SkyDrive/School/Polytechnic/EL6463_AdvancedHardwareDesign/Labs/FinalProject/trivium_impl/tb_trivium.ncd"
if {[catch {read_twx -name results_1 -file "C:/SkyDrive/School/Polytechnic/EL6463_AdvancedHardwareDesign/Labs/FinalProject/trivium_impl/tb_trivium.twx"} eInfo]} {
   puts "WARNING: there was a problem importing \"C:/SkyDrive/School/Polytechnic/EL6463_AdvancedHardwareDesign/Labs/FinalProject/trivium_impl/tb_trivium.twx\": $eInfo"
}

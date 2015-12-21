
# PlanAhead Launch Script for Pre-Synthesis Floorplanning, created by Project Navigator

create_project -name ADAT_De-Encoder -dir "Z:/ADAT DeEncoder/ADAT_De-Encoder/planAhead_run_1" -part xc3s200avq100-5
set_param project.pinAheadLayout yes
set srcset [get_property srcset [current_run -impl]]
set_property target_constrs_file "xXCS3200A-4VQ100_LoopbackTest.ucf" [current_fileset -constrset]
set hdlfile [add_files [list {ADAT.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {ADAT_BLOCKRAM.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {DynamischerADATPuffer_BRAM.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {ADAT_Enkoder.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {ADAT_Dekoder.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {Test_ADAT_Loopback.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set_property top Test_ADAT_Loopback $srcset
add_files [list {xXCS3200A-4VQ100_LoopbackTest.ucf}] -fileset [get_property constrset [current_run]]
open_rtl_design -part xc3s200avq100-5

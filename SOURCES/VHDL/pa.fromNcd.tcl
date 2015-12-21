
# PlanAhead Launch Script for Post PAR Floorplanning, created by Project Navigator

create_project -name ADAT_De-Encoder -dir "Z:/ADAT DeEncoder/ADAT_De-Encoder/planAhead_run_3" -part xc3s200avq100-5
set srcset [get_property srcset [current_run -impl]]
set_property design_mode GateLvl $srcset
set_property edif_top_file "Z:/ADAT DeEncoder/ADAT_De-Encoder/ADAT_De_Enkoder.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {Z:/ADAT DeEncoder/ADAT_De-Encoder} }
set_property target_constrs_file "xXCS3200A-4VQ100.ucf" [current_fileset -constrset]
add_files [list {xXCS3200A-4VQ100.ucf}] -fileset [get_property constrset [current_run]]
link_design
read_xdl -file "Z:/ADAT DeEncoder/ADAT_De-Encoder/ADAT_De_Enkoder.ncd"
if {[catch {read_twx -name results_1 -file "Z:/ADAT DeEncoder/ADAT_De-Encoder/ADAT_De_Enkoder.twx"} eInfo]} {
   puts "WARNING: there was a problem importing \"Z:/ADAT DeEncoder/ADAT_De-Encoder/ADAT_De_Enkoder.twx\": $eInfo"
}

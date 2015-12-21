
# PlanAhead Launch Script for Post-Synthesis floorplanning, created by Project Navigator

create_project -name ADAT_De-Encoder -dir "D:/ADAT DeEncoder/ADAT_De-Encoder/planAhead_run_2" -part xc3s200avq100-4
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "D:/ADAT DeEncoder/ADAT_De-Encoder/Autosync.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {D:/ADAT DeEncoder/ADAT_De-Encoder} }
set_property target_constrs_file "xXCS3200A-4VQ100_Autosync.ucf" [current_fileset -constrset]
add_files [list {xXCS3200A-4VQ100_Autosync.ucf}] -fileset [get_property constrset [current_run]]
link_design

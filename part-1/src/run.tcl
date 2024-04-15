set launch_dir [pwd]
set script_dir [file normalize [file dirname [lindex $argv end]]]

cd $script_dir

exec xvlog -sv muxes.sv muxes_tb.sv

exec xelab -debug all -timescale 1ns/1ps work.muxes_tb
exec xelab -timescale 1ns/1ps work.mux_cont_idx_4_to_1
exec xelab -timescale 1ns/1ps work.mux_proc_case_4_to_1_weird
exec xelab -timescale 1ns/1ps work.mux_proc_if_2_to_1
exec xelab -timescale 1ns/1ps work.mux_proc_if_4_to_1_weird
exec xelab -timescale 1ns/1ps work.mux_proc_if_4_to_1
exec xelab -timescale 1ns/1ps work.mux_bus_prm

exec xsim -g -t wave_cfg.tcl work.muxes_tb

# cleanup
file delete -force {*}[glob -nocomplain *{.jou,.log,.wdb,.pb,.Xil,xsim.dir}]

cd $launch_dir
exit

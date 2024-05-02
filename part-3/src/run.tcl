set launch_dir [pwd]
set script_dir [file normalize [file dirname [lindex $argv end]]]

cd $script_dir

exec xvlog -sv exmp.sv exmp_mealy_moore_tb.sv

exec xelab -debug all -timescale 1ns/1ps work.exmp_mealy_moore_tb
exec xelab -timescale 1ns/1ps work.exmp_mealy
exec xelab -timescale 1ns/1ps work.exmp_moore

exec xsim -g -t wave_cfg.tcl work.exmp_mealy_moore_tb

# cleanup
file delete -force {*}[glob -nocomplain *{.jou,.log,.wdb,.pb,.Xil,xsim.dir}]

cd $launch_dir
exit

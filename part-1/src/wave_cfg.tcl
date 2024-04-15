set curr_wave [current_wave_config]
if { [string length $curr_wave] == 0 } {
	if { [llength [get_objects]] > 0} {
		add_wave -regexp .*_2_to_1
		add_wave -regexp .*_4_to_1
		add_wave -regexp .*_4_to_1_weird
		add_wave -regexp .*_bp
		set_property needs_save false [current_wave_config]
	} else {
		send_msg_id Add_Wave-1 WARNING "No top level signals found. Simulator will start without a wave window. If you want to open a wave window go to 'File->New Waveform Configuration' or type 'create_wave_config' in the TCL console."
	}
}

run 35ns

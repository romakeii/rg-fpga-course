set curr_wave [current_wave_config]
if { [string length $curr_wave] == 0 } {
    if { [llength [get_objects]] > 0} {
        add_wave rst
		add_wave clk
		add_wave in
		add_wave -name state_moore /uut_moore/state
		add_wave out_moore
		add_wave -name state_mealy /uut_mealy/state
		add_wave out_mealy
        set_property needs_save false [current_wave_config]
    } else {
        send_msg_id Add_Wave-1 WARNING "No top level signals found. Simulator will start without a wave window. If you want to open a wave window go to 'File->New Waveform Configuration' or type 'create_wave_config' in the TCL console."
    }
}

run 50ns

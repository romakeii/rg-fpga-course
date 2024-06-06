`timescale 1ns / 1ns


module stream_acc_tb();

    localparam WIDTH = 16;
    localparam AMOUNT_OF_DATA = 16;
    localparam AMOUNT_OF_PACKET = 4;
    localparam GAP = 0;
    localparam int unsigned CLK_PERIOD = 4;
    localparam WIDTH_OUT = WIDTH + AMOUNT_OF_PACKET - 1;
    logic clk = 0;
    logic rst = 1;
    logic [WIDTH - 1 : 0] data_in = 0;
    logic valid_in = 0;
    logic [WIDTH_OUT - 1 : 0] data_o;
    logic valid_o;	
    integer in_file;
    integer ref_file;
    logic [WIDTH - 1 : 0] d_in [AMOUNT_OF_DATA * AMOUNT_OF_PACKET];
    logic [WIDTH_OUT - 1 : 0] d_ref [AMOUNT_OF_DATA];
    integer cnt_err = 0;
    
    event check_completed;

    stream_acc #(.WIDTH(WIDTH), .AMOUNT_OF_DATA(AMOUNT_OF_DATA), .AMOUNT_OF_PACKET(AMOUNT_OF_PACKET)) uut(
        .clk(clk),
        .rst(rst),
        .data_in(data_in),
        .valid_in(valid_in),
        .data_o(data_o),
        .valid_o(valid_o)
    ); 

    task drive_frame ();
        for(int i = 0; i < AMOUNT_OF_PACKET; i++) begin
            for(int j = 0; j < AMOUNT_OF_DATA; j++) begin
                data_in <= d_in[AMOUNT_OF_DATA * i + j];
                valid_in <= 1;
                @(posedge clk);
            end
           data_in <= 0;
           valid_in <= 0;
           repeat(GAP)@(posedge clk);                   
        end
    endtask
        
      
    initial begin
        forever begin
            #(CLK_PERIOD / 2);
            clk = ~clk;
        end
    end
    
    
    initial begin
        for(int i = 0; i < AMOUNT_OF_DATA;) begin
            if(valid_o) begin
                if(d_ref[i] != data_o)
                    cnt_err++;
                i++;
            end
            @(posedge clk);
        end
        $display("The amounte of errors is: %d", cnt_err);           
        ->check_completed;
    end
       

    initial begin
        $display("<-- Start simulation");
	    in_file = $fopen("../../../../../model/files/data_mult.txt", "r");
		ref_file = $fopen("../../../../../model/files/data_ref.txt", "r");
		for(int i = 0; i < AMOUNT_OF_DATA * AMOUNT_OF_PACKET; i++) begin
            $fscanf(in_file, " %d\n",  d_in[i]);   
        end	  
		for(int i = 0; i < AMOUNT_OF_DATA; i++) begin
            $fscanf(ref_file, " %d\n",  d_ref[i]);
        end	  
        repeat(40)@(posedge clk);
        rst = 0;
        repeat(5)@(posedge clk);		
        @(posedge clk);
        drive_frame();
        @(check_completed);
        $fclose(in_file);
        $fclose(ref_file);
        $display("<-- Simulation done!");
        $finish;
    end
    
endmodule

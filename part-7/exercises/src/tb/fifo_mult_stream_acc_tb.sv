`timescale 1ns / 1ps

module fifo_mult_stream_acc_tb;
    localparam WIDTH = 8;
    localparam AMOUNT_OF_DATA = 16;
    localparam AMOUNT_OF_PACKET = 4;
    localparam AMOUNT_OF_CYCLE = 2;
    localparam AMOUNT_OF_ALL_DATA = AMOUNT_OF_DATA * AMOUNT_OF_PACKET; 
    localparam WIDTH_OUT = 2 * WIDTH + AMOUNT_OF_PACKET - 1;
    localparam SPEED_1 = 50; // should be from 1 (min) to 100 (max)
    localparam SPEED_2 = 100; // should be from 1 (min) to 100 (max)
    localparam int unsigned CLK_PERIOD = 4;
    logic clk = 0;
    logic rst = 1;
    logic [WIDTH - 1 : 0] data_in1 = 0;
    logic [WIDTH - 1 : 0] data_in2 = 0;
    logic valid_in1 = 0;
    logic valid_in2 = 0;
    logic [WIDTH_OUT - 1 : 0] data_o;
    logic valid_o;	
    integer in_file1;
    integer in_file2;
    integer ref_file;
    logic [WIDTH - 1 : 0] d_in1 [AMOUNT_OF_ALL_DATA];
    logic [WIDTH - 1 : 0] d_in2 [AMOUNT_OF_ALL_DATA];
    logic signed [WIDTH_OUT - 1 : 0] d_ref [AMOUNT_OF_DATA];
    integer cnt_err = 0;
    
    event check_completed;

    fifo_mult_stream_acc #(.WIDTH(WIDTH), .AMOUNT_OF_DATA(AMOUNT_OF_DATA), .AMOUNT_OF_PACKET(AMOUNT_OF_PACKET)) uut(
        .clk(clk),
        .rst(rst),
        .data_in1(data_in1),
        .valid_in1(valid_in1),
        .ready_1(ready_1),
        .data_in2(data_in2),
        .valid_in2(valid_in2),
        .ready_2(ready_2),
        .data_o(data_o),
        .valid_o(valid_o)
    );
    
    initial begin
        rst = 1;
        repeat(3)@(posedge clk);
        rst = 0;
    end
        
    initial begin
        forever begin
            #(CLK_PERIOD / 2);
            clk = ~clk;
        end
    end
       
    initial begin
        @(negedge rst);
        repeat(10) @(posedge clk);
        repeat(AMOUNT_OF_CYCLE) begin
            for(int i = 0; i < AMOUNT_OF_ALL_DATA;) begin
                if(ready_1 & (($urandom_range (1, 100) <= SPEED_1))) begin
                    data_in1 <= d_in1[i];
                    valid_in1 <= 1;
                    @(negedge clk);
                    if(ready_1)
                        i++;
                end
                @(posedge clk);    
                valid_in1 <= 0;
            end
        end        
    end    
    
    initial begin
        @(negedge rst);
        repeat(10) @(posedge clk);
        repeat(AMOUNT_OF_CYCLE) begin
            for(int i = 0; i < AMOUNT_OF_ALL_DATA;) begin
                if(ready_2 & (($urandom_range (1, 100) <= SPEED_2))) begin
                    data_in2 <= d_in2[i];
                    valid_in2 <= 1;
                    @(negedge clk);
                    if(ready_2)
                        i++;
                end
                @(posedge clk);    
                valid_in2 <= 0;
            end
        end                
    end
    
    
    initial begin
        @(negedge rst);
        repeat(AMOUNT_OF_CYCLE) begin
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
    end

       

    initial begin
        @(negedge rst);
        $display("<-- Start simulation");
	    in_file1 = $fopen("../../../../../model/files/data_in1.txt", "r");
	    in_file2 = $fopen("../../../../../model/files/data_in2.txt", "r");
		ref_file = $fopen("../../../../../model/files/data_ref.txt", "r");
		for(int i = 0; i < AMOUNT_OF_ALL_DATA; i++) begin
            $fscanf(in_file1, " %d\n",  d_in1[i]);   
            $fscanf(in_file2, " %d\n",  d_in2[i]);        
            $fscanf(ref_file, " %d\n",  d_ref[i]);
        end  
        repeat(AMOUNT_OF_CYCLE) @(check_completed);
        $fclose(in_file1);
        $fclose(in_file2);
        $fclose(ref_file);
        $display("<-- Simulation done!");
        $finish;
    end

endmodule

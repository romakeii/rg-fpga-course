`timescale 1ns / 1ps

module fifo_mult_tb;
    localparam int WIDTH = 16;
    localparam int AMOUNT_OF_DATA = 14;
    localparam NUM_OF_TESTS = AMOUNT_OF_DATA * 3;
    localparam int unsigned CLK_PERIOD = 4;
    localparam SPEED_1 = 100; // should be from 1 (min) to 100 (max)
    localparam SPEED_2 = 100; // should be from 1 (min) to 100 (max)
    logic clk = 0;
    logic rst;
    logic [WIDTH - 1 : 0] data_in1 = 0;
    logic [WIDTH - 1 : 0] data_in2 = 0;
    logic valid_in1 = 0;
    logic valid_in2 = 0;
    logic [2 * WIDTH - 1: 0] data_o;
    logic valid_o;
    logic [NUM_OF_TESTS - 1 : 0][WIDTH - 1 : 0] ref_val1 = 0;
    logic [NUM_OF_TESTS - 1 : 0][WIDTH - 1 : 0] ref_val2 = 0;
    logic ready_1;
    logic ready_2;
    int res = 0;
       
    initial begin
        forever begin
            #(CLK_PERIOD / 2);
            clk = ~clk;
        end
    end

    fifo_mult #(.WIDTH(WIDTH), .AMOUNT_OF_DATA(AMOUNT_OF_DATA)) uut (
        .clk(clk),
        .rst(rst),
        .data_in1(data_in1),
        .valid_in1(valid_in1),
        .data_in2(data_in2),
        .valid_in2(valid_in2),
        .data_o(data_o),
        .valid_o(valid_o),
        .ready_1(ready_1),
        .ready_2(ready_2)
    );   
    
    initial begin
        rst = 1;
        repeat(3)@(posedge clk);
        rst = 0;
    end
    
    initial begin
        @(negedge rst);
        repeat(10) @(posedge clk);
        for(int i = 0; i < NUM_OF_TESTS;) begin
            if(ready_1 & (($urandom_range (1, 100) <= SPEED_1))) begin
                data_in1 <= $urandom();
                valid_in1 <= 1;
                @(negedge clk);
                if(ready_1) begin
                    ref_val1[i] = data_in1;
                    i++;
                end
            end
            @(posedge clk);    
            valid_in1 <= 0;
        end               
    end
   

    initial begin
        @(negedge rst);
        repeat(10) @(posedge clk);
        for(int i = 0; i < NUM_OF_TESTS;) begin
            if(ready_2 & (($urandom_range (1, 100) <= SPEED_2))) begin
                data_in2 <= $urandom();
                valid_in2 <= 1;
                @(negedge clk);
                if(ready_2) begin
                    ref_val2[i] = data_in2;
                    i++;
                end
            end
            @(posedge clk);    
            valid_in2 <= 0;
        end               
    end 
   
    initial begin
        @(negedge rst);
        repeat(10) @(posedge clk);
        $display("<-- Start simulation");
        for(int i = 0; i < NUM_OF_TESTS;) begin
            if(valid_o) begin
                res = $signed(ref_val1[i]) * $signed(ref_val2[i]);
                if(data_o != res) begin
                    $display("ERROR!");
                    $display("val1 is: %h", ref_val1[i]);
                    $display("val2 is: %h", ref_val2[i]);
                    $display("ERROR! Ref val is: %h", res);
                    $display("Calc val is: %h", data_o);
                    $finish;
                end
                i++;
            end
            @(posedge clk);
        end
        $display("<-- Simulation done!");
        $finish;          
    end    
    

endmodule

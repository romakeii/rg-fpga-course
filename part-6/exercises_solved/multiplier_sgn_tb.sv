`timescale 1ns / 1ps

module multiplier_sgn_tb;

    localparam CONVEYER = 1;

    localparam int WIDTH = 8;
    localparam NUM_OF_TESTS = 100;
    localparam int unsigned CLK_PERIOD = 4; // ns
    int unsigned delay;
    logic clk = 0;
    logic rst;
    logic signed [WIDTH - 1 : 0] in1;
    logic signed [WIDTH - 1 : 0] in2;
    logic [2 * WIDTH - 1 : 0] out;
    logic [NUM_OF_TESTS - 1 : 0][2 * WIDTH - 1:0] ref_val = 0;

    initial begin
        forever begin
            #(CLK_PERIOD / 2);
            clk = ~clk;
        end
    end

    generate
        if(CONVEYER) begin
            mult_sgn_cnv #(.WIDTH(WIDTH)) uut (
                .clk(clk),
                .x(in1),
                .y(in2),
                .out(out)
            );
            assign delay = 2 + $clog2(WIDTH);
        end else begin
            mult_sgn #(.WIDTH(WIDTH)) uut (
                .clk(clk),
                .x(in1),
                .y(in2),
                .out(out)
            );
            assign delay = 2;
        end
    endgenerate

    initial begin
        rst = 1;
        repeat(3) @(posedge clk);
        rst = 0;
    end

    initial begin
        $display("<-- Start simulation");
        @(negedge rst);
        @(posedge clk);
        for(int i = 0; i < NUM_OF_TESTS; i++) begin
            in1 <= $urandom();
            in2 <= $urandom();
            @(posedge clk);
            ref_val[i] = in1 * in2;
        end
    end

    initial begin
        @(negedge rst);
        @(posedge clk);
        repeat(delay) @(posedge clk);
        for(int i = 0; i < NUM_OF_TESTS; i++) begin
            @(posedge clk);
            if(out != ref_val[i]) begin
                $display("ERROR! Ref val is: %h", ref_val[i]);
                $display("Calc val is: %h", out);
                $finish;
            end
        end
        $display("<-- Simulation is done!");
        $finish;
    end

endmodule

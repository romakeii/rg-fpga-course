`timescale 1ns / 1ns
`define ___BIT_TB___
`include "tasks.svh"

module srl_bit_tb;

    logic                   clk;
    logic                   rst;
    logic [`WIDTH - 1 : 0]  in = 0;
    logic [`WIDTH - 1 : 0]  out;

    localparam int unsigned CLK_PERIOD = 4;
    logic [`DURATION - 1 : 0] ref_data;

    initial begin
        for(int i = 0; i < `DURATION; i += 1) begin
            ref_data[i] = $urandom_range(2**`WIDTH - 1);
        end
    end

    initial begin
        clk = 0;
        forever begin
            #(CLK_PERIOD / 2);
            clk = ~clk;
        end
    end

    srl_bit #(.CLK_CYCL(`DELAY)) uut (
        .clk(clk),
        .rst(rst),
        .in(in),
        .out(out)
    );

    initial begin
        rst = 1;
        repeat(3) @(posedge clk);
        rst = 0;
    end

    initial begin
        $display("=== Start simulation");
        make_seq(rst, clk, ref_data, in);
    end

    initial begin
        check_result(rst, clk, ref_data, out);
        $display("=== Simulation is done with 0 errors!");
        $finish;
    end

endmodule

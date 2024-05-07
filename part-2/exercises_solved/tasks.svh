`timescale 1ns / 1ns
`include "defines.svh"

task automatic make_seq (
    ref rst,
    ref clk,
    input logic [`DURATION - 1 : 0][`WIDTH - 1 : 0] ref_data,
    ref [`WIDTH - 1 : 0] seq
);

    @(negedge rst);
    @(posedge clk);
    for(int i = 0; i < `DURATION; i++) begin
        seq = ref_data[i];
        @(posedge clk);
    end

endtask

task automatic check_result (
    ref rst,
    ref clk,
    input logic [`DURATION - 1 : 0][`WIDTH - 1 : 0] ref_data,
    ref [`WIDTH - 1 : 0] seq
);

    @(negedge rst);
    @(posedge clk);
    repeat(`DELAY) @(posedge clk);
    for(int i = 0; i < `DURATION; i++) begin
        if(seq != ref_data[i]) begin
            $display("ERROR!");
            $display("=== Simulation failed!");
            $finish;
        end
        @(posedge clk);
    end

endtask

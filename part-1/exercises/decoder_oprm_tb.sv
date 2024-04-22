`timescale 1ns / 1ps

module decoder_oprm_tb;

    localparam WIDTH = 3;
    logic [$clog2(WIDTH) - 1 : 0] in = 0;
    logic [WIDTH - 1 : 0] out;
    localparam logic [$bits(out) - 1 : 0] ONE = 1;

    decoder_oprm #(.OUT_WIDTH(WIDTH)) dut (
        .in(in),
        .out(out)
    );

    initial begin
        $display("=== Start simulation");
        for(int unsigned i = '0; i < $bits(out); i += 1, in += 1) begin
            #(10);
            if(i > WIDTH - 1) begin
                if(out != '0) begin
                    $display("=== ERROR!");
                    $display("=== Simulation failed!");
                    $finish;
                end
            end else if((out >> in) != ONE) begin
                $display("=== ERROR!");
                $display("=== Simulation failed!");
                $finish;
            end
        end
        #(10);
        $display("=== Simulation is done with 0 errors!");
        $finish;
    end

endmodule

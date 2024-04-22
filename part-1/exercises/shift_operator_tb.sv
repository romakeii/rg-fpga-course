`timescale 1ns / 1ps

module shift_operation_tb;

    localparam WIDTH = 16;
    localparam SHIFT = 1;
    logic drc = 1;
    logic [WIDTH - 1 : 0] in;
    logic [WIDTH - 1 : 0] out;
    logic [WIDTH - 1 : 0] inc;
    logic [WIDTH - 1 : 0] dec;

    shift_operator #(.WIDTH(WIDTH), .SHIFT(SHIFT)) uut (
        .in(in),
        .drc(drc),
        .out(out)
    );

    assign inc = in * $pow(2, SHIFT);
    assign dec = $floor(in / $pow(2, SHIFT));

    initial begin
       $display("=== Start simulation");
        drc = 1;
        in = 1;
        repeat(WIDTH) begin
            #1;
            if(inc != out) begin
                $display("=== ERROR!");
                $display("=== Simulation failed!");
                $finish;
            end
            in = out;
        end
        #1;
        drc = 0;
        in[WIDTH - 1] = 1;
        repeat(WIDTH) begin
            #1;
            if(dec != out) begin
                $display("=== ERROR!");
                $display("=== Simulation failed!");
                $finish;
            end
            in = out;
        end
        #5;
        $display("=== Simulation is done with 0 errors!");
        $finish;
    end

endmodule

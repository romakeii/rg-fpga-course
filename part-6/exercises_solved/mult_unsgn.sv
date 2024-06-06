`timescale 1ns / 1ps

module mult_unsgn #(
    parameter int WIDTH = 32
)(
    input logic clk,
    input logic [WIDTH - 1 : 0] x,
    input logic [WIDTH - 1 : 0] y,
    output logic [2 * WIDTH - 1 : 0] out
);

    localparam AMOUNT_OF_STAGES = $clog2(WIDTH);
    localparam WIDTH_CPOW2 = 2**$clog2(WIDTH);

    logic [WIDTH - 1 : 0] x_reg;
    logic [WIDTH - 1 : 0] y_reg;
    logic [WIDTH_CPOW2 - 1 : 0] [WIDTH - 1 : 0] p;

    always_ff @(posedge clk) begin
        x_reg <= x;
        y_reg <= y;
    end

    always_comb begin
        p = '0;
        for(int i = 0; i < WIDTH; i++)
            p[i] = {WIDTH{y_reg[i]}} & x_reg;
    end

    generate
        genvar stage_idx, sum_idx;

        for(stage_idx = 0; stage_idx < AMOUNT_OF_STAGES; stage_idx++) begin : stage
            logic [(WIDTH_CPOW2 >> (stage_idx + 1)) - 1 : 0][WIDTH + 2**(stage_idx + 1) - 1 : 0] sum;
            if(stage_idx == 0) begin
                for(sum_idx = 0; sum_idx < (WIDTH_CPOW2 >> (stage_idx + 1)); sum_idx++)
                    assign sum[sum_idx] = p[2 * sum_idx] + (p[2 * sum_idx + 1] << 1);
            end else begin
                for(sum_idx = 0; sum_idx < (WIDTH_CPOW2 >> (stage_idx + 1)); sum_idx++)
                    assign sum[sum_idx] = stage[stage_idx - 1].sum[2 * sum_idx] + (stage[stage_idx - 1].sum[2 * sum_idx + 1] << 2**stage_idx);
            end

        end

        always_ff @(posedge clk)
            out <= stage[AMOUNT_OF_STAGES - 1].sum[0];

    endgenerate

endmodule

`timescale 1ns / 1ps

module mealy (
    input  logic clk,
    input  logic rst,
    input  logic a,
    input  logic b,
    output logic z
);

    enum logic [1:0] {S0, S1, S2}  state; // // По-умолчанию значения начинаются с 0 (S0 = 0, S1 = 1, ...)

    always @(posedge clk) begin
        if (rst) begin
            state <= S0;
        end
        else begin
            case (state)
                S0: begin
                    if(a)   state <= S1;
                end
                S1: begin
                    if(!a)  state <= S0;
                end
                default: begin
                            state <= S0;
                end
            endcase
        end
    end

    always_comb begin
        z = 0;
        case (state)
            S0: begin
                z = b & a;
            end
            S1: begin
                z = b ? 1 : a;
            end
            default: begin
                z = 0;
            end
        endcase
    end

endmodule

module moore(
    input   logic   clk,
    input   logic   rst,
    input   logic   a,
    input   logic   b,
    output  logic   z
);

    enum logic [1:0] {S0, S1, S2, S3}  state; // По-умолчанию значения начинаются с 0 (S0 = 0, S1 = 1, ...)

    always @(posedge clk)
    if (rst) begin
       state <= S0;
    end
    else begin
        case (state)
            S0: begin
                if(a)     state <= b ? S3 : S2;
            end
            S1: begin
                if(a)     state <= b ? S3 : S2;
                else      state <= S0;
            end            
            S2: begin
                if(a)     state <= S3;
                else      state <= b ? S1 : S0;
            end
            S3: begin
                if(!a)    state <=  b ? S1 : S0;
            end
            default: begin
                state <= S0;
            end
        endcase
    end


    assign z = (state == S1) | (state == S3);

endmodule

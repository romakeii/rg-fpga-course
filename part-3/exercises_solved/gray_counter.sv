`timescale 1ns / 1ps

module gray_counter (
    input  logic         clk,
    input  logic         rst,
    output logic [2 : 0] data_o
);

    enum logic [$bits(data_o) - 1 : 0] {S0, S1, S2, S3, S4, S5, S6, S7} state, next; // По-умолчанию значения начинаются с 0 (S0 = 0, S1 = 1, ...)

    // Регистр, хранящий текущее состояние
    always_ff @(posedge clk) begin
        if (rst) state <= S0;
        else     state <= next;
    end

    // Входная комбинационная логика
    always_comb begin
        next = S0;
        case (state)
            S0 : next = S1;
            S1 : next = S2;
            S2 : next = S3;
            S3 : next = S4;
            S4 : next = S5;
            S5 : next = S6;
            S6 : next = S7;
            S7 : next = S7; // Остановка счетчика
        endcase
    end

    // Выходная комбинационная логика
    always_comb begin
        data_o = 0;
        case (state)
            S0 : data_o = 3'b000;
            S1 : data_o = 3'b001;
            S2 : data_o = 3'b011;
            S3 : data_o = 3'b010;
            S4 : data_o = 3'b110;
            S5 : data_o = 3'b111;
            S6 : data_o = 3'b101;
            S7 : data_o = 3'b100;
        endcase
    end

endmodule

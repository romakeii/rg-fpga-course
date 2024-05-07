`timescale 1ns / 1ps

// Реализовать линию задержки однобитового сигнала
// Длина линии задержки (количество тактов задержки) должна задаваться параметром
// Требуемые порты:
// входы клока, синхронного сброса и данных (1 бит),
// выход данных (1 бит)

// Shift register line (SRL)
module srl_bit #(

// Описание параметров
    parameter CLK_CYCL = 4

) (

// Описание портов
    input logic clk,
    input logic rst,
    input logic in,
    output logic out

);

// Описание логики

    logic [CLK_CYCL - 1 : 0] shft_reg;

    always_ff @(posedge clk) begin
        if(rst)
            shft_reg <= 0;
        else
            shft_reg <= {shft_reg[CLK_CYCL - 2 : 0], in};
    end

    assign out = shft_reg[CLK_CYCL - 1];

endmodule

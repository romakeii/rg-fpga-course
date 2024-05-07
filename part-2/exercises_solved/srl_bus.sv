`timescale 1ns / 1ps

// Реализовать линию задержки для шины
// Длина линии задержки (количество тактов задержки) должна задаваться параметром
// Ширина шины должна задаваться параметром
// Требуемые порты:
// входы клока, синхронного сброса и данных (количество бит задается параметром),
// выход данных (количество бит задается параметром)
// Для реализации использовать generage блок и инстанцированный модуль srl_bit
// из файла srl_bit.sv

module srl_bus #(

// Описание параметров
    parameter CLK_CYCL = 4,
    parameter WIDTH = 8

) (

// Описание портов
    input logic clk,
    input logic rst,
    input logic [WIDTH - 1 : 0] in,
    output logic [WIDTH - 1 : 0] out

);

// Описание логики
    generate
        genvar i;
        for(i = 0; i < WIDTH; i++) begin: regs
            srl_bit #(.CLK_CYCL(CLK_CYCL)) srl_bit_i (
                .clk(clk),
                .rst(rst),
                .in(in[i]),
                .out(out[i])
            );
        end
    endgenerate

endmodule

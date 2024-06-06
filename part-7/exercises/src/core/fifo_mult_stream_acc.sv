`timescale 1ns / 1ps

module fifo_mult_stream_acc #(
    parameter WIDTH = 8,
    parameter AMOUNT_OF_DATA = 16,
    parameter AMOUNT_OF_PACKET = 4
)(
    input  logic                                         clk,
    input  logic                                         rst,
    input  logic [WIDTH - 1 : 0]                         data_in1,
    input  logic                                         valid_in1,
    input  logic [WIDTH - 1 : 0]                         data_in2,
    input  logic                                         valid_in2,
    output logic                                         ready_1,
    output logic                                         ready_2,
    output logic [AMOUNT_OF_PACKET + WIDTH_MULT - 2 : 0] data_o,
    output logic                                         valid_o
);

endmodule

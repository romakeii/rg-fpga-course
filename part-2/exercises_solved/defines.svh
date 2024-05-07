`ifndef ___GUARD___
`define ___GUARD___
    `ifdef ___BUS_TB___
        `define WIDTH (8)
    `endif
    `ifdef ___BIT_TB___
        `define WIDTH (1)
    `endif
    `define DELAY (4)
    `define DURATION (10)
`endif

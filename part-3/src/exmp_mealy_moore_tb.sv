`timescale 1ns / 1ps

module exmp_mealy_moore_tb();
    localparam int unsigned CLK_PERIOD = 4;
    localparam int unsigned DURATION = 10; // Длительность входного воздействия
    logic [DURATION - 1 : 0] in_sq = 'b1110110010; // Инициализируем входную воздействие
    logic clk = 0;
    logic rst;
    logic in = 0;
    logic out_mealy;
    logic out_moore;

    // Инстанцируем тестируемые модули

    exmp_mealy uut_mealy (
        .clk(clk),
        .rst(rst),
        .in(in),
        .out(out_mealy)
    );

    exmp_moore uut_moore (
        .clk(clk),
        .rst(rst),
        .in(in),
        .out(out_moore)
    );

    // Формируем тактовый сигнал

    initial begin
        forever begin
            #(CLK_PERIOD / 2);
            clk = ~clk;
        end
    end

    // Формируем сигнал сброса

    initial begin
        rst <= 1;
        repeat(3) @(posedge clk);
        rst <= 0;
    end

    initial begin

        $display("=== Start simulation");
        @(negedge rst);

        // Последовательно выдаем входное воздействие на вход тестируемых модулей
        for(int i = 0; i < DURATION; i++) begin
            in <= in_sq[i];
            @(posedge clk);
        end

        $display("=== Simulation is done with 0 errors!");
        $finish;

    end

endmodule

`timescale 1ns / 1ps

module gray_counter_tb();

    logic clk = 0;
    logic rst;
    localparam int unsigned WIDTH = 3;
    localparam int unsigned CLK_PERIOD = 4;
    logic [WIDTH - 1 : 0] data_o;
    logic [WIDTH - 1 : 0] cnt_gray = 0; // Сигнал-референсная модель
    logic [WIDTH - 1 : 0] cnt_bin;

    // Инстанциирование тестируемого модуля
    gray_counter uut (
        .clk(clk),
        .rst(rst),
        .data_o(data_o)
    );

    // Формирование тактового сигнала
    initial begin
        forever begin
            #(CLK_PERIOD / 2);
            clk = ~clk;
        end
    end

    // Функция для референсной модели
    function gray_code (input logic [WIDTH - 1 : 0] bin_input, output logic [WIDTH - 1 : 0] gray_output);
        gray_output = bin_input ^ (bin_input >> 1);
    endfunction

    // Подготовка task-a сброса, который будем использовать несколько раз в процессе симуляции
    task reset();
        rst = 1;
        repeat(3) @(posedge clk);
        rst = 0;
    endtask

    initial begin
        $display("=== Start simulation");
        reset();
        repeat(16) @(posedge clk); // Количество повторяющихся положительных перепадов > максимального значения двоичного счетчика,
        // чтобы проверить его остановку после достижения значения кода Грея = 4 (двоичного значения = 7)
        #(CLK_PERIOD / 2); // Сброс формируем на середине периода тактового сигнала,
        // чтобы на диаграмма отчетливо видеть, что автомат реагирует на сброс синхронно с положительным перепадом тактового сигнала
        reset();
        repeat(16) @(posedge clk);
        #(CLK_PERIOD / 2);
        $display("=== Simulation is done with 0 errors!");
        $finish;
    end

    // Референсная модель - двоичный счетчик и код Грея значений на выходе этого счетчика

    always @(posedge clk) begin
        if(rst) cnt_bin = 0;
        else    cnt_bin = cnt_bin == '1 ? cnt_bin : cnt_bin + 1;
    end

    always @(posedge clk) begin
        gray_code(cnt_bin, cnt_gray);
    end

    // Сопоставление выхода проверяемого модуля и референсной модели
    always @(negedge clk) begin
        if(data_o != cnt_gray) begin
            $display("ERROR!");
            $display("=== Simulation failed!");
            $finish;
        end
    end

endmodule

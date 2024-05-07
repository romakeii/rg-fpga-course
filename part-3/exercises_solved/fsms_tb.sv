`timescale 1ns / 1ps

module fsms_tb();

    localparam MEALY = 1;

    localparam int unsigned CLK_PERIOD = 4;
    localparam int unsigned DURATION = 10;
    logic [DURATION - 1 : 0] a_data = 'b0001100110;
    logic [DURATION - 1 : 0] b_data = 'b1111110000;
    logic [DURATION - 1 : 0] z_data;
    logic [DURATION - 1 : 0] z_ref_seq;
    logic clk = 0;
    logic rst;
    logic a = 0;
    logic b = 0;
    logic z;
    logic z_ref_seq_cmp;

    // Инстанцирование модулей
    // В зависимости от значения параметра "MEALY"
    // будет в тестбенче будет использован либо вариант автомата Мили, либо вариант автомата Мура;
    // т.е. меняя данный параметр можно выбрать, какой автомат будет проверять тестбенч

    generate

        if(MEALY) begin

            mealy uut_mealy(
                .clk(clk),
                .rst(rst),
                .a(a),
                .b(b),
                .z(z)
            );

            assign z_ref_seq_cmp = z_ref_seq;

        end else begin

            moore uut_moore(
                .clk(clk),
                .rst(rst),
                .a(a),
                .b(b),
                .z(z)
            );

            // Для автомата Мура референсную последовательность нужно задержать на 1 такт
            // (он выдает результат на 1 такт позже, чем автомат Мура)
            always @(posedge clk) z_ref_seq_cmp <= z_ref_seq;

        end

    endgenerate

    // Формирование тактового сигнала
    initial begin
        forever begin
            #(CLK_PERIOD / 2);
            clk = ~clk;
        end
    end

    // Формирование сигнала сброса
    initial begin
        rst = 1;
        repeat(3) @(posedge clk);
        rst = 0;
    end

    // Инициализация референсных данных
    initial begin
        z_data[0] = 0;
        for(int i = 1; i < DURATION; i++) begin
            z_data[i] = b_data[i] ? (a_data[i] | a_data[i-1]) : (a_data[i] & a_data[i-1]);
        end
    end

    // Формирование входных последовательностей и референсной выходной последовательности
    initial begin
        @(negedge rst);
        @(posedge clk);
        for(int i = 0; i < DURATION; i++) begin
            a <= a_data[i];
            b <= b_data[i];
            z_ref_seq <= z_data[i];
            @(posedge clk);
        end
    end

    // Проверка соответствия последовательности с выхода тестируемого автомата
    // референсной последовательности
    initial begin
        $display("=== Start simulation");
        @(negedge rst);
        @(posedge clk);
        for(int i = 0; i < DURATION; i++) begin
            if(z != z_ref_seq_cmp) begin
                $display("ERROR!");
                $display("=== Simulation failed!");
                $finish;
            end
            @(posedge clk);
        end
        $display("=== Simulation is done with 0 errors!");
        $finish;
    end

endmodule

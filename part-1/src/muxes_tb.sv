// Тестбенч - модуль, задающий тестовое окружение для целевого(ых) (тестируемого(ых)) модуля(ей)
// Обычно не имеет портов, содержит внутри себя инстанцированные тестируемые модули и их тестовое окружение
// В качестве тестового окружения могут выступать средства (модули, классы, процессы и т.п.),
// формирующие входные воздействия для тестируемых модулей, а так же средства валидации результатов,
// полученных при подаче на входы тестируемых модулей сформированных входных воздействий

`timescale 1ns/1ps // задаются [единицы измерения/точность] используемых в коде команд ожидания (#N)

module muxes_tb;

    // Объявление сигналов, задающих входные воздействия

    logic dat_a_2_to_1;
    logic dat_b_2_to_1;
    logic sel_2_to_1;

    // Пусть для одноразрядных мультиплексоров 4 в 1 входы будут управляться одними и теми же сигналами
    logic [3 : 0] dat_i_4_to_1;
    logic [1 : 0] sel_4_to_1;

    localparam SEL_WIDTH_BP = 2;
    localparam DAT_WIDTH_BP = 2;
    logic [2**SEL_WIDTH_BP - 1 : 0][DAT_WIDTH_BP - 1 : 0] dat_i_bp;
    logic [SEL_WIDTH_BP - 1 : 0] sel_bp;

    // Объявление выходных сигналов

    logic dat_o_2_to_1;

    logic dat_o_cont_idx_4_to_1;
    logic dat_o_proc_if_4_to_1;
    logic dat_o_proc_if_4_to_1_weird;
    logic dat_o_proc_case_4_to_1_weird;

    logic [2**SEL_WIDTH_BP - 1 : 0][DAT_WIDTH_BP - 1 : 0] dat_o_bp;

    initial begin // один из видов процессов
    // Процессы могут описывать изменения значений сигналов во время симуляции
    // Процессы выполняются в ходе симуляции параллельно
    // Кроме initial блока в SystemVerilog существует еще много других процессов, среди которых:
    // always, always_comb always_ff, assign и др.

        // Для удобства и читаемости кода опишем по одному initial блоку для входов каждого из типов мультиплексоров (2_to_1, 4_to_1, bp)
        // Но могли бы сделать это и в одном единственном initial для всех входов сразу

        // Начальные значения входных сигналов
        dat_a_2_to_1 = 1;
        dat_b_2_to_1 = 0;
        sel_2_to_1 = 0;

        // Пусть заданные выше значения сохраняются от начала симуляции до времени 10 нс
        // После 10 нс симуляции изменим сигнал sel на входе мультиплексора
        // Команда ожидания:
        #(10); // нс (см. директиву `timescale в начале файла)

        // Изменим сигнал sel
        // С момента 10 нс сигнал на выходе мультиплексора должен соответствовать его входу dat_b_2_to_1
        sel_2_to_1 = 1;

    end

    initial begin // В этом initial описаны изменения входов всех мультиплексоров, кроме 2_to_1 и шинного параметризуемого

        dat_i_4_to_1 = 4'b1010;
        sel_4_to_1 = 0;
        #(5);

        repeat(3) begin // цикл повторения
            sel_4_to_1 += 1;
            #(5);
        end

        dat_i_4_to_1 = 4'b1100;
        sel_4_to_1 = 0;

        repeat(3) begin
            sel_4_to_1 += 1;
            #(5);
        end

    end

    initial begin

        dat_i_bp[0] = 4'ha;
        dat_i_bp[1] = 4'hb;
        dat_i_bp[2] = 4'hc;
        dat_i_bp[3] = 4'hd;
        sel_bp = 0;

        #(10);

        sel_bp = 1;

    end

    // Инстанцирование (использование, вставка) экземпляров тестовых модулей
    // В названиях часто применяются аббревиатуры DUT (design under test) и UUT (unit under test)

    mux_proc_if_2_to_1 dut_mux_proc_if_2_to_1 (
        .sel(sel_2_to_1),
        .dat_a(dat_a_2_to_1),
        .dat_b(dat_b_2_to_1),
        .dat_o(dat_o_2_to_1)
    );

    mux_cont_idx_4_to_1 dut_mux_cont_idx_4_to_1 (
        .sel(sel_4_to_1),
        .dat_i(dat_i_4_to_1),
        .dat_o(dat_o_cont_idx_4_to_1)
    );

    mux_proc_if_4_to_1 dut_mux_proc_if_4_to_1 (
        .sel(sel_4_to_1),
        .dat_i(dat_i_4_to_1),
        .dat_o(dat_o_proc_if_4_to_1)
    );

    mux_proc_if_4_to_1_weird dut_mux_proc_if_4_to_1_weird (
        .sel(sel_4_to_1),
        .dat_i(dat_i_4_to_1),
        .dat_o(dat_o_proc_if_4_to_1_weird)
    );

    mux_proc_case_4_to_1_weird dut_mux_proc_case_4_to_1_weird (
        .sel(sel_4_to_1),
        .dat_i(dat_i_4_to_1),
        .dat_o(dat_o_proc_case_4_to_1_weird)
    );

    mux_bus_prm #(
        .SEL_WIDTH(SEL_WIDTH_BP),
        .DAT_WIDTH(DAT_WIDTH_BP)
    ) dut_mux_bus_prm (
        .sel(sel_bp),
        .dat_i(dat_i_bp),
        .dat_o(dat_o_bp)
    );

endmodule

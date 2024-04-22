module mux_proc_if_2_to_1 (
    input logic dat_a, dat_b, sel, // входные порты типа logic (1 bit 4 состояния: 1, 0, x, z)
    output logic dat_o // выходной порт типа logic
);

    always@(*) begin // ПРОЦЕДУРНЫЙ БЛОК // для данного модуля аналогично always@(dat_a or dat_b or sel)
        if(sel) begin
            dat_o = dat_b; // БЛОКИРУЮЩЕЕ ПРИСВАИВАНИЕ (BLOCKING ASSIGNMENT)
        end else begin
            dat_o = dat_a;
        end
    end

endmodule


module mux_cont_idx_4_to_1 (
    input logic [3 : 0] dat_i, // для типа logic можно задавать размерность; это называется "УПАКОВАННЫЙ МАССИВ"
    input logic [1 : 0] sel,
    output logic dat_o
);

    assign dat_o = dat_i[sel]; // НЕПРЕРЫВНОЕ ПРИСВАИВАНИЕ (CONTINUOUS ASSIGNMENT)

endmodule


module mux_proc_if_4_to_1 (
    input logic [3 : 0] dat_i,
    input logic [1 : 0] sel,
    output logic dat_o
);

    always@(*) begin
        // begin-end можно упускать, если внутри if/else блока - только одна инструкция
        if(sel == 0) // Литералы (в данном случае - "0") - 32-разрядные числа
            dat_o = dat_i[0];
        else if(sel == 1)
            dat_o = dat_i[1];
        else if(sel == 2)
            dat_o = dat_i[1];
        else if(sel == 3)
            dat_o = dat_i[1];
    end

endmodule


module mux_proc_if_4_to_1_weird (
    input logic [3 : 0] dat_i,
    input logic [1 : 0] sel,
    output logic dat_o
);

    always@(*) begin
        dat_o = 0; // Суть блокирующего присваивания в том, что при нескольких написанных подряд присваиваниях
        // одному и тому же операнду, ему присваивается значение, соответствующее последнему из них, а все остальные - отбрасываются
        if(sel == 2)      dat_o = dat_i[2];
        else if(sel == 3) dat_o = dat_i[3];
        // Данный мультиплексор будет выдавать на выходе следующие значения:
        // 0        при sel == 0
        // 0        при sel == 1
        // dat_i[2] при sel == 2
        // dat_i[3] при sel == 3
        // При описании КОМБИНАЦИОННОЙ ЛОГИКИ внутри always блока
        // НЕЛЬЗЯ ОСТАВЛЯТЬ УСЛОВИЙ С НЕНАЗНАЧЕННЫМИ ВЫХОДАМИ
        // Если бы в первой строке данного always блока не было бы команды присваивания,
        // мультиплексор работал бы не так, как мы бы от него ожидали (сгенерировалась бы защелка)
        // Синтезатор воспринял бы это не как "при sel == 0, 1 установить dat_o = 0",
        // а как "при sel == 0, 1 значение dat_o не изменять"
    end

endmodule


module mux_proc_case_4_to_1_weird (
    input logic [3 : 0] dat_i,
    input logic [1 : 0] sel,
    output logic dat_o
);

    always_comb begin // при описании комбинационной логики желательно использовать always_comb вместо always@(*)
        case(sel) // на месте "sel" может быть выражение, например, (sel) аналогично (sel == 1)
            2'b01   : dat_o = dat_i[2'b01];
            2'b10,
            2'b11   : dat_o = dat_i[2'b10];
            default : dat_o = 1;
            // Если не использовать "default", можно написать на первой строке always блока "dat_o = 1", по аналогии с модулем mux_always_if_4_to_1_weird,
            // но назначить все выходы ДЛЯ ВСЕХ УСЛОВИЙ каким-нибудь из способов НЕОБХОДИМО, если мы описываем КОМБИНАЦИОННУЮ ЛОГИКУ
        endcase
        // Данный мультиплексор будет выдавать на выходе следующие значения:
        // 1            при sel == 0
        // dat_i[1]     при sel == 1
        // dat_i[2]     при sel == 2
        // dat_i[2]     при sel == 3

    end

endmodule


module mux_bus_prm #(
    parameter int unsigned SEL_WIDTH = 2, // 2 - значение по умолчанию; будет выбрано, если при инстанцировании (вставке) модуля не указать значение явно
    parameter int unsigned DAT_WIDTH = 2 // Если значение по умолчанию не задано, его нужно указать явно при инстанцировании модуля, иначе синтезатор/симулятор выдаст ошибку
) (
    input logic [SEL_WIDTH - 1 : 0] sel,
    input logic [2**SEL_WIDTH - 1 : 0][DAT_WIDTH - 1 : 0] dat_i, // Двумерный упакованный массив
    // При выбор элементов осуществляется в такой же последовательности, как и их объявление
    // Примеры:
    // dat_i[0][2] - выбор бита 2 из 0-вой шины (размерность 1)
    // dat_i[1] - выбор всей 1ой шины (размерность равна размерности шины)
    output logic [2**SEL_WIDTH - 1 : 0][DAT_WIDTH - 1 : 0] dat_o
);

    assign dat_o = dat_i[sel];

endmodule

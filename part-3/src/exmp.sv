module exmp_moore(
    input clk,
    input rst,
    input in,
    output out
);

    // Тип enum
    // Если используется больше, чем в 1 месте кода, нужно использовать typedef
    enum logic [1:0] {S0 = 2'b00, S1 = 2'b01, S2 = 2'b10}  state, next;

    // Регистр, хранящий текущее состояние
    always_ff @(posedge clk) begin
        if (rst) state <= S0;
        else     state <= next;
    end

    // Входная комбинационная логика автомата (логика формирования следующего состояния)
    always_comb begin
        next = state; // эта строка "покрывает" все случаи, когда состояние автомата не должно меняться
        // Если бы ее не было, нам бы пришлось описывать else ветку для каждого из состояний
        case (state)
            S0 : if(in == 0) next = S1;
            S1 : if(in == 1) next = S2;
            S2 :
            begin
                if(in == 1)  next = S0;
                else         next = S1;
            end
            default :        next = S0;
        endcase
    end

    // Выходная комбинационная логика
    // Для автомата Мура зависит только от текущего состояния
    assign out = (state == S2);

endmodule


module exmp_mealy(
    input clk,
    input rst,
    input in,
    output out
);

    // Тип enum
    // Если используется больше, чем в 1 месте кода, нужно использовать typedef
    enum logic [1:0] {S0 = 2'b00, S1 = 2'b01}  state, next;

    always_ff @(posedge clk) begin
        if (rst) state <= S0;
        else     state <= next;
    end

    // Входная комбинационная логика автомата (логика формирования следующего состояния)
    always_comb begin
        next = state; // эта строка "покрывает" все случаи, когда состояние автомата не должно меняться
        // Если бы ее не было, нам бы пришлось описывать else ветку для каждого из состояний
        case (state)
            S0 : if(in == 0) next = S1;
            S1 : if(in == 1) next = S0;
            default :        next = S0;
        endcase
    end

    // Выходная комбинационная логика
    // Для автомата Мили зависит от текущего состояния и входного значения
    assign out = (state == S1) & in;

endmodule

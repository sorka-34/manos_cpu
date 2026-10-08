`timescale 1ps/1ps

module full_adder (
    input X, Y, Cin,
    output D, Cout
);
    wire[1:0] result = X + Y + Cin;
    assign D = result[0];
    assign Cout = result[1];
endmodule

module arithmetic_stage (
    input S0, S1, A, B, Cin,
    output D, Cout
);
    wire mux_out;
    multiplexer_4x1 MUX (.S0(S0), .S1(S1), .M1(1'b0), .M2(B), .M3(~B), .M4(1'b1), .Y(mux_out));
    full_adder FA (.X(A), .Y(mux_out), .Cin(Cin), .D(D), .Cout(Cout));
endmodule
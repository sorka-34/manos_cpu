`timescale 1ps/1ps

module logic_stage (
    input S0, S1, A, B,
    output D
);
    wire and_out, or_out, xor_out, not_out;

    assign and_out = A & B;
    assign or_out = A | B;
    assign xor_out = A ^ B;
    assign not_out = ~A;

    multiplexer_4x1 MUX (.S0(S0), .S1(S1), .M1(and_out), .M2(or_out), .M3(xor_out), .M4(not_out), .Y(D));
endmodule
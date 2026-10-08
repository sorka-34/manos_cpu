`timescale 1ps/1ps

module ALSU_stage (
    input S0, S1, S2, S3, A, B, Cin, Aprev, Anext,
    output F, Cout
);
    wire arith_out, logic_out;

    arithmetic_stage ARITH (.S0(S0), .S1(S1), .A(A), .B(B), .Cin(Cin), .D(arith_out), .Cout(Cout));
    logic_stage LOGIC (.S0(S0), .S1(S1), .A(A), .B(B), .D(logic_out));
    multiplexer_4x1 MUX (.S0(S2), .S1(S3), .M1(arith_out), .M2(logic_out), .M3(Anext), .M4(Aprev), .Y(F));
endmodule

module ALSU (
    input S0, S1, S2, S3, Cin, e_in,
    input [15:0] A, B, bus_in,
    input [7:0] inpr_in,
    output [15:0] F,
    output e_out
);
    wire [15:0] carry;
    wire Cout;
    assign carry[0] = Cin;

    wire [15:0] internal_A = ({S3, S2, S1, S0, Cin} == 5'b00000) ? bus_in : ({S3, S2, S1, S0, Cin} == 5'b00111) ? {A[15:8], inpr_in} : A;
    

    multiplexer_4x1 MUX (.S0(S2), .S1(S3), .M1(Cout), .M2(1'b0), .M3(A[0]), .M4(A[15]), .Y(e_out));

    ALSU_stage AS0 (.S0(S0), .S1(S1), .S2(S2), .S3(S3), .A(internal_A[0]), .B(B[0]), .Cin(carry[0]), .Aprev(e_in), .Anext(A[1]), .F(F[0]), .Cout(carry[1]));
    genvar i;
    generate
        for (i = 1; i < 15; i = i + 1) begin : alsu_body
            ALSU_stage AS (.S0(S0), .S1(S1), .S2(S2), .S3(S3), .A(internal_A[i]), .B(B[i]), .Cin(carry[i]), .Aprev(A[i-1]), .Anext(A[i+1]), .F(F[i]), .Cout(carry[i+1]));
        end
    endgenerate
    ALSU_stage AS15 (.S0(S0), .S1(S1), .S2(S2), .S3(S3), .A(internal_A[15]), .B(B[15]), .Cin(carry[15]), .Aprev(A[14]), .Anext(e_in), .F(F[15]), .Cout(Cout));
endmodule

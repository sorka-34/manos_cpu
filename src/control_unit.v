`timescale 1ps/1ps

module control_unit (
    input rst, clk, E, I, R, IEN, FGI, FGO, S, fgi_set, fgo_set,
    input [15:0] DR, AC, IR,
    output R_S0, R_S1, R_S2, OP_S0, OP_S1, OP_S2, OP_S3, Cin, ir_ld, outr_ld, mem_ld,
    output [1:0] sc_ctrl, // {CLR, INR}
    output [2:0] dr_ctrl, ar_ctrl, ac_ctrl, pc_ctrl, tr_ctrl, // {CLR, LD, INR}
    output [2:0] ien_ctrl ,r_ctrl, fgi_ctrl, fgo_ctrl, s_ctrl,// {CLR, SET, INV}
    output [3:0] e_ctrl, i_ctrl  // {CLR, LD, SET, INV}
);
    wire [3:0] sc_out;
    wire [7:0] D;
    wire [15:0] T;

    sequence_counter sc (.rst(rst), .clk(clk), .clr(sc_ctrl[1]), .inr(sc_ctrl[0]), .sc_out(sc_out));
    decoder_4x16 dec_4x16 (.x(sc_out), .y(T));
    decoder_3x8 dec_3x8 (.x(IR[14:12]), .y(D));
    control_gates ctrl_g (.E(E), .I(I), .R(R), .IEN(IEN), .FGI(FGI), .FGO(FGO), .S(S), .fgi_set(fgi_set), .fgo_set(fgo_set), .DR(DR), .AC(AC), .IR(IR[11:0]), .T(T), .D(D), .R_S0(R_S0), .R_S1(R_S1), .R_S2(R_S2), .OP_S0(OP_S0), .OP_S1(OP_S1), .OP_S2(OP_S2), .OP_S3(OP_S3), .Cin(Cin), .ir_ld(ir_ld), .outr_ld(outr_ld), .mem_ld(mem_ld), .sc_ctrl(sc_ctrl), .dr_ctrl(dr_ctrl), .ar_ctrl(ar_ctrl), .ac_ctrl(ac_ctrl), .pc_ctrl(pc_ctrl), .tr_ctrl(tr_ctrl), .ien_ctrl(ien_ctrl), .r_ctrl(r_ctrl), .fgi_ctrl(fgi_ctrl), .fgo_ctrl(fgo_ctrl), .s_ctrl(s_ctrl), .e_ctrl(e_ctrl), .i_ctrl(i_ctrl));
endmodule
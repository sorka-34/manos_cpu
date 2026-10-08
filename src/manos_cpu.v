`timescale 1ps/1ps

module manos_cpu (
    input rst, clk, fgi_set, fgo_set, inpr_ld,
    input [7:0] inpr_in,
    input [15:0] mem_in, 
    output mem_ld,
    output [7:0] outr_out,
    output [11:0] AR,
    output [15:0] mem_out
);

    wire R_S0, R_S1, R_S2, OP_S0, OP_S1, OP_S2, OP_S3, Cin, ir_ld, outr_ld, E, I, IEN, R, FGI , FGO, S;
    wire [1:0] sc_ctrl;
    wire [2:0] dr_ctrl, ar_ctrl, ac_ctrl, pc_ctrl, tr_ctrl, ien_ctrl ,r_ctrl, fgi_ctrl, fgo_ctrl, s_ctrl;
    wire [3:0] e_ctrl, i_ctrl;
    wire [15:0] DR, AC, IR;


    datapath dp (.rst(rst), .clk(clk), .R_S0(R_S0), .R_S1(R_S1), .R_S2(R_S2), .OP_S0(OP_S0), .OP_S1(OP_S1), .OP_S2(OP_S2), .OP_S3(OP_S3), .Cin(Cin), .ir_ld(ir_ld), .inpr_ld(inpr_ld), .outr_ld(outr_ld), .dr_ctrl(dr_ctrl), .ar_ctrl(ar_ctrl), .ac_ctrl(ac_ctrl), .pc_ctrl(pc_ctrl), .tr_ctrl(tr_ctrl), .e_ctrl(e_ctrl), .i_ctrl(i_ctrl), .ien_ctrl(ien_ctrl), .r_ctrl(r_ctrl), .fgi_ctrl(fgi_ctrl), .fgo_ctrl(fgo_ctrl), .s_ctrl(s_ctrl), .mem_in(mem_in), .inpr_in(inpr_in), .outr_out(outr_out), .ar_port(AR), .mem_out(mem_out), .ir_port(IR), .dr_port(DR), .ac_port(AC), .e_out(E), .i_out(I), .r_out(R), .ien_out(IEN), .fgi_out(FGI), .fgo_out(FGO), .s_out(S));
    control_unit cu (.rst(rst), .clk(clk), .E(E), .I(I), .R(R), .IEN(IEN), .FGI(FGI), .FGO(FGO), .S(S), .fgi_set(fgi_set), .fgo_set(fgo_set), .DR(DR), .AC(AC), .IR(IR), .R_S0(R_S0), .R_S1(R_S1), .R_S2(R_S2), .OP_S0(OP_S0), .OP_S1(OP_S1), .OP_S2(OP_S2), .OP_S3(OP_S3), .Cin(Cin), .ir_ld(ir_ld), .outr_ld(outr_ld), .mem_ld(mem_ld), .sc_ctrl(sc_ctrl), .dr_ctrl(dr_ctrl), .ar_ctrl(ar_ctrl), .ac_ctrl(ac_ctrl), .pc_ctrl(pc_ctrl), .tr_ctrl(tr_ctrl), .ien_ctrl(ien_ctrl), .r_ctrl(r_ctrl), .fgi_ctrl(fgi_ctrl), .fgo_ctrl(fgo_ctrl), .s_ctrl(s_ctrl), .e_ctrl(e_ctrl), .i_ctrl(i_ctrl));
endmodule
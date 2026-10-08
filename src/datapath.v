`timescale 1ps/1ps

module datapath (
    input R_S0, R_S1, R_S2, OP_S0, OP_S1, OP_S2, OP_S3, Cin, rst, clk, ir_ld, inpr_ld, outr_ld,
    input [2:0] dr_ctrl, ar_ctrl, ac_ctrl, pc_ctrl, tr_ctrl, // {CLR, LD, INR}
    input [3:0] e_ctrl, i_ctrl, // {CLR, LD, SET, INV}
    input [2:0] ien_ctrl ,r_ctrl, fgi_ctrl, fgo_ctrl, s_ctrl, // {CLR, SET, INV}
    input [15:0] mem_in,
    input [7:0] inpr_in,
    output [7:0] outr_out,
    output [11:0] ar_port,
    output [15:0] mem_out, ir_port, dr_port, ac_port, tr_port, pc_port,
    output e_out, i_out, r_out, ien_out, fgi_out, fgo_out, s_out
);
    wire alsu_to_E, E_to_other; 
    wire [15:0] ac_out, dr_out, tr_out, ir_out, bus, alsu_out;
    wire [11:0] ar_out, pc_out;
    wire [7:0] inpr_out;

    assign mem_out = bus;
    assign ir_port = ir_out;
    assign dr_port = dr_out;
    assign ac_port = ac_out;
    assign ar_port = ar_out;
    assign tr_port = tr_out;
    assign pc_port = pc_out;
    assign e_out = E_to_other;

    ALSU ALSU (.S0(OP_S0), .S1(OP_S1), .S2(OP_S2), .S3(OP_S3), .A(ac_out), .B(dr_out), .Cin(Cin), .bus_in(bus), .inpr_in(inpr_out), .e_out(alsu_to_E), .e_in(E_to_other), .F(alsu_out));
    register_bank register_bank (.rst(rst), .clk(clk), .ac_out(ac_out), .dr_out(dr_out), .ar_out(ar_out), .pc_out(pc_out), .tr_out(tr_out), .ir_out(ir_out), .inpr_out(inpr_out), .outr_out(outr_out), .ac_in(alsu_out), .inpr_in(inpr_in), .bus_in(bus), .dr_ctrl(dr_ctrl), .ar_ctrl(ar_ctrl), .ac_ctrl(ac_ctrl), .pc_ctrl(pc_ctrl), .tr_ctrl(tr_ctrl), .ir_ld(ir_ld), .inpr_ld(inpr_ld), .outr_ld(outr_ld));
    cpu_bus cpu_bus (.S0(R_S0), .S1(R_S1), .S2(R_S2), .ac_in(ac_out), .dr_in(dr_out), .ar_in(ar_out), .pc_in(pc_out), .tr_in(tr_out), .ir_in(ir_out), .mem_in(mem_in), .bus(bus));
    flags flags(.rst(rst), .clk(clk), .e_in(alsu_to_E), .i_in(ir_out[15]), .e_ctrl(e_ctrl), .i_ctrl(i_ctrl), .ien_ctrl(ien_ctrl), .r_ctrl(r_ctrl), .fgi_ctrl(fgi_ctrl), .fgo_ctrl(fgo_ctrl), .s_ctrl(s_ctrl), .e_out(E_to_other), .i_out(i_out), .ien_out(ien_out), .r_out(r_out), .fgi_out(fgi_out), .fgo_out(fgo_out), .s_out(s_out));
endmodule
`timescale 1ps/1ps

module register_bank (
    input [2:0] dr_ctrl, ar_ctrl, ac_ctrl, pc_ctrl, tr_ctrl, // {CLR, LD, INR}
    input rst, clk, ir_ld, inpr_ld, outr_ld, 
    input [15:0] bus_in, ac_in,
    input [7:0] inpr_in,
    output [15:0] dr_out, ac_out, ir_out, tr_out,
    output [11:0] ar_out, pc_out,
    output [7:0] inpr_out, outr_out
);
    // Default size is 16 unless specified otherwise in code
    cpu_register DR (.rst(rst), .clk(clk), .ld(dr_ctrl[1]), .inr(dr_ctrl[0]), .clr(dr_ctrl[2]), .data_in(bus_in), .data_out(dr_out));
    cpu_register #(.WIDTH(12)) AR (.rst(rst), .clk(clk), .ld(ar_ctrl[1]), .inr(ar_ctrl[0]), .clr(ar_ctrl[2]), .data_in(bus_in[11:0]), .data_out(ar_out));
    cpu_register AC (.rst(rst), .clk(clk), .ld(ac_ctrl[1]), .inr(ac_ctrl[0]), .clr(ac_ctrl[2]), .data_in(ac_in), .data_out(ac_out));
    cpu_register_ld_only IR (.rst(rst), .clk(clk), .ld(ir_ld), .data_in(bus_in), .data_out(ir_out));
    cpu_register #(.WIDTH(12), .DEFAULT(16)) PC (.rst(rst), .clk(clk), .ld(pc_ctrl[1]), .inr(pc_ctrl[0]), .clr(pc_ctrl[2]), .data_in(bus_in[11:0]), .data_out(pc_out));
    cpu_register TR (.rst(rst), .clk(clk), .ld(tr_ctrl[1]), .inr(tr_ctrl[0]), .clr(tr_ctrl[2]), .data_in(bus_in), .data_out(tr_out));
    cpu_register_ld_only #(.WIDTH(8)) INPR (.rst(rst), .clk(clk), .ld(inpr_ld), .data_in(inpr_in), .data_out(inpr_out));
    cpu_register_ld_only #(.WIDTH(8)) OUTR (.rst(rst), .clk(clk), .ld(outr_ld), .data_in(bus_in[7:0]), .data_out(outr_out));
endmodule
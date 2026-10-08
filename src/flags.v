`timescale 1ps/1ps

module flags (
    input rst, clk, e_in, i_in,
    input [3:0] e_ctrl, i_ctrl,
    input [2:0] ien_ctrl ,r_ctrl, fgi_ctrl, fgo_ctrl, s_ctrl,
    output e_out, i_out, ien_out, r_out, fgi_out, fgo_out, s_out
);
    cpu_flag E (.rst(rst), .clk(clk), .ld(e_ctrl[2]), .set(e_ctrl[1]), .inv(e_ctrl[0]), .clr(e_ctrl[3]), .flag_in(e_in), .flag_out(e_out));
    cpu_flag I (.rst(rst), .clk(clk), .ld(i_ctrl[2]), .set(i_ctrl[1]), .inv(i_ctrl[0]), .clr(i_ctrl[3]), .flag_in(i_in), .flag_out(i_out));
    cpu_flag IEN (.rst(rst), .clk(clk), .set(ien_ctrl[1]), .inv(ien_ctrl[0]), .clr(ien_ctrl[2]), .flag_out(ien_out));
    cpu_flag R (.rst(rst), .clk(clk), .set(r_ctrl[1]), .inv(r_ctrl[0]), .clr(r_ctrl[2]), .flag_out(r_out));
    cpu_flag FGI (.rst(rst), .clk(clk), .set(fgi_ctrl[1]), .inv(fgi_ctrl[0]), .clr(fgi_ctrl[2]), .flag_out(fgi_out));
    cpu_flag FGO (.rst(rst), .clk(clk), .set(fgo_ctrl[1]), .inv(fgo_ctrl[0]), .clr(fgo_ctrl[2]), .flag_out(fgo_out));
    cpu_flag #(.DEFAULT(1'b1)) S (.rst(rst), .clk(clk), .set(s_ctrl[1]), .inv(s_ctrl[0]), .clr(s_ctrl[2]), .flag_out(s_out));
endmodule
`timescale 1ps/1ps

module cpu_register #(
    parameter WIDTH = 16,
    parameter DEFAULT = 0
) (
    input rst, clk, ld, inr, clr,
    input [WIDTH-1:0] data_in,
    output reg [WIDTH-1:0] data_out
);

    always @(posedge clk) begin
        if (rst == 1'b1) begin
            data_out <= DEFAULT;
        end else if (clr == 1'b1) begin
            data_out <= 0;
        end else if (ld == 1'b1) begin
            data_out <= data_in;
        end else if (inr == 1'b1) begin
            data_out <= data_out + 1;
        end
    end
endmodule

module cpu_register_ld_only #(
    parameter WIDTH = 16,
    parameter DEFAULT = 0
) (
    input rst, clk, ld,
    input [WIDTH-1:0] data_in,
    output reg [WIDTH-1:0] data_out
);

    always @(posedge clk) begin
        if (rst == 1'b1) begin
            data_out <= DEFAULT;
        end else if (ld == 1'b1) begin
            data_out <= data_in;
        end
    end
endmodule
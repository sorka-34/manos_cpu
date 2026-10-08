`timescale 1ps/1ps

module cpu_flag #(
    parameter DEFAULT = 1'b0
) (
    input rst, clk, ld, set, clr, inv, flag_in,
    output reg flag_out
);
    always @(posedge clk) begin
        if (rst == 1'b1) begin
            flag_out <= DEFAULT;
        end else if (clr == 1'b1) begin
            flag_out <= 1'b0;
        end else if (ld == 1'b1) begin
            flag_out <= flag_in;
        end else if (set == 1'b1) begin
            flag_out <= 1'b1;
        end else if (inv == 1'b1) begin
            flag_out <= ~flag_out;
        end
    end
endmodule
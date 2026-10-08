`timescale 1ps/1ps

module sequence_counter (
    input rst, clk, clr, inr,
    output reg [3:0] sc_out
);

    always @(posedge clk ) begin
        if (rst == 1'b1) begin
            sc_out <= 4'b0000;
        end else if (clr == 1'b1) begin
            sc_out <= 4'b0000;    
        end else if (inr == 1'b1 && sc_out < 15) begin
            sc_out <= sc_out + 1;
        end else if (inr == 1'b1 && sc_out >= 15)begin
            sc_out <= 4'b0000;
        end
    end
endmodule
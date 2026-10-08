`timescale 1ps/1ps

module multiplexer_8x1 (
    input S0, S1, S2,
    input [7:0] M,
    output reg Y
);
    always @(*) begin
        case ({S2, S1, S0})
            3'b000: Y = M[0];
            3'b001: Y = M[1];
            3'b010: Y = M[2];
            3'b011: Y = M[3];
            3'b100: Y = M[4];
            3'b101: Y = M[5];
            3'b110: Y = M[6];
            3'b111: Y = M[7];
        endcase
    end 
endmodule
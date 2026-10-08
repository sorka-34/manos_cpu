`timescale 1ps/1ps

module multiplexer_4x1 (
    input S0, S1, M1, M2, M3, M4,
    output reg Y
);
    always @(*) begin
        case ({S1, S0})
            2'b00: Y = M1;
            2'b01: Y = M2;
            2'b10: Y = M3;
            2'b11: Y = M4;
        endcase
    end 
endmodule
`timescale 1ps/1ps

module cpu_bus (
    input S0, S1, S2,
    input [15:0] dr_in, ac_in, ir_in, tr_in, mem_in,
    input [11:0] ar_in, pc_in,
    output [15:0] bus
);

    genvar i;
    generate 
        for (i = 0; i < 12; i = i + 1) begin : first_12_muxes
            multiplexer_8x1 MUX (.S0(S0), .S1(S1), .S2(S2), .M({mem_in[i], tr_in[i], ir_in[i], ac_in[i], dr_in[i], pc_in[i], ar_in[i], 1'b0}), .Y(bus[i]));
        end
    endgenerate
    
    generate
        for (i = 12; i < 16; i = i + 1) begin : last_4_muxes
            multiplexer_8x1 MUX (.S0(S0), .S1(S1), .S2(S2), .M({mem_in[i], tr_in[i], ir_in[i], ac_in[i], dr_in[i], 1'b0, 1'b0, 1'b0}), .Y(bus[i]));
        end
    endgenerate
endmodule
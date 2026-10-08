`timescale 1ps/1ps

module control_gates (
    input I, R, FGI, FGO, IEN, E, S, fgi_set, fgo_set,
    input [15:0] T, DR, AC, 
    input [7:0] D, 
    input [11:0] IR,
    output ir_ld, outr_ld, mem_ld,
    output reg R_S0, R_S1, R_S2, OP_S0, OP_S1, OP_S2, OP_S3, Cin,
    output [1:0] sc_ctrl, // {CLR, INR}
    output [2:0] dr_ctrl, ar_ctrl, ac_ctrl, pc_ctrl, tr_ctrl, // {CLR, LD, INR}
    output [2:0] ien_ctrl ,r_ctrl, fgi_ctrl, fgo_ctrl, s_ctrl,// {CLR, SET, INV}
    output [3:0] e_ctrl, i_ctrl  // {CLR, LD, SET, INV}
);
    // Memory Logic
    // Load into Memory from bus (Memory Write)
    assign mem_ld = R&T[1] | D[3]&T[4] | D[5]&T[4] | D[6]&T[6];

    // AR Logic
    // Clear AR
    assign ar_ctrl[2] = R&T[0];
    // Load into AR from bus
    assign ar_ctrl[1] = ~R&T[0] | ~R&T[2] | ~D[0]&~D[7]&I&T[3];
    // Increment AR
    assign ar_ctrl[0] = D[5]&T[4];

    // PC Logic
    // Clear PC
    assign pc_ctrl[2] = R&T[1];
    // Load into PC from bus
    assign pc_ctrl[1] = D[4]&T[4] | D[5]&T[5];
    // Increment PC
    assign pc_ctrl[0] = ~R&T[1] | R&T[2] | D[6]&T[6]&(DR == 0) | D[7]&~I&T[3]&IR[4]&~AC[15] | D[7]&~I&T[3]&IR[3]&AC[15] | D[7]&~I&T[3]&IR[2]&(AC == 0) | D[7]&~I&T[3]&IR[1]&~E | D[7]&I&T[3]&IR[9]&FGI | D[7]&I&T[3]&IR[8]&FGO;

    // DR Logic
    // Clear DR
    assign dr_ctrl[2] = 1'b0;
    // Load into DR from bus
    assign dr_ctrl[1] = D[0]&T[4] | D[1]&T[4] | D[6]&T[4];
    // Increment DR
    assign dr_ctrl[0] = D[6]&T[5];

    // AC Logic
    // Clear AC
    assign ac_ctrl[2] = D[7]&~I&T[3]&IR[11];
    // Load into AC from bus
    assign ac_ctrl[1] = D[2]&T[4] | D[7]&~I&T[3]&(IR[9]|IR[7]|IR[6]) | D[7]&I&T[3]&IR[11] | D[0]&I&T[3]&(IR[11]|IR[10]|IR[9]|IR[8]|IR[7]|IR[6]|IR[5]|IR[4]);
    // Increment AC
    assign ac_ctrl[0] = D[7]&~I&T[3]&IR[5];

    // IR Logic
    // Load into IR from bus
    assign ir_ld = ~R&T[1];

    // TR Logic
    // Clear TR
    assign tr_ctrl[2] = 1'b0;
    // Load into TR from bus
    assign tr_ctrl[1] = R&T[0];
    // Increment TR
    assign tr_ctrl[0] = 1'b0;

    // OUTR Logic
    // Load into OUTR from bus
    assign outr_ld = D[7]&I&T[3]&IR[10];

    // SC Logic
    // Clear SC
    assign sc_ctrl[1] = R&T[2] | T[4]&(D[0]|D[1]|D[2]|D[3]|D[4]) | D[5]&T[5] | D[6]&T[6] | D[7]&T[3] | D[0]&I&T[3];
    // Increment SC
    assign sc_ctrl[0] = S;

    // E Logic
    // Clear E
    assign e_ctrl[3] = D[7]&~I&T[3]&IR[10];
    // Load into E 
    assign e_ctrl[2] = D[0]&I&T[3]&IR[8] | D[7]&~I&T[3]&IR[7] | D[7]&~I&T[3]&IR[6];
    // Set E
    assign e_ctrl[1] = 1'b0;
    // Invert E
    assign e_ctrl[0] = D[7]&~I&T[3]&IR[8];

    // I Logic
    // Clear
    assign i_ctrl[3] = 1'b0;
    // Load into I from bus
    assign i_ctrl[2] = ~R&T[2];
    // Set I
    assign i_ctrl[1] = 1'b0;
    // Invert I
    assign i_ctrl[0] = 1'b0;

    // R Logic
    // Clear R
    assign r_ctrl[2] = R&T[2];
    // Set R
    assign r_ctrl[1] = ~T[0]&~T[1]&~T[2]&IEN&(FGI | FGO);
    // Invert R
    assign r_ctrl[0] = 1'b0;

    // IEN Logic
    // Clear IEN
    assign ien_ctrl[2] = R&T[2] | D[7]&I&T[3]&IR[6];
    // Set IEN
    assign ien_ctrl[1] = D[7]&I&T[3]&IR[7];
    // Invert IEN
    assign ien_ctrl[0] = 1'b0;

    // FGI Logic
    // Clear FGI
    assign fgi_ctrl[2] = D[7]&I&T[3]&IR[11];
    // Set FGI
    assign fgi_ctrl[1] = fgi_set;
    // Invert FGI
    assign fgi_ctrl[0] = 1'b0;

    // FGO Logic
    // Clear FGO
    assign fgo_ctrl[2] = D[7]&I&T[3]&IR[10];
    // Set FGO
    assign fgo_ctrl[1] = fgo_set;
    // Invert FGO
    assign fgo_ctrl[0] = 1'b0;

    // S Logic
    // Clear S
    assign s_ctrl[2] = D[7]&~I&T[3]&IR[0];
    // Set S
    assign s_ctrl[1] = 1'b0;
    // Invert S
    assign s_ctrl[0] = 1'b0;

    
    always @(*) begin
        // ALSU Operation Select Logic
        case (1'b1)
            D[7]&~I&T[3]&IR[9]: {OP_S3, OP_S2, OP_S1, OP_S0, Cin} = 5'b01110;
            D[7]&~I&T[3]&IR[7]: {OP_S3, OP_S2, OP_S1, OP_S0, Cin} = 5'b10000;
            D[7]&~I&T[3]&IR[6]: {OP_S3, OP_S2, OP_S1, OP_S0, Cin} = 5'b11000;
            D[0]&I&T[3]&IR[11]: {OP_S3, OP_S2, OP_S1, OP_S0, Cin} = 5'b01000;
            D[0]&I&T[3]&IR[10]: {OP_S3, OP_S2, OP_S1, OP_S0, Cin} = 5'b01010;
            D[0]&I&T[3]&IR[9]: {OP_S3, OP_S2, OP_S1, OP_S0, Cin} = 5'b01100;
            D[0]&I&T[3]&IR[8]: {OP_S3, OP_S2, OP_S1, OP_S0, Cin} = 5'b00010;
            D[0]&I&T[3]&IR[7]: {OP_S3, OP_S2, OP_S1, OP_S0, Cin} = 5'b00011;
            D[0]&I&T[3]&IR[6]: {OP_S3, OP_S2, OP_S1, OP_S0, Cin} = 5'b00100;
            D[0]&I&T[3]&IR[5]: {OP_S3, OP_S2, OP_S1, OP_S0, Cin} = 5'b00101;
            D[0]&I&T[3]&IR[4]: {OP_S3, OP_S2, OP_S1, OP_S0, Cin} = 5'b00110;
            D[7]&I&T[3]&IR[11]: {OP_S3, OP_S2, OP_S1, OP_S0, Cin} = 5'b00111;
            D[2]&T[4]: {OP_S3, OP_S2, OP_S1, OP_S0, Cin} = 5'b00000;
            default: {OP_S3, OP_S2, OP_S1, OP_S0, Cin} = 5'b00000;
        endcase

        // Bus Selection Logic
        case (1'b1)
            (~R&T[1] | ~D[0]&~D[7]&I&T[3] | D[1]&T[4] | D[2]&T[4] | D[6]&T[4]): {R_S2, R_S1, R_S0} = 3'b111;
            (D[4]&T[4] | D[5]&T[5]): {R_S2, R_S1, R_S0} = 3'b001;
            (~R&T[0] | R&T[0] | D[5]&T[4]): {R_S2, R_S1, R_S0} = 3'b010;
            (D[6]&T[6]): {R_S2, R_S1, R_S0} = 3'b011;
            (D[3]&T[4] | D[7]&I&T[3]&IR[10]): {R_S2, R_S1, R_S0} = 3'b100;
            (~R&T[2] | D[0]&T[4]): {R_S2, R_S1, R_S0} = 3'b101;
            (R&T[1]): {R_S2, R_S1, R_S0} = 3'b110;
            default: {R_S2, R_S1, R_S0} = 3'b010;
        endcase
    end

endmodule
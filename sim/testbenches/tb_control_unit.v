`timescale 1ps/1ps

module tb_control_unit ();
    reg rst, clk, E, I, R, IEN, FGI, FGO, S;
    reg [15:0] IR, AC, DR;
    wire R_S0, R_S1, R_S2, OP_S0, OP_S1, OP_S2, OP_S3, Cin, ir_ld, inpr_ld, outr_ld, mem_ld;
    wire [1:0] sc_ctrl; // {CLR, INR}
    wire [2:0] dr_ctrl, ar_ctrl, ac_ctrl, pc_ctrl, tr_ctrl; // {CLR, LD, INR}
    wire [2:0] ien_ctrl ,r_ctrl, fgi_ctrl, fgo_ctrl, s_ctrl;// {CLR, SET, INV}
    wire [3:0] e_ctrl, i_ctrl;  // {CLR, LD, SET, INV}

    control_unit dut (.rst(rst), .clk(clk), .E(E), .I(I), .R(R), .IEN(IEN), .FGI(FGI), .FGO(FGO), .S(S), .DR(DR), .AC(AC), .IR(IR), .R_S0(R_S0), .R_S1(R_S1), .R_S2(R_S2), .OP_S0(OP_S0), .OP_S1(OP_S1), .OP_S2(OP_S2), .OP_S3(OP_S3), .Cin(Cin), .ir_ld(ir_ld), .inpr_ld(inpr_ld), .outr_ld(outr_ld), .mem_ld(mem_ld), .sc_ctrl(sc_ctrl), .dr_ctrl(dr_ctrl), .ar_ctrl(ar_ctrl), .ac_ctrl(ac_ctrl), .pc_ctrl(pc_ctrl), .tr_ctrl(tr_ctrl), .ien_ctrl(ien_ctrl), .r_ctrl(r_ctrl), .fgi_ctrl(fgi_ctrl), .fgo_ctrl(fgo_ctrl), .s_ctrl(s_ctrl), .e_ctrl(e_ctrl), .i_ctrl(i_ctrl));


    initial begin
        $dumpfile("tb_control_unit.vcd");
        $dumpvars(0, tb_control_unit);
        R = 1'b0;
        E = 1'b0;
        I = 1'b0;
        IEN = 1'b0;
        FGI = 1'b0;
        FGO = 1'b0;
        S = 1'b1;
        IR = 16'h0000;
        AC = 16'h0000;
        DR = 16'h0000;
        clk = 1'b0;
        rst = 1'b1;
        @(posedge clk);
        rst <= 1'b0;

        @(posedge clk);
        $display("At T = %b and Counter = %b\n -> Register Select = %b\n  ar_ctrl = %b", dut.T, dut.sc_out, {R_S2, R_S1, R_S0}, ar_ctrl);
        @(posedge clk);
        $display("At T = %b and Counter = %b\n -> Register Select = %b\n ir_ld = %b, pc_ctrl = %b", dut.T, dut.sc_out, {R_S2, R_S1, R_S0}, ir_ld, pc_ctrl);
        IR = 16'h1FFF; // LDD Direct, T2: select IR 3'b101 and ar_ctrl = 3'b010 and i_ctrl = 4b'0100, T3: empty, T4: select memory 3'b111 and dr_ctrl = 3'b010
        @(posedge clk);
        $display("At T = %b and Counter = %b\n -> Register Select = %b\n ar_ctrl = %b, i_ctrl = %b", dut.T, dut.sc_out, {R_S2, R_S1, R_S0}, ar_ctrl, i_ctrl);
        @(posedge clk);
        $display("At T = %b and Counter = %b\n -> Register Select = %b\n dr_ctrl = %b, i_ctrl = %b", dut.T, dut.sc_out, {R_S2, R_S1, R_S0}, dr_ctrl, i_ctrl);
        @(posedge clk);
        $display("At T = %b and Counter = %b\n -> Register Select = %b\n dr_ctrl = %b", dut.T, dut.sc_out, {R_S2, R_S1, R_S0}, dr_ctrl);


        // Next Instruction
        @(posedge clk);
        $display("At T = %b and Counter = %b\n -> Register Select = %b\n  ar_ctrl = %b", dut.T, dut.sc_out, {R_S2, R_S1, R_S0}, ar_ctrl);
        @(posedge clk);
        $display("At T = %b and Counter = %b\n -> Register Select = %b\n ir_ld = %b, pc_ctrl = %b", dut.T, dut.sc_out, {R_S2, R_S1, R_S0}, ir_ld, pc_ctrl);
        IR = 16'h8100; // ADD, T2: select IR 3'b101 and ar_ctrl = 3'b010 and i_ctrl = 4b'0100, T3: op select 5'b00010 and ac_ctrl = 3'b010 and e_ctrl = 4'b0100
        @(posedge clk);
        I = IR[15];
        $display("At T = %b and Counter = %b\n -> Register Select = %b\n ac_ctrl = %b, i_ctrl = %b", dut.T, dut.sc_out, {R_S2, R_S1, R_S0}, ar_ctrl, i_ctrl);
        @(posedge clk);
        $display("At T = %b and Instruction Decoder = %b and I = %b\n -> Operation Select = %b\n ac_ctrl = %b, e_ctrl = %b", dut.T, dut.D, I, {OP_S3, OP_S2, OP_S1, OP_S0, Cin}, ac_ctrl, e_ctrl);


        $finish;
    end

    always #5 clk = ~clk;
endmodule
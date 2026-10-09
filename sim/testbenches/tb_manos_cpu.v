`timescale 1ps/1ps

module tb_manos_cpu ();
    reg rst, clk, fgi_set, fgo_set, inpr_ld;
    reg [7:0] inpr_in;
    reg [15:0] memory [0:95];
    wire mem_ld;
    wire [7:0] outr_out;
    wire [11:0] AR;
    wire [15:0] mem_out;

    reg S, FGI, FGO;
    reg [7:0] D, inpr_out;
    reg [15:0] AC, DR, T, IR;


    manos_cpu dut (.rst(rst), .clk(clk), .fgi_set(fgi_set), .fgo_set(fgo_set), .inpr_in(inpr_in), .mem_in(memory[AR]), .mem_ld(mem_ld), .inpr_ld(inpr_ld), .outr_out(outr_out), .AR(AR), .mem_out(mem_out));

    initial begin
        $dumpfile("tb_manos_cpu.vcd");
        $dumpvars(0, tb_manos_cpu);

        assign S = dut.dp.s_out;
        assign FGI = dut.dp.fgi_out;
        assign FGO = dut.dp.fgo_out;
        assign AC = dut.dp.ac_port;
        assign DR = dut.dp.dr_port;
        assign IR = dut.dp.ir_port;
        assign D = dut.cu.D;
        assign T = dut.cu.T;
        assign inpr_out = dut.dp.register_bank.inpr_out;

        inpr_in = $random;

        clk = 1'b0;
        rst = 1'b1;
        @(posedge clk);
        rst <= 1'b0;
        inpr_ld = 1'b1;

        @(posedge clk);
        inpr_ld = 1'b0;

        memory[0] = 16'h0000; // ISA return address location
        memory[1] = 16'hF200; // SKI
        memory[2] = 16'h4004; // BUN
        memory[3] = 16'hF800; // INP
        memory[4] = 16'hF100; // SKO
        memory[5] = 16'h4007; // BUN
        memory[6] = 16'hF400; // OUT
        memory[7] = 16'hF080; // ION
        memory[8] = 16'hC000; // BUN Indirect
        memory[9] = 16'h0000;
        memory[10] = 16'h0000;
        memory[11] = 16'h0000;
        memory[12] = 16'h0000;
        memory[13] = 16'h0000;
        memory[14] = 16'h0000;
        memory[15] = 16'h0000;
        memory[16] = $random & 16'h0FFF; // LDI instruction with embedded operand
        memory[17] = 16'h2038; // LDA
        memory[18] = 16'h5050; // BSA
        memory[19] = 16'h7800; // CLA
        memory[20] = 16'h7004; // SZA
        memory[21] = 16'h7001; // HLT (skipped)
        memory[22] = 16'h7020; // INC
        memory[23] = 16'h7004; // SZA
        memory[24] = 16'h7010; // SPA
        memory[25] = 16'h7001; // HLT (skipped)
        memory[26] = 16'h7200; // CMA
        memory[27] = 16'h7010; // SPA
        memory[28] = 16'h7008; // SNA
        memory[29] = 16'h7001; // HLT (skipped)
        memory[30] = 16'h7040; // CIL
        memory[31] = 16'h7400; // CLE
        memory[32] = 16'h7002; // SZE
        memory[33] = 16'h7001; // HLT (skipped)
        memory[34] = 16'h7080; // CIR
        memory[35] = 16'h7008; // SNA
        memory[36] = 16'h7100; // CME
        memory[37] = 16'h7002; // SZE
        memory[38] = 16'h1039; // LDD
        memory[39] = 16'hA03A; // LDA Indirect
        memory[40] = 16'h8100; // ADD
        memory[41] = 16'h8080; // ADDC
        memory[42] = 16'h303B; // STA
        memory[43] = 16'h903C; // LDD Indirect
        memory[44] = 16'hD03D; // BSA Indirect
        memory[45] = 16'hB03E; // STA Inidrect
        memory[46] = 16'hF080; // ION
        memory[47] = 16'h603F; // ISZ
        memory[48] = 16'h7001; // HLT (skipped)
        memory[49] = 16'h6040; // ISZ, also, receives an interrupt request mid execution which prompts ISA execution
        memory[50] = 16'hF040; // IOF
        memory[51] = 16'hE041; // ISZ Indirect, also, receives an interrupt request mid execution, but doesn't execute ISA
        memory[52] = 16'h7001; // HLT (skipped)
        memory[53] = 16'hE042; // ISZ Indirect
        memory[54] = 16'h7001; // HLT, ends program
        memory[55] = 16'h0000;
        memory[56] = $random; // LDA operand
        memory[57] = $random; // LDD operand
        memory[58] = 16'h0048; // Intermediate address of LDA indirect
        memory[59] = 16'h0000; // STA location
        memory[60] = 16'h0049; // Intermediate address of LDD indirect
        memory[61] = 16'h0056; // Intermediate address of BSA indirect
        memory[62] = 16'h004A; // Intermediate address of STA indirect
        memory[63] = 16'hFFFF; // Loaded by ISZ so that it results in a skip
        memory[64] = $random % 65535; // Loaded by ISZ so that it DOESN'T results in a skip
        memory[65] = 16'h004B; // Intermediate address of ISZ indirect
        memory[66] = 16'h004C; // Intermediate address of ISZ indirect
        memory[67] = 16'h0000;
        memory[68] = 16'h0000;
        memory[69] = 16'h0000;
        memory[70] = 16'h0000;
        memory[71] = 16'h0000;
        memory[72] = $random; // Loaded into AC
        memory[73] = $random; // Loaded into DR
        memory[74] = 16'h0000; // STA indirect location
        memory[75] = 16'hFFFF; // Loaded by ISZ indirect so that it results in a skip
        memory[76] = $random % 65535; // Loaded by ISZ indirect so that it DOESN'T results in a skip
        memory[77] = 16'h0000;
        memory[78] = 16'h0000;
        memory[79] = 16'h0000;
        memory[80] = 16'h0000; // "Logic" subroutine return address is saved here
        memory[81] = 16'h8800; // AND
        memory[82] = 16'h8200; // XOR
        memory[83] = 16'h8400; // OR
        memory[84] = 16'hC050; // BUN Indirect
        memory[85] = 16'h0000;
        memory[86] = 16'h0000; // "Subtract" subroutine return address is saved here
        memory[87] = 16'h8040; // SUBB
        memory[88] = 16'h8020; // SUB
        memory[89] = 16'h8010; // DEC
        memory[90] = 16'hC056; // BUN Indirect
        memory[91] = 16'h0000;
        memory[92] = 16'h0000;
        memory[93] = 16'h0000;
        memory[94] = 16'h0000;
        memory[95] = 16'h0000;
    end

    always #5 clk = ~clk;

    always @(posedge clk) begin
        if (mem_ld) memory[AR] <= mem_out;
        if (S == 0) begin
            $display("STA Locations: memory[59] = %b\n memory[74] = %b\n", memory[59], memory[74]);
            $finish;
        end

        $display(" AR = %d, AC = %b\n DR = %b, T = %b\n", AR, AC, DR, T);
    end

    always @(posedge clk ) begin
        fgi_set <= 1'b0;
        fgo_set <= 1'b0;

        if (AR == 49 && T == 2) begin
            fgi_set <= 1'b1;
            fgo_set <= 1'b1;
        end

        if (AR == 51 && T == 2) begin
            fgi_set <= 1'b1;
            fgo_set <= 1'b1;
        end
    end

endmodule
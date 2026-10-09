`timescale 1ps/1ps

module tb_datapath ();
    reg R_S0, R_S1, R_S2, OP_S0, OP_S1, OP_S2, OP_S3, Cin, rst, clk, ir_ld, inpr_ld, outr_ld;
    reg [2:0] dr_ctrl, ar_ctrl, ac_ctrl, pc_ctrl, tr_ctrl; // {CLR, LD, INR}
    reg [3:0] e_ctrl, i_ctrl; // {CLR, LD, SET, INV}
    reg [2:0] ien_ctrl ,r_ctrl, fgi_ctrl, fgo_ctrl, s_ctrl; // {CLR, SET, INV}
    reg [15:0] mem_in;
    reg [7:0] inpr_in;
    wire [7:0] outr_out;
    wire [11:0] ar_out;
    wire [15:0] ac_out, ir_out, dr_out, mem_out, pc_out, tr_out;
    wire e_out, i_out, r_out, ien_out, fgi_out, fgo_out, s_out;
    reg [15:0] memory [0:11];

    datapath dut (.R_S0(R_S0), .R_S1(R_S1), .R_S2(R_S2), .OP_S0(OP_S0), .OP_S1(OP_S1), .OP_S2(OP_S2), .OP_S3(OP_S3), .Cin(Cin), .rst(rst), .clk(clk), .ir_ld(ir_ld), .inpr_ld(inpr_ld), .outr_ld(outr_ld), .dr_ctrl(dr_ctrl), .ar_ctrl(ar_ctrl), .ac_ctrl(ac_ctrl), .pc_ctrl(pc_ctrl), .tr_ctrl(tr_ctrl), .mem_in(mem_in), .inpr_in(inpr_in), .outr_out(outr_out), .ar_port(ar_out), .mem_out(mem_out), .ir_port(ir_out), .dr_port(dr_out), .ac_port(ac_out), .tr_port(tr_out), .pc_port(pc_out), .e_ctrl(e_ctrl), .i_ctrl(i_ctrl), .ien_ctrl(ien_ctrl), .r_ctrl(r_ctrl), .fgi_ctrl(fgi_ctrl), .fgo_ctrl(fgo_ctrl), .s_ctrl(s_ctrl), .e_out(e_out), .i_out(i_out), .ien_out(ien_out), .r_out(r_out), .fgi_out(fgi_out), .fgo_out(fgo_out), .s_out(s_out));

    task pulse_clock;
        begin
            clk = 1'b1;
            #5;
            clk = 1'b0;
            #5;
        end
    endtask

    task fetch_instruction;
        begin
            // put contents of PC to the bus
            {R_S2, R_S1, R_S0} = 3'b010; 
            pulse_clock;
            // Load from the bus into AR
            ar_ctrl = 3'b010;
            pulse_clock;
            ar_ctrl = 3'b000;
            // Use address in AR to access memory
            mem_in = memory[ar_out];
            pulse_clock;
            // put contents of memory_in to the bus
            {R_S2, R_S1, R_S0} = 3'b111;
            pulse_clock;
            // Load from the bus into IR
            ir_ld = 1'b1;
            pulse_clock;
            ir_ld = 1'b0;
        end
    endtask

    initial begin
        $dumpfile("tb_datapath.vcd");
        $dumpvars(0, tb_datapath);

        memory[0] = 16'h0007;
        memory[1] = 16'h200B;
        memory[2] = 16'h0002;
        memory[3] = 16'h0001;
        memory[4] = 16'h0001;
        memory[5] = 16'h0001;
        memory[6] = 16'h0001;
        memory[7] = 16'h0001;
        memory[8] = 16'h0001;
        memory[9] = 16'h0001;
        memory[10] = 16'h0001;
        memory[11] = $random;

        inpr_in = $random;

        // reset all registers to zero
        clk = 1'b0;
        rst = 1'b1; 
        #5;
        pulse_clock;
        rst = 1'b0;

        // Load input value into INPR
        inpr_ld = 1'b1; 
        pulse_clock;
        inpr_ld = 1'b0; 

        fetch_instruction;

        // Activate signals to load INPR into AC
        {OP_S3, OP_S2, OP_S1, OP_S0, Cin} = ir_out; 
        pulse_clock;

        // Load INPR into AC
        ac_ctrl = 3'b010;   
        pulse_clock;
        ac_ctrl = 3'b000;

        // increment PC
        pc_ctrl = 3'b001; 
        pulse_clock;
        pc_ctrl = 3'b000; 

        fetch_instruction;
        
        // put contents of IR to the bus
        {R_S2, R_S1, R_S0} = 3'b101;
        pulse_clock;

        // Load from the bus into AR
        ar_ctrl = 3'b010;
        pulse_clock;
        ar_ctrl = 3'b000;

        // Use address in AR to access memory
        mem_in = memory[ar_out[11:0]];
        pulse_clock;

        // put contents of memory_in to the bus
        {R_S2, R_S1, R_S0} = 3'b111;
        pulse_clock;

        // load bus content (operand read from memory) into DR
        dr_ctrl = 3'b010;       
        pulse_clock;
        dr_ctrl = 3'b000;

        // Activate signals to perform addition between AC and DR
        {OP_S3, OP_S2, OP_S1, OP_S0, Cin} = ir_out[15:12]; 
        pulse_clock;

        // Load addition result into AC
        ac_ctrl = 3'b010;   
        pulse_clock;
        ac_ctrl = 3'b000; 

        // increment PC
        pc_ctrl = 3'b001;
        pulse_clock;
        pc_ctrl = 3'b000; 

        fetch_instruction;

        // put contents of AC to the bus
        {R_S2, R_S1, R_S0} = 3'b100;
        pulse_clock;

        // Load from the bus into TR
        tr_ctrl = ir_out; 
        pulse_clock;
        tr_ctrl = 3'b000;


        // increment PC
        pc_ctrl = 3'b001;
        pulse_clock;
        pc_ctrl = 3'b000; 

        fetch_instruction;

        // put contents of AC to the bus
        {R_S2, R_S1, R_S0} = 3'b100;
        pulse_clock;

        // Load from the bus into OUTR
        outr_ld = ir_out; 
        pulse_clock;
        outr_ld = 1'b0;

        // increment PC
        pc_ctrl = 3'b001;   
        pulse_clock;
        pc_ctrl = 3'b000;

        fetch_instruction;

        // Perform operation on E flag (invert in this case)
        e_ctrl = ir_out; 
        pulse_clock;
        e_ctrl = 4'b0000;

        // increment PC
        pc_ctrl = 3'b001;   
        pulse_clock;
        pc_ctrl = 3'b000;

        fetch_instruction;

        // Perform operation on I flag (invert in this case)
        i_ctrl = ir_out; 
        pulse_clock;
        i_ctrl = 4'b0000;

        // increment PC
        pc_ctrl = 3'b001;   
        pulse_clock;
        pc_ctrl = 3'b000;

        fetch_instruction;

        // Perform operation on IEN flag (invert in this case)
        ien_ctrl = ir_out; 
        pulse_clock;
        ien_ctrl = 3'b000;

        // increment PC
        pc_ctrl = 3'b001;   
        pulse_clock;
        pc_ctrl = 3'b000;

        fetch_instruction;

        // Perform operation on R flag (invert in this case)
        r_ctrl = ir_out; 
        pulse_clock;
        r_ctrl = 3'b000;

        // increment PC
        pc_ctrl = 3'b001;   
        pulse_clock;
        pc_ctrl = 3'b000;

        fetch_instruction;

        // Perform operation on FGI flag (invert in this case)
        fgi_ctrl = ir_out; 
        pulse_clock;
        fgi_ctrl = 3'b000;

        // increment PC
        pc_ctrl = 3'b001;   
        pulse_clock;
        pc_ctrl = 3'b000;

        fetch_instruction;

        // Perform operation on FGO flag (invert in this case)
        fgo_ctrl = ir_out; 
        pulse_clock;
        fgo_ctrl = 3'b000;

        // increment PC
        pc_ctrl = 3'b001;   
        pulse_clock;
        pc_ctrl = 3'b000;

        fetch_instruction;

        // Perform operation on S flag (invert in this case)
        s_ctrl = ir_out; 
        pulse_clock;
        s_ctrl = 3'b000;
        

        if (ac_out == inpr_in + memory[11] && dr_out == memory[11] && tr_out == ac_out && outr_out == ac_out[7:0] && pc_out == 10 && {e_out, i_out, ien_out, r_out, fgi_out, fgo_out, s_out} == 7'b1111110) begin
            $display("Pass");
        end else begin
            $display("Fail, inpr_in = %b,\n memory[11] = %b,\n ac_out = %b,\n dr_out = %b,\n tr_out = %b,\n outr_out = %b,\n pc_out = %b,\n e_out = %b, i_out = %b, ien_out = %b, r_out = %b, fgi_out = %b, fgo_out = %b, s_out = %b", inpr_in, memory[11], ac_out, dr_out, tr_out, outr_out, pc_out, e_out, i_out, r_out, ien_out, fgi_out, fgo_out, s_out);
        end

        $finish;
    end
    
endmodule
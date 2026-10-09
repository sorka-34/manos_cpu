`timescale 1ps/1ps

module tb_register_bank ();
    reg [2:0] dr_ctrl, ar_ctrl, ac_ctrl, pc_ctrl, tr_ctrl;
    reg rst, clk, ir_ld, inpr_ld, outr_ld;
    reg [15:0] bus_in, ac_in;
    reg [7:0] inpr_in;
    wire [15:0] dr_out, ac_out, ir_out, tr_out;
    wire [11:0] ar_out, pc_out;
    wire [7:0] inpr_out, outr_out;
    integer i;

    register_bank dut (.rst(rst), .clk(clk), .dr_ctrl(dr_ctrl), .ar_ctrl(ar_ctrl), .ac_ctrl(ac_ctrl), .pc_ctrl(pc_ctrl), .tr_ctrl(tr_ctrl), .ir_ld(ir_ld), .inpr_ld(inpr_ld), .outr_ld(outr_ld), .bus_in(bus_in), .ac_in(ac_in), .inpr_in(inpr_in), .dr_out(dr_out), .ar_out(ar_out), .ac_out(ac_out), .ir_out(ir_out), .pc_out(pc_out), .tr_out(tr_out), .inpr_out(inpr_out), .outr_out(outr_out));

    initial begin
        $dumpfile("tb_register_bank.vcd");
        $dumpvars(0, tb_register_bank);

        // Initialize all registers to zero
        clk = 1'b0;
        rst = 1'b1;
        #5;
        clk = 1'b1;
        #5;
        rst = 1'b0;
        clk = 1'b0;

        bus_in = $random;
        inpr_in = $random;
        ac_in = $random;


        for (i = 0; i < 8; i = i + 1) begin
            case (i)
                0: begin
                    dr_ctrl = {1'b0, 1'b1 , 1'b0};
                    #5;
                    clk = 1'b1;
                    #5;
                    if (dr_out == bus_in && {ar_out, ac_out, ir_out, tr_out, inpr_out, outr_out} == 0 && pc_out == 16) begin
                        $display("Pass");
                    end else begin
                        $display("Fail, dr_out = %b, bus_in = %b", dr_out, bus_in);
                    end
                end
                1: begin
                    ar_ctrl = {1'b0, 1'b1 , 1'b0};
                    #5;
                    clk = 1'b1;
                    #5;
                    if (ar_out == bus_in[11:0] && {dr_out, ac_out, ir_out, tr_out, inpr_out, outr_out} == 0 && pc_out == 16) begin
                        $display("Pass");
                    end else begin
                        $display("Fail, ar_out = %b, bus_in = %b", ar_out, bus_in);
                    end
                end 
                2: begin
                    ac_ctrl = {1'b0, 1'b1 , 1'b0};
                    #5;
                    clk = 1'b1;
                    #5;
                    if (ac_out == ac_in && {dr_out, ar_out, ir_out, tr_out, inpr_out, outr_out} == 0 && pc_out == 16) begin
                        $display("Pass");
                    end else begin
                        $display("Fail, ac_out = %b, ac_in = %b", ac_out, ac_in);
                    end
                end 
                3: begin
                    pc_ctrl = {1'b0, 1'b1 , 1'b0};
                    #5;
                    clk = 1'b1;
                    #5;
                    if (pc_out == bus_in[11:0] && {dr_out, ar_out, ac_out, ir_out, tr_out, inpr_out, outr_out} == 0) begin
                        $display("Pass");
                    end else begin
                        $display("Fail, pc_out = %b, bus_in = %b", pc_out, bus_in);
                    end
                end
                4: begin
                    tr_ctrl = {1'b0, 1'b1 , 1'b0};
                    #5;
                    clk = 1'b1;
                    #5;
                    if (tr_out == bus_in && {dr_out, ar_out, ac_out, ir_out, inpr_out, outr_out} == 0 && pc_out == 16) begin
                        $display("Pass");
                    end else begin
                        $display("Fail, tr_out = %b, bus_in = %b", tr_out, bus_in);
                    end
                end 
                5: begin
                    ir_ld = 1'b1;
                    #5;
                    clk = 1'b1;
                    #5;
                    if (ir_out == bus_in && {dr_out, ar_out, ac_out, tr_out, inpr_out, outr_out} == 0 && pc_out == 16) begin
                        $display("Pass");
                    end else begin
                        $display("Fail, ir_out = %b, bus_in = %b", ir_out, bus_in);
                    end
                end 
                6: begin
                    inpr_ld = 1'b1;
                    #5;
                    clk = 1'b1;
                    #5;
                    if (inpr_out == inpr_in && {dr_out, ar_out, ac_out, ir_out, tr_out, outr_out} == 0 && pc_out == 16) begin
                        $display("Pass");
                    end else begin
                        $display("Fail, inpr_out = %b, inpr_in = %b", inpr_out, inpr_in);
                    end
                end
                7: begin
                    outr_ld = 1'b1;
                    #5;
                    clk = 1'b1;
                    #5;
                    if (outr_out == bus_in[7:0] && {dr_out, ar_out, ac_out, ir_out, tr_out, inpr_out} == 0 && pc_out == 16) begin
                        $display("Pass");
                    end else begin
                        $display("Fail, outr_out = %b, bus_in = %b, dr_out = %b, ar_out = %b, ac_out = %b, ir_out = %b, pc_out = %b, tr_out = %b, inpr_out = %b", outr_out, bus_in, dr_out, ar_out, ac_out, ir_out, pc_out, tr_out, inpr_out);
                    end
                end
            endcase

            // Reset again to reinitialize to zero before next loop
            clk = 1'b0;
            {dr_ctrl, ar_ctrl, ac_ctrl, pc_ctrl, tr_ctrl, ir_ld, inpr_ld, outr_ld} = 0;
            rst = 1'b1;
            #5;
            clk = 1'b1;
            #5;
            clk = 1'b0;
            rst = 1'b0;
        end
    end
endmodule
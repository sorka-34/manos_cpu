`timescale 1ps/1ps

module tb_flags ();
    reg rst, clk, e_in, i_in;
    reg [2:0] e_ctrl, i_ctrl, ien_ctrl ,r_ctrl, fgi_ctrl, fgo_ctrl, s_ctrl;
    wire e_out, i_out, ien_out, r_out, fgi_out, fgo_out, s_out;
    integer i;

    flags dut (.rst(rst), .clk(clk), .e_ctrl(e_ctrl), .i_ctrl(i_ctrl), .ien_ctrl(ien_ctrl), .r_ctrl(r_ctrl), .fgi_ctrl(fgi_ctrl), .fgo_ctrl(fgo_ctrl), .s_ctrl(s_ctrl), .e_in(e_in), .i_in(i_in), .e_out(e_out), .i_out(i_out), .ien_out(ien_out), .r_out(r_out), .fgi_out(fgi_out), .fgo_out(fgo_out), .s_out(s_out));

    initial begin
        $dumpfile("tb_flags.vcd");
        $dumpvars(0, tb_flags);

        // Initialize all flags to zero
        clk = 1'b0;
        rst = 1'b1;
        #5;
        clk = 1'b1;
        #5;
        rst = 1'b0;
        clk = 1'b0;

        e_in = 1'b1;
        i_in = $random;

        for (i = 0; i < 8; i = i + 1) begin
            case (i)
                0: begin
                    e_ctrl = {1'b0, 1'b1 , 1'b0, 1'b0};
                    #5;
                    clk = 1'b1;
                    #5;
                    if (e_out == e_in && {i_out, ien_out, r_out, fgi_out, fgo_out} == 0 && s_out == 1'b1) begin
                        $display("Pass");
                    end else begin
                        $display("Fail, e_out = %b, e_in = %b", e_out, e_in);
                    end
                end
                1: begin
                    i_ctrl = {1'b0, 1'b1 , 1'b0, 1'b0};
                    #5;
                    clk = 1'b1;
                    #5;
                    if (i_out == i_in && {e_out, ien_out, r_out, fgi_out, fgo_out} == 0 && s_out == 1'b1) begin
                        $display("Pass");
                    end else begin
                        $display("Fail, i_out = %b, i_in = %b", i_out, i_in);
                    end
                end 
                2: begin
                    ien_ctrl = {1'b0, 1'b0 , 1'b0, 1'b1};
                    #5;
                    clk = 1'b1;
                    #5;
                    if (ien_out == 1'b1 && {e_out, i_out, r_out, fgi_out, fgo_out} == 0 && s_out == 1'b1) begin
                        $display("Pass");
                    end else begin
                        $display("Fail, ien_out = %b", ien_out);
                    end
                end 
                3: begin
                    r_ctrl = {1'b0, 1'b0 , 1'b0, 1'b1};
                    #5;
                    clk = 1'b1;
                    #5;
                    if (r_out == 1'b1 && {e_out, i_out, ien_out, fgi_out, fgo_out} == 0 && s_out == 1'b1) begin
                        $display("Pass");
                    end else begin
                        $display("Fail, r_out = %b", r_out);
                    end
                end
                4: begin
                    fgi_ctrl = {1'b0, 1'b0 , 1'b0, 1'b1};
                    #5;
                    clk = 1'b1;
                    #5;
                    if (fgi_out == 1'b1 && {e_out, i_out, ien_out, r_out, fgo_out} == 0 && s_out == 1'b1) begin
                        $display("Pass");
                    end else begin
                        $display("Fail, fgi_out = %b", fgi_out);
                    end
                end 
                5: begin
                    fgo_ctrl = {1'b0, 1'b0 , 1'b0, 1'b1};
                    #5;
                    clk = 1'b1;
                    #5;
                    if (fgo_out == 1'b1 && {e_out, i_out, ien_out, r_out, fgi_out} == 0 && s_out == 1'b1) begin
                        $display("Pass");
                    end else begin
                        $display("Fail, fgo_out = %b", fgo_out);
                    end
                end 
                6: begin
                    s_ctrl = {1'b0, 1'b0 , 1'b0, 1'b1};
                    #5;
                    clk = 1'b1;
                    #5;
                    if (s_out == 0 && {e_out, i_out, ien_out, r_out, fgi_out, fgo_out} == 0) begin
                        $display("Pass");
                    end else begin
                        $display("Fail, s_out = %b", s_out);
                    end
                end
            endcase

            // Reset again to reinitialize to zero before next loop
            clk = 1'b0;
            {e_ctrl, i_ctrl, ien_ctrl, r_ctrl, fgi_ctrl, fgo_ctrl, s_ctrl} = 0;
            rst = 1'b1;
            #5;
            clk = 1'b1;
            #5;
            clk = 1'b0;
            rst = 1'b0;
        end
    end
endmodule
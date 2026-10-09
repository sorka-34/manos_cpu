`timescale 1ps/1ps

 module tb_cpu_flag ();
    reg rst, clk, flag_in, flag_out_prev, flag_result;
    reg [3:0] flag_ctrl;
    wire flag_out;
    integer i;

    cpu_flag dut (.rst(rst), .clk(clk), .clr(flag_ctrl[3]), .ld(flag_ctrl[2]), .set(flag_ctrl[1]), .inv(flag_ctrl[0]), .flag_in(flag_in), .flag_out(flag_out));

    initial begin
        $dumpfile("tb_cpu_flag.vcd");
        $dumpvars(0, tb_cpu_flag);

        clk = 1'b0;
        flag_in = $random;
        rst = 1'b1;
        #5;
        clk = 1'b1;
        #5;
        rst = 1'b0;
        i = 0;
        for (i = 0; i < 31; i = i + 1) begin
            clk = 1'b0;
            flag_ctrl[0] = i[0];
            flag_ctrl[1] = i[1];
            flag_ctrl[2] = i[2];
            flag_ctrl[3] = i[3];
            rst = i[4];
            flag_out_prev = flag_out;
            #5;
            clk = 1'b1;
            #5;

            casex ({rst, flag_ctrl})
                5'b00000: flag_result = flag_out_prev;
                5'b00001: flag_result = ~flag_out_prev;
                5'b0001?: flag_result = 1'b1;
                5'b001??: flag_result = flag_in;
                5'b01???: flag_result = 1'b0;
                5'b1????: flag_result = 1'b0;
            endcase

            if (flag_out == flag_result) begin
                $display("Pass");
            end else begin
                $display("Fail, rst+flag_ctrl = %b, flag in = %b, flag out = %b, flag_out_prev = %b", {rst, flag_ctrl}, flag_in, flag_out, flag_out_prev);
            end
        end

        $finish;
    end
 endmodule

`timescale 1ps/1ps

module tb_cpu_register ();
    reg rst, clk, ld, inr, clr;
    reg [15:0] data_in, result, data_out_prev;
    wire [15:0] data_out;
    integer i;

    cpu_register dut (.rst(rst), .clk(clk), .ld(ld), .inr(inr), .clr(clr), .data_in(data_in), .data_out(data_out));

    initial begin
        $dumpfile("tb_cpu_register.vcd");
        $dumpvars(0, tb_cpu_register);

        inr = 1'b0;
        ld = 1'b0;
        clr = 1'b0;
        clk = 1'b0;
        data_in = $random;
        rst = 1'b1;
        #5;
        clk = 1'b1;
        #5;
        rst = 1'b0;
        for (i = 0; i < 15; i = i + 1) begin
            clk = 1'b0;
            inr = i[0];
            ld = i[1];
            clr = i[2];
            rst = i[3];

            data_out_prev = data_out;

            #5;
            clk = 1'b1;
            #5;

            casex ({rst, clr, ld, inr})
                4'b0000: result = data_out;
                4'b0001: result = data_out_prev + 1;
                4'b001?: result = data_in;
                4'b01??: result = 16'h0000;
                4'b1???: result = 16'h0000;
            endcase

            if (data_out == result) begin
                $display("Pass");
            end else begin
                $display("Fail");
            end
        end
        $finish;
    end
endmodule
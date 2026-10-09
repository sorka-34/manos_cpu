`timescale 1ps/1ps

module tb_sequence_counter ();
    reg rst, clk, clr, inr;
    reg [3:0] result, sc_out_prev;
    wire [3:0] sc_out;
    integer i;

    sequence_counter dut (.rst(rst), .clk(clk), .clr(clr), .inr(inr), .sc_out(sc_out));

    initial begin
        $dumpfile("tb_sequence_counter.vcd");
        $dumpvars(0, tb_sequence_counter);

        clk = 1'b0;
        rst = 1'b1;
        #5;
        clk = 1'b1;
        #5;
        clk = 1'b0;

        for (i = 0; i < 8; i  = i + 1) begin
            sc_out_prev = sc_out;
            inr = i[0];
            clr = i[1];
            rst = i[2];

            #5;
            clk = 1'b1;
            #5;
            clk = 1'b0;

            casex ({rst, clr, inr})
                3'b000: result = sc_out_prev;
                3'b001: result = sc_out_prev + 1;
                3'b01?: result = 4'b0000;
                3'b1??: result = 4'b0000;
            endcase

            if (sc_out == result) begin
                $display("Pass");
            end else begin
                $display("Fail");
            end
        end

        // Check for resetting after hitting max value
        repeat (16) begin
            {rst, clr, inr} = 3'b001;
            #5;
            clk = 1'b1;
            #5;
            clk = 1'b0;
        end

        if (sc_out == 4'b0000) begin
            $display("Max reset pass");
        end else begin
            $display("Max reset fail");
        end

        $finish;
    end
endmodule
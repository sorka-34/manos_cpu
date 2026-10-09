`timescale 1ps/1ps
 module tb_cpu_bus ();
    reg S0, S1, S2;
    reg [15:0] dr_in, ac_in, ir_in, tr_in, mem_in, result;
    reg [11:0] ar_in, pc_in;
    wire [15:0] bus;
    integer i;

    cpu_bus dut (.S0(S0), .S1(S1), .S2(S2), .dr_in(dr_in), .ac_in(ac_in), .ir_in(ir_in), .tr_in(tr_in), .mem_in(mem_in), .ar_in(ar_in), .pc_in(pc_in), .bus(bus));

    initial begin
        $dumpfile("tb_cpu_bus.vcd");
        $dumpvars(0, tb_cpu_bus);

        dr_in = $random;
        ac_in = $random;
        ir_in = $random;
        tr_in = $random;
        mem_in = $random;
        ar_in = $random;
        pc_in = $random;
        #5;

        for (i = 0; i < 8; i = i + 1) begin
            S0 = i[0];
            S1 = i[1];
            S2 = i[2];
            #5;

            case ({S2, S1, S0})
                3'b000: result = 0;
                3'b001: result = {1'b0, 1'b0, 1'b0, 1'b0, ar_in};
                3'b010: result = {1'b0, 1'b0, 1'b0, 1'b0, pc_in};
                3'b011: result = dr_in;
                3'b100: result = ac_in;
                3'b101: result = ir_in;
                3'b110: result = tr_in;
                3'b111: result = mem_in;
            endcase
        
            if (bus == result) begin
                $display("Pass");
            end else begin
                $display("Fail");
            end
        end

        $finish;
    end
 endmodule
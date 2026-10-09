`timescale 1ps/1ps

module tb_logic_stage ();
    reg S0, S1, A, B;
    wire D;
    reg result;
    integer i, j;

    logic_stage dut (.S0(S0), .S1(S1), .A(A), .B(B), .D(D));

    initial begin
        $dumpfile("tb_logic_stage.vcd");
        $dumpvars(0, tb_logic_stage);

        for (i = 0; i < 4; i = i + 1) begin
            S0 = i[0];
            S1 = i[1];

            for (j = 0; j < 4; j = j + 1) begin
                A = j[0];
                B = j[1];
                #10;

                case ({S1, S0})
                    2'b00: result = A & B;
                    2'b01: result = A | B;
                    2'b10: result = A ^ B;
                    2'b11: result = ~A;
                endcase

                if (D == result) begin
                    $display("Pass");
                end else begin
                    $display("Fail, D = %b, result = %b", D, result);
                end
                
            end
        end

        $finish;
    end
endmodule
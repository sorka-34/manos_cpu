`timescale 1ps/1ps

module tb_arithmetic_stage ();
    reg S0, S1, A, B, Cin;
    wire D, Cout;
    reg[1:0] result;
    integer i, j;

    arithmetic_stage dut (.S0(S0), .S1(S1), .A(A), .B(B), .Cin(Cin), .D(D), .Cout(Cout));

    initial begin
        $dumpfile("tb_arithmetic_stage.vcd");
        $dumpvars(0, tb_arithmetic_stage);

        for (i = 0; i < 4; i = i + 1) begin
            S0 = i[0];
            S1 = i[1];

            for (j = 0; j < 8; j = j +1) begin
                A = j[0];
                B = j[1];
                Cin = j[2];
                #10;

                case ({S1, S0})
                    2'b00: result = A + B + Cin;
                    2'b01: result = A + {~B} + Cin;
                    2'b10: result = A + 1'b0 + Cin;
                    2'b11: result = A + 1'b1 + Cin;
                endcase

                if (D == result[0] && Cout == result[1]) begin
                    $display("Pass");
                end
                else begin
                    $display("Failed at S0 = %b, S1 = %b.\nA = %b, B = %b, Cin = %b,\nresult = %b", S0, S1, A, B, Cin, result);
                end
            end
        end

        $finish;
    end
endmodule
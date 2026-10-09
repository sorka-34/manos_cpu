`timescale 1ps/1ps

module tb_ALSU ();
    reg S0, S1, S2, S3, Cin, e_in, e_prev, carry_out;
    reg [7:0] inpr_in;
    reg [15:0] A, B, bus_in, result;
    wire [15:0] F;
    wire e_out;
    integer i;

    ALSU dut (.S0(S0), .S1(S1), .S2(S2), .S3(S3), .Cin(Cin), .e_in(e_in), .A(A), .B(B), .bus_in(bus_in), .inpr_in(inpr_in), .F(F), .e_out(e_out));

    initial begin
        $dumpfile("tb_ALSU.vcd");
        $dumpvars(0, tb_ALSU);

        for (i = 0; i < 32; i = i + 1) begin
            Cin = i[0];
            S0 = i[1];
            S1 = i[2];
            S2 = i[3];
            S3 = i[4];

            repeat (3) begin
                A = $random;
                B = $random;
                e_in = $random;
                bus_in = $random;
                inpr_in = $random;
                e_prev = e_in;
                #10

                casex ({S3, S2, S1, S0, Cin})
                    5'b00000: result = bus_in; 
                    5'b00001: {carry_out, result} = A + 1;
                    5'b00010: {carry_out, result} = A + B;
                    5'b00011: {carry_out, result} = A + B + 1;
                    5'b00100: {carry_out, result} = A + {~B};
                    5'b00101: {carry_out, result} = A + {~B} + 1;
                    5'b00110: {carry_out, result} = A + 16'hFFFF;  // result = A - 1 
                    5'b00111: result = {A[15:8], inpr_in};
                    5'b0100?: result = A & B;
                    5'b0101?: result = A | B;
                    5'b0110?: result = A ^ B;
                    5'b0111?: result = ~A;
                    5'b10???: begin
                        result = {e_prev, A[15:1]};
                    end
                    5'b11???: begin
                        result = {A[14:0], e_prev};                        
                    end
                endcase

                if (F == result) begin
                    if (S3 == 0 && S2 == 0 && {S1, S0, Cin} != 3'b111 && {S1, S0, Cin} != 3'b000 && e_out != carry_out) begin
                        $display("Fail, carry out mismatch. S1 = %b, S0 = %b, Cin = %b\n A = %b, B = %b\n Cout = %b, Cout_expected = %b", S1, S0, Cin, A, B, e_out, carry_out);
                    end else begin
                        $display("Pass");
                    end
                    
                end else begin
                    $display("Fail, result mismatch. A = %b, E = %b, S3 = %b, S2 = %b\n F = %b, result = %b", A, e_in, S3, S2, F, result);
                end
            end
        end
    end
endmodule
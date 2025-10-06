module mult_16x16 (isolate, sign, A, B, Y);

    parameter A_width = 16;
    parameter B_width = 16;

    input [A_width-1:0] A;
    input [B_width-1:0] B;
    input isolate;
    input sign;
    output [A_width+B_width-1:0] Y;

    assign Y = isolate ? sign ? $signed(A) * $signed(B) : A * B : 32'b0;

    specify
        specparam tpd = 1.2;
        (A, B, sign *> Y) = tpd;
    endspecify

endmodule

module Half_Adder (
    input wire A,
    input wire B,
    output wire Sum,
    output wire Carry
);
    assign Sum = A ^ B;
    assign Carry = A & B;
endmodule

module Full_Adder (
    input wire A,
    input wire B,
    input wire Cin,
    output wire Sum,
    output wire Cout
);
    assign Sum = A ^ B ^ Cin;
    assign Cout = (A & B) | (B & Cin) | (Cin & A);
endmodule

module Ripple_Carry_Adder (
    input wire [3:0] A,
    input wire [3:0] B,
    input wire Cin,
    output wire [3:0] Sum,
    output wire Cout
);
    wire C1, C2, C3;

    Full_Adder FA0 (.A(A[0]), .B(B[0]), .Cin(Cin), .Sum(Sum[0]), .Cout(C1));
    Full_Adder FA1 (.A(A[1]), .B(B[1]), .Cin(C1), .Sum(Sum[1]), .Cout(C2));
    Full_Adder FA2 (.A(A[2]), .B(B[2]), .Cin(C2), .Sum(Sum[2]), .Cout(C3));
    Full_Adder FA3 (.A(A[3]), .B(B[3]), .Cin(C3), .Sum(Sum[3]), .Cout(Cout));
endmodule


module Carry_Look_Ahead_Adder (
    input wire [3:0] A,
    input wire [3:0] B,
    input wire Cin,
    output wire [3:0] Sum,
    output wire Cout
);
    wire [3:0] P, G;
    wire [3:0] C;

    assign P = A ^ B;
    assign G = A & B;

    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C[0]);
    assign Cout = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & C[0]);

    assign Sum = P ^ C;
endmodule


module Full_Adder_tb;
    reg A;
    reg B;
    reg Cin;
    wire Sum;
    wire Cout;

    Full_Adder uut (
        .A(A), 
        .B(B), 
        .Cin(Cin), 
        .Sum(Sum), 
        .Cout(Cout)
    );

    initial begin
        // Initialize inputs
        A = 0; B = 0; Cin = 0;
        #10; A = 0; B = 1; Cin = 0;
        #10; A = 1; B = 0; Cin = 0;
        #10; A = 1; B = 1; Cin = 0;
        #10; A = 0; B = 0; Cin = 1;
        #10; A = 0; B = 1; Cin = 1;
        #10; A = 1; B = 0; Cin = 1;
        #10; A = 1; B = 1; Cin = 1;
        #10;
    end
endmodule



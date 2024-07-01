module Array_Multiplier (
    input wire [3:0] A,
    input wire [3:0] B,
    output wire [7:0] Product
);
    wire [3:0] partial0, partial1, partial2, partial3;
    wire [7:0] sum1, sum2, sum3;
    wire carry1, carry2, carry3;

    // Partial products
    assign partial0 = A & {4{B[0]}};
    assign partial1 = A & {4{B[1]}};
    assign partial2 = A & {4{B[2]}};
    assign partial3 = A & {4{B[3]}};

    // Shift partial products
    assign sum1 = {partial1, 1'b0} + {partial0, 1'b0};
    assign sum2 = {partial2, 2'b0} + sum1;
    assign sum3 = {partial3, 3'b0} + sum2;

    assign Product = sum3;

endmodule

module Booth_Multiplier (
    input wire signed [3:0] A,
    input wire signed [3:0] B,
    output reg signed [7:0] Product
);
    reg [3:0] M, Q;
    reg Q_1;
    reg [3:0] count;

    always @ (A, B) begin
        M = A;
        Q = B;
        Q_1 = 0;
        Product = 0;
        count = 4;

        while (count > 0) begin
            case ({Q[0], Q_1})
                2'b01: Product = Product + {M, 4'b0};
                2'b10: Product = Product - {M, 4'b0};
            endcase
            Q_1 = Q[0];
            Q = {Product[0], Q[3:1]};
            Product = {Product[7], Product[7:1]};
            count = count - 1;
        end
    end

endmodule


module Wallace_Tree_Multiplier (
    input wire [3:0] A,
    input wire [3:0] B,
    output wire [7:0] Product
);
    wire [15:0] partial_products;
    wire [7:0] sum_stage1, sum_stage2, sum_stage3;
    wire carry_stage1, carry_stage2, carry_stage3;

    // Partial products
    assign partial_products[0] = A[0] & B[0];
    assign partial_products[1] = A[0] & B[1];
    assign partial_products[2] = A[0] & B[2];
    assign partial_products[3] = A[0] & B[3];
    assign partial_products[4] = A[1] & B[0];
    assign partial_products[5] = A[1] & B[1];
    assign partial_products[6] = A[1] & B[2];
    assign partial_products[7] = A[1] & B[3];
    assign partial_products[8] = A[2] & B[0];
    assign partial_products[9] = A[2] & B[1];
    assign partial_products[10] = A[2] & B[2];
    assign partial_products[11] = A[2] & B[3];
    assign partial_products[12] = A[3] & B[0];
    assign partial_products[13] = A[3] & B[1];
    assign partial_products[14] = A[3] & B[2];
    assign partial_products[15] = A[3] & B[3];

    // Sum and carry stages
    assign {carry_stage1, sum_stage1} = {partial_products[3:0]} + {partial_products[7:4]};
    assign {carry_stage2, sum_stage2} = {sum_stage1, carry_stage1} + {partial_products[11:8]};
    assign {carry_stage3, sum_stage3} = {sum_stage2, carry_stage2} + {partial_products[15:12]};
    
    assign Product = sum_stage3;

endmodule


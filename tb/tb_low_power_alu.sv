`timescale 1ns/1ps

module low_power_alu_tb;

parameter WIDTH = 8;

logic enable;
logic [WIDTH-1:0] A;
logic [WIDTH-1:0] B;
logic [3:0] opcode;

logic [WIDTH-1:0] result;
logic zero;
logic carry;
logic overflow;
logic negative;

low_power_alu #(
    .WIDTH(WIDTH)
) DUT (
    .enable(enable),
    .A(A),
    .B(B),
    .opcode(opcode),
    .result(result),
    .zero(zero),
    .carry(carry),
    .overflow(overflow),
    .negative(negative)
);

task run_test;
    input [7:0] a_in;
    input [7:0] b_in;
    input [3:0] op;
begin
    A      = a_in;
    B      = b_in;
    opcode = op;

    #10;

    $display(
        "TIME=%0t A=%0d B=%0d OPCODE=%b RESULT=%0d Z=%b C=%b O=%b N=%b",
        $time,A,B,opcode,result,zero,carry,overflow,negative
    );
end
endtask

initial begin

    $dumpfile("alu.vcd");
    $dumpvars(0,low_power_alu_tb);

    enable = 1'b1;

    run_test(20,10,4'b0000);
    run_test(20,10,4'b0001);
    run_test(15,10,4'b0010);
    run_test(15,10,4'b0011);
    run_test(15,10,4'b0100);
    run_test(15,0,4'b0101);
    run_test(15,0,4'b0110);
    run_test(15,0,4'b0111);
    run_test(15,0,4'b1000);
    run_test(15,0,4'b1001);
    run_test(15,15,4'b1010);

    enable = 1'b0;
    run_test(100,50,4'b0000);

    #20;
    $finish;
end

endmodule
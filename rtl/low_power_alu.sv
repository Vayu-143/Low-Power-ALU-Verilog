module low_power_alu #(
    parameter WIDTH = 8
)(
    input  logic enable,
    input  logic [WIDTH-1:0] A,
    input  logic [WIDTH-1:0] B,
    input  logic [3:0] opcode,

    output logic [WIDTH-1:0] result,
    output logic zero,
    output logic carry,
    output logic overflow,
    output logic negative
);

logic [WIDTH-1:0] A_iso;
logic [WIDTH-1:0] B_iso;
logic [WIDTH:0]   temp;

always @(*) begin

    A_iso = enable ? A : '0;
    B_iso = enable ? B : '0;

    result   = '0;
    carry    = 1'b0;
    overflow = 1'b0;

    case(opcode)

        4'b0000: begin
            temp   = A_iso + B_iso;
            result = temp[WIDTH-1:0];
            carry  = temp[WIDTH];

            overflow =
                (~A_iso[WIDTH-1] & ~B_iso[WIDTH-1] & result[WIDTH-1]) |
                ( A_iso[WIDTH-1] &  B_iso[WIDTH-1] & ~result[WIDTH-1]);
        end

        4'b0001: begin
            temp   = A_iso - B_iso;
            result = temp[WIDTH-1:0];
            carry  = temp[WIDTH];

            overflow =
                (~A_iso[WIDTH-1] &  B_iso[WIDTH-1] & result[WIDTH-1]) |
                ( A_iso[WIDTH-1] & ~B_iso[WIDTH-1] & ~result[WIDTH-1]);
        end

        4'b0010: result = A_iso & B_iso;
        4'b0011: result = A_iso | B_iso;
        4'b0100: result = A_iso ^ B_iso;
        4'b0101: result = ~A_iso;
        4'b0110: result = A_iso << 1;
        4'b0111: result = A_iso >> 1;
        4'b1000: result = A_iso + 1'b1;
        4'b1001: result = A_iso - 1'b1;

        4'b1010: begin
            if (A_iso == B_iso)
                result = {{(WIDTH-1){1'b0}},1'b1};
            else
                result = '0;
        end

        default: result = '0;

    endcase

    zero     = (result == 0);
    negative = result[WIDTH-1];

end

endmodule
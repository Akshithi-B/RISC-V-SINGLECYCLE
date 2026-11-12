
`timescale 1ns / 1ps

module alu #(
    parameter int DATA_WIDTH = 32
)(
    input logic [DATA_WIDTH-1:0] operand_a,
    input logic [DATA_WIDTH-1:0] operand_b,
    input logic [4:0] control_out,
    output logic [DATA_WIDTH-1:0] alu_result,
    output logic zero
);

always_comb begin

    alu_result = '0;
    zero = 1'b0;

    case(control_out)

        // ADD
        5'b00000: begin
            alu_result = operand_a + operand_b;
        end

        // SUB
        5'b00001: begin
            alu_result = operand_a - operand_b;
        end

        // XOR
        5'b00010: begin
            alu_result = operand_a ^ operand_b;
        end

        // OR
        5'b00011: begin
            alu_result = operand_a | operand_b;
        end

        // AND
        5'b00100: begin
            alu_result = operand_a & operand_b;
        end

        // SLL
        5'b00101: begin
            alu_result = operand_a << operand_b[4:0];
        end

        // SRL / SRLI
        5'b00110: begin
            alu_result = operand_a >> operand_b[4:0];
        end

        // SRA / SRAI
        5'b00111: begin
            alu_result = $signed(operand_a) >>> operand_b[4:0];
        end

        // SLT (Signed)
        5'b01000: begin
            alu_result = ($signed(operand_a) < $signed(operand_b)) ?
                         {{(DATA_WIDTH-1){1'b0}}, 1'b1} : '0;
        end

        // SLTU (Unsigned)
        5'b01001: begin
            alu_result = (operand_a < operand_b) ?
                         {{(DATA_WIDTH-1){1'b0}}, 1'b1} : '0;
        end

        // BEQ
        5'b01010: begin
            zero = (operand_a == operand_b);
        end

        // BNE
        5'b01011: begin
            zero = (operand_a != operand_b);
        end

        // BLT (Signed)
        5'b01100: begin
            zero = ($signed(operand_a) < $signed(operand_b));
        end

        // BGE (Signed)
        5'b01101: begin
            zero = ($signed(operand_a) >= $signed(operand_b));
        end

        // BLTU (Unsigned)
        5'b01110: begin
            zero = (operand_a < operand_b);
        end

        // BGEU (Unsigned)
        5'b01111: begin
            zero = (operand_a >= operand_b);
        end

        default: begin
            alu_result = '0;
            zero = 1'b0;
        end

    endcase

end

endmodule

module alu #(parameter int DATA_WIDTH = 32)(
    input  logic [4:0]            alu_control,
    input  logic [DATA_WIDTH-1:0] rs1_data,
    input  logic [DATA_WIDTH-1:0] rs2_data,
    output logic [DATA_WIDTH-1:0] alu_out,
    output logic                  zero
);

always_comb begin
    case (alu_control)

        5'b00000: alu_out = rs1_data + rs2_data;                     // ADD
        5'b00001: alu_out = rs1_data - rs2_data;                     // SUB
        5'b00010: alu_out = rs1_data & rs2_data;                     // AND
        5'b00011: alu_out = rs1_data | rs2_data;                     // OR
        5'b00100: alu_out = rs1_data ^ rs2_data;                     // XOR
        5'b00101: alu_out = rs1_data << rs2_data[4:0];              // SLL
        5'b00110: alu_out = rs1_data >> rs2_data[4:0];              // SRL
        5'b00111: alu_out = $signed(rs1_data) >>> rs2_data[4:0];    // SRA

        5'b01000: alu_out =
                  ($signed(rs1_data) < $signed(rs2_data)) ? 32'd1 : 32'd0; // SLT

        5'b01001: alu_out =
                  (rs1_data < rs2_data) ? 32'd1 : 32'd0;            // SLTU

        default: alu_out = '0;

    endcase
end

assign zero = (alu_out == 0);

endmodule

module wb_stage(
    input logic [31:0] mem_out,
    input logic [31:0] alu_out,
    input logic [31:0] return_addr,
    input logic [31:0] imm_out,
    input logic [31:0] pc_signed_offset,

    input logic [1:0] memtoreg,
    input logic [6:0] opcode_out_d,

    output logic [31:0] wb_data
);

always_comb begin

    // Default value
    wb_data = alu_out;

    case (memtoreg)

        // ALU result
        2'b00: begin
            wb_data = alu_out;
        end

        // Memory data (Load)
        2'b01: begin
            wb_data = mem_out;
        end

        // Special instructions
        2'b10: begin

            case (opcode_out_d)

                // JAL
                7'b1101111: begin
                    wb_data = return_addr;
                end

                // JALR
                7'b1100111: begin
                    wb_data = return_addr;
                end

                // LUI
                7'b0110111: begin
                    wb_data = imm_out;
                end

                // AUIPC
                7'b0010111: begin
                    wb_data = pc_signed_offset;
                end

                // Other instructions
                default: begin
                    wb_data = alu_out;
                end

            endcase

        end

        // Default: ALU result
        2'b11: begin
            wb_data = alu_out;
        end

        default: begin
            wb_data = alu_out;
        end

    endcase

end

endmodule

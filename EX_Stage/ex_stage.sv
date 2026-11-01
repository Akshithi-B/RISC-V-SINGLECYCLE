module ex_stage (
    input  logic [31:0] rs1_data,
    input  logic [31:0] rs2_data,
    input  logic [31:0] imm_out,
    input  logic [31:0] address,       // current PC
    input  logic        branch,
    input  logic        alu_src,
    input  logic        fn7_5,
    input  logic        mux_inp,       // JALR
    input  logic [2:0]  fn3,
    input  logic [6:0]  imm11_5,
    input  logic [2:0]  aluop,
    input  logic [6:0]  opcode,

    output logic        and_out_ex,
    output logic [31:0] alu_out,
    output logic [31:0] pc_ex_out
);

    logic [31:0] alu_b;
    logic        zero;

    // ALU second operand selection
    assign alu_b = (alu_src) ? imm_out : rs2_data;

    // ALU
    always_comb begin
        case (aluop)
            3'b000: alu_out = rs1_data + alu_b;                     // ADD
            3'b001: alu_out = rs1_data - alu_b;                     // SUB
            3'b010: alu_out = rs1_data & alu_b;                     // AND
            3'b011: alu_out = rs1_data | alu_b;                     // OR
            3'b100: alu_out = rs1_data ^ alu_b;                     // XOR
            3'b101: alu_out = rs1_data << alu_b[4:0];              // SLL
            3'b110: alu_out = rs1_data >> alu_b[4:0];              // SRL
            3'b111: alu_out = $signed(rs1_data) >>> alu_b[4:0];    // SRA
            default: alu_out = 32'b0;
        endcase
    end

    assign zero = (alu_out == 32'b0);

    // Branch decision
    always_comb begin
        and_out_ex = 1'b0;

        if (branch) begin
            case (fn3)
                3'b000: and_out_ex = (rs1_data == rs2_data);                      // BEQ
                3'b001: and_out_ex = (rs1_data != rs2_data);                      // BNE
                3'b100: and_out_ex = ($signed(rs1_data) < $signed(rs2_data));     // BLT
                3'b101: and_out_ex = ($signed(rs1_data) >= $signed(rs2_data));    // BGE
                3'b110: and_out_ex = (rs1_data < rs2_data);                       // BLTU
                3'b111: and_out_ex = (rs1_data >= rs2_data);                      // BGEU
                default: and_out_ex = 1'b0;
            endcase
        end
    end

    // Branch/JAL/JALR target address generation
    always_comb begin
        if (mux_inp) begin
            // JALR
            pc_ex_out = (rs1_data + imm_out) & ~32'd1;
        end
        else begin
            // Branch or JAL
            pc_ex_out = address + imm_out;
        end
    end

endmodule

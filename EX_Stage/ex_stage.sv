module ex_stage(
    input logic [31:0] rs1_data,
    input logic [31:0] rs2_data,
    input logic [31:0] imm_out,
    input logic [31:0] address,

    input logic branch,
    input logic alu_src,
    input logic fn7_5,
    input logic mux_inp,

    input logic [2:0] fn3,
    input logic [6:0] imm11_5,
    input logic [2:0] aluop,
    input logic [6:0] opcode,

    output logic and_out_ex,
    output logic [31:0] alu_out,
    output logic [31:0] pc_ex_out
);

    // Internal signals
    logic [31:0] alu_operand_b;
    logic [31:0] pc_signed_offset;

    logic [4:0] alu_control_out;
    logic zero;


    // ALU Operand Selection
    always_comb begin
        if (alu_src == 1'b1)
            alu_operand_b = imm_out;
        else
            alu_operand_b = rs2_data;
    end


    // ALU Control Instantiation
    alu_control AC (
        .alu_op(aluop),
        .fn3(fn3),
        .imm11_5(imm11_5),
        .fn7_5(fn7_5),
        .control_out(alu_control_out)
    );


    // ALU Instantiation
    alu ALU (
        .operand_a(rs1_data),
        .operand_b(alu_operand_b),
        .control_out(alu_control_out),
        .alu_result(alu_out),
        .zero(zero)
    );


    // PC + Immediate Offset
    always_comb begin
        pc_signed_offset = address + imm_out;
    end


    // Branch / Jump Target Selection
    always_comb begin
        if (mux_inp == 1'b1)
            pc_ex_out = {alu_out[31:1], 1'b0};
        else
            pc_ex_out = pc_signed_offset;
    end


    // Branch / Jump Taken Logic
    always_comb begin
        and_out_ex = (branch && zero) ||
                     (opcode == 7'h6F) ||
                     (opcode == 7'h67);
    end

endmodule

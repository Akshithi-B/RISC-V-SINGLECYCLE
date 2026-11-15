`timescale 1ns / 1ps

module id_stage(
    input  logic        clk,
    input  logic        reset,
    input  logic        stall,
    input  logic [31:0] instruction,
    input  logic [31:0] wb_data,

    output logic [31:0] rs1_data,
    output logic [31:0] rs2_data,
    output logic [31:0] imm_out,

    output logic [6:0]  opcode_out_d,
    output logic [6:0]  imm11_5,
    output logic [2:0]  fn3_out_d,
    output logic        fn7_5,

    output logic [2:0]  aluop,
    output logic [1:0]  memtoreg,
    output logic        branch,
    output logic        mem_write,
    output logic        mem_read,
    output logic        alu_src,
    output logic        mux_inp
);

    logic [4:0]  rs1;
    logic [4:0]  rs2;
    logic [4:0]  rd;

    logic [11:0] imm;
    logic [19:0] imm_uj;

    logic regwrite;

    //-------------------------------------------------
    // Decoder
    //-------------------------------------------------
    decoder dec (
        .instruction(instruction),

        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),

        .opcode(opcode_out_d),
        .fn3(fn3_out_d),
        .fn7_5(fn7_5),

        .imm(imm),
        .imm_uj(imm_uj),
        .imm11_5(imm11_5)
    );

    //-------------------------------------------------
    // Main Control
    //-------------------------------------------------
    maincontrol control (
        .opcode(opcode_out_d),

        .memtoreg(memtoreg),
        .branch(branch),
        .memread(mem_read),
        .memwrite(mem_write),
        .alusrc(alu_src),
        .regwrite(regwrite),
        .aluop(aluop),
        .mux_inp(mux_inp)
    );

    //-------------------------------------------------
    // Register File
    //-------------------------------------------------
    register_file registers (
        .reset(reset),
        .clk(clk),

        .rs1_sel(rs1),
        .rs2_sel(rs2),
        .rd_sel(rd),

        .wb_data(wb_data),

        .reg_write(regwrite && !stall),

        .rs1_data(rs1_data),
        .rs2_data(rs2_data)
    );

    //-------------------------------------------------
    // Immediate Generator
    //-------------------------------------------------
    imm_generator immediate (
        .imm_input(imm),
        .fn3(fn3_out_d),
        .opcode(opcode_out_d),
        .imm_input_uj(imm_uj),
        .imm_output(imm_out)
    );

endmodule

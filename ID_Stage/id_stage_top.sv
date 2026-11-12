`timescale 1ns / 1ps

module id_stage_top(
    input  logic        clk,
    input  logic        reset,
    input  logic        stall,
    input  logic [31:0] instruction,
    input  logic [31:0] wb_data,

    output logic [31:0] rs1_data,
    output logic [31:0] rs2_data,
    output logic [31:0] imm_output,
    output logic [6:0]  opcode,
    output logic [6:0]  imm11_5,
    output logic [2:0]  fn3,
    output logic        fn7_5,
    output logic [2:0]  aluop,
    output logic [1:0]  memtoreg,
    output logic        branch,
    output logic        memwrite,
    output logic        memread,
    output logic        alusrc,
    output logic        mux_inp
);

    // internal signals (not ports)
    logic [4:0]  rs1, rs2, rd;
    logic [11:0] imm;
    logic [19:0] imm_uj;
    logic        regwrite;

    // 1. instruction decoder
    decoder dec (
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .opcode(opcode),
        .fn3(fn3),
        .fn7_5(fn7_5),
        .imm(imm),
        .imm_uj(imm_uj),
        .imm11_5(imm11_5),
        .instruction(instruction)
    );

    // 2. main control unit
    maincontrol control (
        .memtoreg(memtoreg),
        .branch(branch),
        .memread(memread),
        .memwrite(memwrite),
        .alusrc(alusrc),
        .regwrite(regwrite),
        .aluop(aluop),
        .mux_inp(mux_inp),
        .opcode(opcode),
        .fn3(fn3)
    );

    // 3. register file (no write while stalled)
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

    // 4. immediate generator
    imm_generator immediate (
        .imm_input(imm),
        .fn3(fn3),
        .opcode(opcode),
        .imm_input_uj(imm_uj),
        .imm_output(imm_output)
    );

endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.11.2026 22:28:37
// Design Name: 
// Module Name: single_cycle_riscv
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module single_cycle_riscv(
    input  logic        clk,
    input  logic        reset,
    input  logic        stall,
    input  logic [31:0] instruction,
    input  logic [31:0] mem_out,

    output logic [31:0] rs2_data,
    output logic [31:0] alu_out,
    output logic        mem_write,
    output logic        mem_read,
    output logic [2:0]  fn3,
    output logic [6:0]  opcode,
    output logic [31:0] address
);

    // Internal signals

    logic [31:0] rs1_data;
    logic [31:0] imm_out;
    logic [31:0] wb_data;

    logic [31:0] return_addr;
    logic [31:0] pc_ex_out;

    logic [6:0] imm11_5;
    logic fn7_5;

    logic [2:0] aluop;
    logic [1:0] memtoreg;

    logic branch;
    logic alu_src;
    logic mux_inp;

    logic and_out_ex;
    // IF STAGE
    if_stage IF (
        .clk(clk),
        .reset(reset),
        .stall(stall),
        .and_out(and_out_ex),
        .PC_so(pc_ex_out),
        .address(address),
        .PC_new(return_addr)
    );


    // ID STAGE 
    id_stage_top ID (
        .clk(clk),
        .reset(reset),
        .stall(stall),
        .instruction(instruction),
        .wb_data(wb_data),

        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .imm_output(imm_out),

        .opcode(opcode),
        .imm11_5(imm11_5),
        .fn3(fn3),
        .fn7_5(fn7_5),

        .aluop(aluop),
        .memtoreg(memtoreg),
        .branch(branch),
        .memwrite(mem_write),
        .memread(mem_read),
        .alusrc(alu_src),
        .mux_inp(mux_inp)
    );


    // EX STAGE
    ex_stage EX (
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .imm_out(imm_out),
        .address(address),

        .branch(branch),
        .alu_src(alu_src),
        .fn7_5(fn7_5),
        .mux_inp(mux_inp),

        .fn3(fn3),
        .imm11_5(imm11_5),
        .aluop(aluop),
        .opcode(opcode),

        .and_out_ex(and_out_ex),
        .alu_out(alu_out),
        .pc_ex_out(pc_ex_out)
    );

    // WB STAGE

    wb_stage WB (
        .mem_out(mem_out),
        .alu_out(alu_out),
        .return_addr(return_addr),
        .imm_out(imm_out),
        .pc_signed_offset(pc_ex_out),

        .memtoreg(memtoreg),
        .opcode_out_d(opcode),

        .wb_data(wb_data)
    );

endmodule


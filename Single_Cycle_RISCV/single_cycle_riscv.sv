module single_cycle_riscv (

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

    // IF-Wires connections
    logic        and_out_ex;
    logic [31:0] pc_link;
    logic [31:0] pc_target;
    // ID- connections
    logic [31:0] rs1_data;
    logic [31:0] imm_out;
    logic [31:0] wb_data;
    logic [4:0]  rs1;
    logic [4:0]  rs2;
    logic [4:0]  rd;
    logic branch;
    logic alu_src;
    logic reg_write;
    logic mux_inp;
    logic [1:0]  memtoreg;
    logic [2:0]  aluop;
    logic [6:0]  imm11_5;
    // EX-Wires connection
    logic [31:0] pc_ex_out;

// instantiation of the modules 

    // IF Stage
    if_stage IF_STAGE (

        .clk              (clk),
        .reset            (reset),
        .stall            (stall),

        .and_out          (and_out_ex),
        .pc_signed_offset (pc_target),

        .pc_new           (pc_link),
        .address          (address)
    );

   
    // ID Stage
    id_stage ID_STAGE (

        .clk  (clk),
        .reset  (reset),
        .instruction(instruction),
        .wb_data    (wb_data),
        .rs1_data   (rs1_data),
        .rs2_data   (rs2_data),
        .rs1  (rs1),
        .rs2  (rs2),
        .rd  (rd),
        .imm_out  (imm_out),
        .branch  (branch),
        .alu_src  (alu_src),
        .reg_write  (reg_write),
        .mem_write  (mem_write),
        .mem_read  (mem_read),
        .memtoreg  (memtoreg),
        .aluop      (aluop),
        .mux_inp    (mux_inp),
        .fn3        (fn3),
        .opcode     (opcode),
        .imm11_5    (imm11_5)
    );

    
    // EX Stage
  
    ex_stage EX_STAGE (
        .rs1_data  (rs1_data),
        .rs2_data  (rs2_data),
        .imm_out (imm_out),
        .address  (address),
        .branch   (branch),
        .alu_src  (alu_src),
        .mux_inp (mux_inp),
        .fn3  (fn3),
        .aluop  (aluop),
        .opcode (opcode),
        .imm11_5  (imm11_5),
        .and_out_ex (and_out_ex),
        .alu_out  (alu_out),
        .pc_ex_out (pc_ex_out)
    );

  
    // Branch/Jump 
    assign pc_target = pc_ex_out;

    // WB Stage
    WB_Stage WB_STAGE (

        .mem_out (mem_out),
        .alu_out  (alu_out),
        .return_addr  (pc_link),
        .imm_out  (imm_out),
        .pc_signed_offset (pc_ex_out),
        .memtoreg (memtoreg),
        .opcode_out_d  (opcode),
        .wb_data  (wb_data)
    );

endmodule

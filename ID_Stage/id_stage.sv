
module id_stage_top(

    // Inputs
    input  logic        clk,
    input  logic        reset,
    input  logic [31:0] instruction,

    // Write-back interface
    input  logic [31:0] wb_data,
    input  logic        reg_write,

    // Register file outputs
    output logic [31:0] rs1_data,
    output logic [31:0] rs2_data,

    // Immediate generator output
    output logic [31:0] imm_output,

    // Decoded instruction fields
    output logic [4:0]  rs1,
    output logic [4:0]  rs2,
    output logic [4:0]  rd,
    output logic [6:0]  opcode,
    output logic [2:0]  fn3,
    output logic        fn7_5,
    output logic [11:0] imm,
    output logic [19:0] imm_uj,
    output logic [6:0]  imm11_5,

    // Control signals
    output logic [1:0]  memtoreg,
    output logic        branch,
    output logic        memread,
    output logic        memwrite,
    output logic        alusrc,
    output logic        regwrite,
    output logic [2:0]  aluop,
    output logic        mux_inp
);

    //-------------------------------------------------
    // Instruction Decoder
    //-------------------------------------------------
    id_stage decoder (
        .rs1        (rs1),
        .rs2        (rs2),
        .rd         (rd),
        .opcode     (opcode),
        .fn3        (fn3),
        .fn7_5      (fn7_5),
        .imm        (imm),
        .imm_uj     (imm_uj),
        .imm11_5    (imm11_5),
        .instruction(instruction)
    );

    //-------------------------------------------------
    // Main Control Unit
    //-------------------------------------------------
    main_control control (
        .opcode     (opcode),
        .memtoreg   (memtoreg),
        .branch     (branch),
        .memread    (memread),
        .memwrite   (memwrite),
        .alusrc     (alusrc),
        .regwrite   (regwrite),
        .aluop      (aluop),
        .mux_inp    (mux_inp)
    );

    //-------------------------------------------------
    // Register File
    //-------------------------------------------------
    register_file registers (
        .clk        (clk),
        .reset      (reset),
        .rs1_sel    (rs1),
        .rs2_sel    (rs2),
        .rd_sel     (rd),
        .wb_data    (wb_data),
        .reg_write  (reg_write),
        .rs1_data   (rs1_data),
        .rs2_data   (rs2_data)
    );

    //-------------------------------------------------
    // Immediate Generator
    //-------------------------------------------------
    imm_generator immediate (
        .imm_input      (imm),
        .imm_input_uj   (imm_uj),
        .opcode         (opcode),
        .fn3            (fn3),
        .imm_output     (imm_output)
    );
endmodule


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

    // Internal signals
    logic [4:0] rs1;
    logic [4:0] rs2;
    logic [4:0] rd;

    logic       reg_write;

    //--------------------------------------------------
    // Decoder
    //--------------------------------------------------
    decoder decoder_inst(
        .instruction (instruction),

        .rs1         (rs1),
        .rs2         (rs2),
        .rd          (rd),

        .opcode      (opcode_out_d),
        .funct3      (fn3_out_d),
        .funct7_bit5 (fn7_5),
        .imm11_5     (imm11_5)
    );

    //--------------------------------------------------
    // Immediate Generator
    //--------------------------------------------------
    imm_generator imm_gen_inst(
        .instruction (instruction),
        .imm_out     (imm_out)
    );

    //--------------------------------------------------
    // Main Control
    //--------------------------------------------------
    main_control main_control_inst(
        .opcode      (opcode_out_d),

        .branch      (branch),
        .memtoreg    (memtoreg),
        .aluop       (aluop),
        .mem_write   (mem_write),
        .alu_src     (alu_src),
        .mem_read    (mem_read),
        .mux_inp     (mux_inp),
        .reg_write   (reg_write)
    );

    //--------------------------------------------------
    // Register File
    //--------------------------------------------------
    register_file register_file_inst(
        .clk         (clk),
        .reset       (reset),

        .rs1         (rs1),
        .rs2         (rs2),
        .rd          (rd),

        .write_data  (wb_data),

        // gated write enable
        .reg_write   (reg_write && !stall),

        .rs1_data    (rs1_data),
        .rs2_data    (rs2_data)
    );

endmodule

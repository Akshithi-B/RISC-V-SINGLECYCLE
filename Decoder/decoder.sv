module id_stage(rs1,rs2,rd,opcode,fn3,fn7_5,imm,imm_uj,imm11_5,instruction);
input logic [31:0] instruction;
output logic [4:0] rs1,rs2,rd;
output logic[6:0] opcode;
output logic [2:0] fn3;
output logic  fn7_5;
output logic [11:0] imm;
output logic [19:0] imm_uj;
output logic [11:4] imm11_5;

always_comb begin
    rd       = 5'd0;
    fn3      = 3'd0;
    fn7_5    = 1'b0;
    rs1      = 5'd0;
    rs2      = 5'd0;
    imm      = 12'd0;
    imm_uj   = 20'd0;
    imm11_5  = 7'd0;

    opcode = 7'b0110011; // Hardcoded R-type

    rd     = instruction[11:7];
    fn3    = instruction[14:12];
    rs1    = instruction[19:15];
    rs2    = instruction[24:20];
    fn7_5  = instruction[30];
end

endmodule

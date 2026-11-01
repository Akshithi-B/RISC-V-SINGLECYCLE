module imm_generator(
    imm_input, fn3, opcode, imm_input_uj, imm_output
);

input logic [11:0] imm_input;
input logic [2:0]  fn3;
input logic [6:0]  opcode;
input logic [19:0] imm_input_uj;
output logic [31:0] imm_output;

always_comb begin
    imm_output = 32'b0;

    if (opcode == 7'b0110011) begin // R-type
        imm_output = 32'b0;
    end
    else if (opcode == 7'b0010011) begin // I-type ALU
        imm_output = {{20{imm_input[11]}}, imm_input};
    end
    else if (opcode == 7'b0000011) begin // Load
        imm_output = {{20{imm_input[11]}}, imm_input};
    end
    else if (opcode == 7'b0100011) begin // Store
        imm_output = {{20{imm_input[11]}}, imm_input};
    end
    else if (opcode == 7'b1100011) begin // Branch
        imm_output = {{19{imm_input[11]}},
                      imm_input[11], imm_input[0],
                      imm_input[10:5], imm_input[4:1], 1'b0};
    end
    else if (opcode == 7'b0110111) begin // LUI
        imm_output = {imm_input_uj, 12'b0};
    end
    else if (opcode == 7'b0010111) begin // AUIPC
        imm_output = {imm_input_uj, 12'b0};
    end
    else if (opcode == 7'b1101111) begin // JAL
        imm_output = {{11{imm_input_uj[19]}},
                      imm_input_uj[19], imm_input_uj[7:0],
                      imm_input_uj[8], imm_input_uj[18:9], 1'b0};
    end
    else if (opcode == 7'b1100111) begin // JALR
        imm_output = {{20{imm_input[11]}}, imm_input};
    end
end
endmodule

module alu_control(
    input logic [2:0] alu_op,
    input logic [2:0] fn3,
    input logic fn7_5,
    input logic [6:0] imm11_5,
    output string alu_operations,
    output logic [4:0] control_out
);

always_comb begin

    alu_operations = "INVALID";
    control_out = 5'b00000;

    // R-Type
    if (alu_op == 3'b000) begin

        if (fn3 == 3'b000) begin
            if (fn7_5 == 1'b0) begin
                alu_operations = "ADD";
                control_out = 5'b00000;
            end
            else if (fn7_5 == 1'b1) begin
                alu_operations = "SUB";
                control_out = 5'b00001;
            end
        end

        else if (fn3 == 3'b001) begin
            alu_operations = "SLL";
            control_out = 5'b00101;
        end

        else if (fn3 == 3'b010) begin
            alu_operations = "SLT";
            control_out = 5'b01000;
        end

        else if (fn3 == 3'b011) begin
            alu_operations = "SLTU";
            control_out = 5'b01001;
        end

        else if (fn3 == 3'b100) begin
            alu_operations = "XOR";
            control_out = 5'b00010;
        end

        else if (fn3 == 3'b101) begin
            if (fn7_5 == 1'b0) begin
                alu_operations = "SRL";
                control_out = 5'b00110;
            end
            else if (fn7_5 == 1'b1) begin
                alu_operations = "SRA";
                control_out = 5'b00111;
            end
        end

        else if (fn3 == 3'b110) begin
            alu_operations = "OR";
            control_out = 5'b00011;
        end

        else if (fn3 == 3'b111) begin
            alu_operations = "AND";
            control_out = 5'b00100;
        end

    end

    // I-Type ALU
    else if (alu_op == 3'b001) begin

        if (fn3 == 3'b101) begin
            if (imm11_5 == 7'b0000000) begin
                alu_operations = "SRLI";
                control_out = 5'b00110;
            end
            else if (imm11_5 == 7'b0100000) begin
                alu_operations = "SRAI";
                control_out = 5'b00111;
            end
        end

    end

    // Load / Store
    else if (alu_op == 3'b010 || alu_op == 3'b011) begin
        alu_operations = "ADD address";
        control_out = 5'b00000;
    end

    // Branch
    else if (alu_op == 3'b100) begin

        if (fn3 == 3'b000) begin
            alu_operations = "BEQ";
            control_out = 5'b01010;
        end

        else if (fn3 == 3'b001) begin
            alu_operations = "BNE";
            control_out = 5'b01011;
        end

        else if (fn3 == 3'b100) begin
            alu_operations = "BLT";
            control_out = 5'b01100;
        end

        else if (fn3 == 3'b101) begin
            alu_operations = "BGE";
            control_out = 5'b01101;
        end

        else if (fn3 == 3'b110) begin
            alu_operations = "BLTU";
            control_out = 5'b01110;
        end

        else if (fn3 == 3'b111) begin
            alu_operations = "BGEU";
            control_out = 5'b01111;
        end

    end

    // JAL / LUI / AUIPC
    else if (alu_op == 3'b110) begin
        alu_operations = "ADD path";
        control_out = 5'b00000;
    end

end

endmodule

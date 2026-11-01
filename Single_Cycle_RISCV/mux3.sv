module mux3 (
    input  logic [31:0] d0,
    input  logic [31:0] d1,
    input  logic [31:0] d2,
    input  logic [1:0]  s,
    output logic [31:0] y
);

    always_comb begin
        case(s)
            2'b00: y = d0;
            2'b01: y = d1;
            2'b10: y = d2;
            default: y = 32'b0;
        endcase
    end

endmodule

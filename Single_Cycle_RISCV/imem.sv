module imem (
    input  logic [31:0] addr,
    output logic [31:0] instr
);

    logic [31:0] memory [0:255];

    assign instr = memory[addr[31:2]];

endmodule

module register_file(reset,clk,rs1_sel,rs2_sel,rd_sel,wb_data,reg_write,rs1_data,rs2_data);
input logic reset,clk;
input logic [4:0] rs1_sel,rs2_sel,rd_sel;
input logic [31:0] wb_data;
input logic reg_write;
output logic [31:0] rs1_data,rs2_data;
logic[31:0] register [31:0];
//read logic
always_comb begin
rs1_data=(rs1_sel==5'b0)?32'b0: register[rs1_data];
rs2_data=(rs2_sel==5'b0)?32'b0: register[rs2_data];
end
//write logic
always_ff@(posedge clk or posedge reset) begin
if(reset) begin
register <= ' {default: 0};
end else begin
if((rd_sel !=0) & reg_write)
register[rd_sel] <= wb_data;
end
end
endmodule

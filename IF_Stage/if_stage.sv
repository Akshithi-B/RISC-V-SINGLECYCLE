module if_stage(clk,reset,stall,and_out,PC_so,address,PC_new);
input logic clk, reset,stall, and_out;
input logic [31:0] PC_so;
output logic [31:0] address,PC_new;
logic [31:0] PC_next;
assign PC_new=address+4;
always_comb 
begin
if(and_out)
PC_next=PC_so;
else
PC_next=PC_new;
end
always_ff@(posedge clk or posedge reset)
begin
if(reset)
address<= 32'h8000_0000;
else if (!stall)
address<=PC_next;
end
endmodule

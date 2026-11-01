module maincontrol( memtoreg,branch,memread,memwrite,alusrc,regwrite,aluop, mux_inp,opcode);
output logic [1:0] memtoreg;
output logic branch;
output logic memread;
output logic memwrite;
output logic alusrc;
output logic regwrite;
output logic [2:0] aluop;
output logic mux_inp;
input logic [6:0] opcode;
always_comb begin
if (opcode==7'b0110011) begin //R type
memtoreg=2'b00;
branch=0;
memread=0;
memwrite=0;
alusrc=0;
regwrite=0;
aluop=3'b000;
mux_inp=0;
end
else if(opcode==7'b0010011) begin //I type
memtoreg=2'b00;
branch=0;
memread=0;
memwrite=0;
alusrc=1;
regwrite=1;
aluop=3'b001;
mux_inp=0;
end

else if(opcode==7'b0000011) begin //Load
memtoreg=2'b01;
branch=0;
memread=1;
memwrite=0;
alusrc=1;
regwrite=1;
aluop=3'b010;
mux_inp=0;
end

else if(opcode==7'b0100011) begin //Store
memtoreg=2'b11;
branch=0;
memread=0;
memwrite=1;
alusrc=1;
regwrite=0;
aluop=3'b011;
mux_inp=0;
end

else if(opcode==7'b1100011) begin //Branch
memtoreg=2'b00;
branch=1;
memread=0;
memwrite=0;
alusrc=0;
regwrite=0;
aluop=3'b100;
mux_inp=0;
end

else if(opcode==7'b1101111) begin //JAL
memtoreg=2'b10;
branch=0;
memread=0;
memwrite=0;
alusrc=1;
regwrite=1;
aluop=3'b110;
mux_inp=0;
end

else if(opcode==7'b1100111) begin //JALR
memtoreg=2'b10;
branch=0;
memread=0;
memwrite=0;
alusrc=1;
regwrite=1;
aluop=3'b001;
mux_inp=1;
end

else if(opcode==7'b0110111) begin //lui
memtoreg=2'b10;
branch=0;
memread=0;
memwrite=0;
alusrc=1;
regwrite=1;
aluop=3'b110;
mux_inp=0;
end

else if(opcode==7'b0010111) begin //auipc
memtoreg=2'b10;
branch=0;
memread=0;
memwrite=0;
alusrc=1;
regwrite=1;
aluop=3'b000;
mux_inp=0;
end
end
endmodule

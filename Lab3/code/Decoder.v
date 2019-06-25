module Decoder( instr_op_i, funct_i, RegWrite_o,	ALUOp_o, ALUSrc_o, RegDst_o , MemWrite_o, MemRead_o, MemtoReg_o, Branch_o, BranchType_o, Jump_o);
     
//I/O ports
input	[6-1:0] 	instr_op_i;
input	[6-1:0]		funct_i;

output			RegWrite_o;
output	[3-1:0] 	ALUOp_o;
output			ALUSrc_o;
output			RegDst_o;

//Lab3
output MemWrite_o;
output MemRead_o;
output MemtoReg_o;
output Branch_o;
output BranchType_o;
output Jump_o;
 
//Internal Signals
wire	[3-1:0] 	ALUOp_o;
wire			ALUSrc_o;
wire			RegWrite_o;
wire	[2-1:0]		RegDst_o;

wire MemWrite_o;
wire MemRead_o;
wire [2-1:0] MemtoReg_o;
wire Branch_o;
wire BranchType_o;
wire [2-1:0] Jump_o;  

//Main function
assign RegDst_o = (instr_op_i == 6'b111111) ? 1 :		//R-type
			(instr_op_i == 6'b100111) ? 2 :		//Jal
			(instr_op_i == 6'b110111) ? 0 : 0;	//I-type

assign RegWrite_o = (instr_op_i == 6'b100011) ? 0 :		//sw
					(instr_op_i == 6'b100010) ? 0 :
					(instr_op_i == 6'b111011) ? 0 :		//beq
					({instr_op_i, funct_i} == 12'b111111001000) ? 0:	//Jr
					(instr_op_i == 6'b100101) ? 0 : 1;	//bne -- other instr in given table need to write

assign ALUSrc_o = (instr_op_i == 6'b111111) ? 0 :		//R-type
			(instr_op_i == 6'b111011) ? 0 :		//beq
			(instr_op_i == 6'b100101) ? 0 :		//bne
			(instr_op_i == 6'b110111) ? 1 : 1;	//I-type

assign ALUOp_o = (instr_op_i == 6'b111111) ? 3'b001 :			//R-type
			(instr_op_i == 6'b100001) ? 3'b000 :	//lw
			(instr_op_i == 6'b100011) ? 3'b000 :	//sw
			(instr_op_i == 6'b111011) ? 3'b100 : 		//beq
			(instr_op_i == 6'b100101) ? 3'b110 :			//bne
			(instr_op_i == 6'b110111) ? 3'b010 : 3'b011;	//ADDI : LUI
			
assign MemWrite_o = (instr_op_i == 6'b100001) ? 0 :
					(instr_op_i == 6'b100011) ? 1 : 0;

assign MemRead_o = (instr_op_i == 6'b100001) ? 1 :
					(instr_op_i == 6'b100011) ? 0 : 0; 

assign MemtoReg_o = (instr_op_i == 6'b100001) ? 1 :		//lw
					(instr_op_i == 6'b100111) ? 2 :		//Jal
					(instr_op_i == 6'b100011) ? 0 : 0;	//else
					
assign Branch_o = (instr_op_i == 6'b111011) ? 1 : 		//beq
					(instr_op_i == 6'b100101) ? 1 : 0;	//bne
					
assign BranchType_o = (instr_op_i == 6'b111011) ? 0 : 		//beq
					(instr_op_i == 6'b100101) ? 1 : 0;	//bne

assign Jump_o = (instr_op_i == 6'b100010) ? 1 :			//J
				({instr_op_i, funct_i} == 12'b111111001000) ? 2:	//Jr
				(instr_op_i == 6'b100111) ? 1 : 0; 		//Jal

endmodule

/*modify aluop from pdf
rtype 010	001
addi 100	010
lui 101		011
lw sw 000	000
beq 001		100
bne 110		110
jump x*/
   
module Decoder( instr_op_i, RegWrite_o,	ALUOp_o, ALUSrc_o, RegDst_o );
     
//I/O ports
input	[6-1:0] 	instr_op_i;

output			RegWrite_o;
output	[3-1:0] 	ALUOp_o;
output			ALUSrc_o;
output			RegDst_o;
 
//Internal Signals
wire	[3-1:0] 	ALUOp_o;
wire			ALUSrc_o;
wire			RegWrite_o;
wire			RegDst_o;

//Main function
assign RegDst_o = (instr_op_i == 6'b111111) ? 1 :		//R-type
			(instr_op_i == 6'b110111) ? 0 : 0;	//I-type

assign RegWrite_o = 1;	//All instr in given table need to write

assign ALUSrc_o = (instr_op_i == 6'b111111) ? 0 :		//R-type
			(instr_op_i == 6'b110111) ? 1 : 1;	//I-type

assign ALUOp_o = (instr_op_i == 6'b111111) ? 3'b001 :			//R-type
			(instr_op_i == 6'b110111) ? 3'b010 : 3'b011;	//ADDI : LUI

endmodule
   
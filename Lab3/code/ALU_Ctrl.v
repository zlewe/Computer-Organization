module ALU_Ctrl( funct_i, ALUOp_i, ALU_operation_o, FURslt_o, ShiftV_o);

//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALU_operation_o;  
output     [2-1:0] FURslt_o;
output		   ShiftV_o;
     
//Internal Signals
wire		[4-1:0] ALU_operation_o;
wire		[2-1:0] FURslt_o;
wire			ShiftV_o;	

//Main function
/*your code here*/
assign ALU_operation_o = ({ALUOp_i,funct_i} == 9'b001_010010 || ALUOp_i == 3'b010) ? 2 : 	//add addi
				({ALUOp_i,funct_i} == 9'b001_010000) ? 6 : 		//sub
				({ALUOp_i,funct_i} == 9'b001_010100) ? 0 : 		//and
				({ALUOp_i,funct_i} == 9'b001_010110) ? 1 : 		//or
				({ALUOp_i,funct_i} == 9'b001_010101) ? 12 : 		//nor
				({ALUOp_i,funct_i} == 9'b001_100000) ? 7 : 		//slt
				({ALUOp_i,funct_i} == 9'b001_000000) ? 1 : 		//sll
				({ALUOp_i,funct_i} == 9'b001_000010) ? 0 :		//srl		
				({ALUOp_i,funct_i} == 9'b001_000110) ? 1 : 		//sllv
				({ALUOp_i,funct_i} == 9'b001_000100) ? 0 :		//srlv
				(ALUOp_i == 3'b100) ? 6 :						//beq
				(ALUOp_i == 3'b110) ? 6 :						//bne
				(ALUOp_i == 3'b000) ? 2 : 0;					//lw sw 

assign FURslt_o = ({ALUOp_i,funct_i} == 9'b010_110000) ? 2 : 		//lui
			({ALUOp_i,funct_i} == 9'b001_000000) ? 1 : 	//sll
			({ALUOp_i,funct_i} == 9'b001_000010) ? 1 :	//srl 
			({ALUOp_i,funct_i} == 9'b001_000110) ? 1 :  //sllv
			({ALUOp_i,funct_i} == 9'b001_000100) ? 1 : 0;	//srlv //else(lwsw)

assign ShiftV_o = ({ALUOp_i,funct_i} == 9'b001_000110) ? 1 : 		//SLLV
			({ALUOp_i,funct_i} == 9'b001_000100) ? 1 : 0; 	//SRLV	

endmodule

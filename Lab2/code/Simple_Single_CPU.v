module Simple_Single_CPU( clk_i, rst_n );

//I/O port
input         clk_i;
input         rst_n;

//Internal Signles
wire [32-1:0] pc_from_add, pc_to_ins, writeData, instr, readData1, readData2, instr_ext, instr_ze, alu_mux, ALU_result, shifter_result;
wire RegDst, RegWrite, ALUSrc, shvamt;
wire [5-1:0] instr_to_wr, toShifter; 
wire [4-1:0] ALU_operation;
wire [3-1:0] ALUOp;
wire [2-1:0] FURslt;

//modules
Program_Counter PC(
        .clk_i(clk_i),      
	    .rst_n(rst_n),     
	    .pc_in_i(pc_from_add) ,   
	    .pc_out_o(pc_to_ins) 
	    );
	
Adder Adder1(
        .src1_i(pc_to_ins),     
	    .src2_i(32'd4),
	    .sum_o(pc_from_add)    
	    );
	
Instr_Memory IM(
        .pc_addr_i(pc_to_ins),  
	    .instr_o(instr)    
	    );

Mux2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(instr[20:16]),
        .data1_i(instr[15:11]),
        .select_i(RegDst),
        .data_o(instr_to_wr)
        );	
		
Reg_File RF(
        .clk_i(clk_i),      
	    .rst_n(rst_n) ,     
        .RSaddr_i(instr[25:21]) ,  
        .RTaddr_i(instr[20:16]) ,  
        .RDaddr_i(instr_to_wr) ,  
        .RDdata_i(writeData)  , 
        .RegWrite_i(RegWrite),
        .RSdata_o(readData1) ,  
        .RTdata_o(readData2)   
        );
	
Decoder Decoder(
        .instr_op_i(instr[31:26]), 
	    .RegWrite_o(RegWrite), 
	    .ALUOp_o(ALUOp),   
	    .ALUSrc_o(ALUSrc),   
	    .RegDst_o(RegDst)   
		);

ALU_Ctrl AC(
        .funct_i(instr[5:0]),   
        .ALUOp_i(ALUOp),   
        .ALU_operation_o(ALU_operation),
	.FURslt_o(FURslt),
	.ShiftV_o(shvamt)
        );
	
Sign_Extend SE(
        .data_i(instr[15:0]),
        .data_o(instr_ext)
        );

Zero_Filled ZF(
        .data_i(instr[15:0]),
        .data_o(instr_ze)
        );
		
Mux2to1 #(.size(32)) ALU_src2Src(
        .data0_i(readData2),
        .data1_i(instr_ext),
        .select_i(ALUSrc),
        .data_o(alu_mux)
        );	
		
ALU ALU(
		.A(readData1),
	    .B(alu_mux),
	    .ALUctl(ALU_operation),
		.ALUOut(ALU_result),
		.Zero()
	    );
		
Shifter shifter( 
		.result(shifter_result), 
		.leftRight(ALU_operation[0]),
		.shamt(toShifter),
		.sftSrc(alu_mux) 
		);
		
Mux3to1 #(.size(32)) RDdata_Source(
        .data0_i(ALU_result),
        .data1_i(shifter_result),
		.data2_i(instr_ze),
        .select_i(FURslt),
        .data_o(writeData)
        );	

Mux2to1 #(.size(5)) shiftvariable(
		.data0_i(instr[10:6]),
		.data1_i(readData1[4:0]),
		.select_i(shvamt),
		.data_o(toShifter)
		);		

endmodule




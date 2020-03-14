`include "instruction_def.v"
`include "ctrl_encode_def.v"

module SingalManager(jump, RegDst, Branch, MemR, Mem2R, MemW, RegW, Alusrc, ExtOp, Aluctrl, OpCode, funct);
	
	input [5:0]		OpCode;				//指令操作码字段
	input [5:0]		funct;				//指令功能字段

	output jump;						//指令跳转
	output RegDst;						
	output Branch;						//分支
	output MemR;						//读存储器
	output Mem2R;						//数据存储器到寄存器堆
	output MemW;						//写数据存储器
	output RegW;						//寄存器堆写入数据
	output Alusrc;						//运算器操作数选择
	output reg[1:0] ExtOp;				//位扩展/符号扩展选择
	output reg[4:0] Aluctrl;			//Alu运算选择
	
	reg [7:0] out;

	assign jump = out[7];
	assign RegDst = out[6];
	assign Branch = out[5];
	assign MemR = out[4];
	assign Mem2R = out[3];
	assign MemW = out[2];
	assign RegW = out[1];
	assign Alusrc = out[0];

	always@(OpCode or funct)
	begin

		case (OpCode)
			`INSTR_RTYPE_OP : begin
				case (funct)
					`INSTR_ADDU_FUNCT: begin // addu
						out = 8'b00000010;
						ExtOp = `EXT_ZERO;
						Aluctrl = `ALUOp_ADDU;
					end
					`INSTR_ADD_FUNCT: begin // add
						out = 8'b00000010;
						ExtOp = `EXT_ZERO;
						Aluctrl = `ALUOp_ADD;
					end
					`INSTR_SUBU_FUNCT: begin // subu
						out = 8'b00000010;
						ExtOp = `EXT_ZERO;
						Aluctrl = `ALUOp_SUBU;
					end
					`INSTR_SUB_FUNCT: begin // sub
						out = 8'b00000010;
						ExtOp = `EXT_ZERO;
						Aluctrl = `ALUOp_SUB;
					end
					default: begin
						out = 8'b00000000;
						ExtOp = `EXT_ZERO;
						Aluctrl = `ALUOp_NOP;
					end
				endcase
			end
			`INSTR_ORI_OP: begin // ori
				out = 8'b01000011;
				ExtOp = `EXT_ZERO;
				Aluctrl = `ALUOp_OR;
			end
			`INSTR_SW_OP: begin // sw
				out = 6'b01000101;
				ExtOp = `EXT_SIGNED;
				Aluctrl = `ALUOp_ADD;
			end
			`INSTR_LW_OP: begin // lw
				out = 8'b01011011;
				ExtOp = `ALUOp_ADDU;
				Aluctrl = `ALUOp_ADD;
			end
			`INSTR_BEQ_OP: begin // beq
				out = 8'b00100000;
				ExtOp = `EXT_SIGNED;
				Aluctrl = `ALUOp_SUB;
			end
			`INSTR_LUI_OP: begin // lui
				out = 8'b01000011;
				ExtOp = `EXT_HIGHPOS;
				Aluctrl = `ALUOp_OR;
			end
			default: begin
				out = 8'b00000000;
				ExtOp = `EXT_ZERO;
				Aluctrl = `ALUOp_NOP;
			end
		endcase


	end

endmodule
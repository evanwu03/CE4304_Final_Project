
// Date: May 4th, 2025: 
// Author: Evan Wu 

/* Instruction Decoder */
// Parses fields from 18-bit instructions which are used to 
// generate appropriate signals from control unit 

// Inputs:
//   i_opcode   : 4-bit opcode from instruction [17:14]
//   i_rd       : 2-bit destination register field (not used by decoder)
//
// Outputs:
//   o_pc_src     : 1 if PC should jump/branch, 0 to proceed sequentially
//   o_memToReg   : 1 if writing memory output to reg, 0 if ALU result
//   o_memWrite   : 1 if performing memory store operation
//   o_memRead    : 1 if performing memory load operation
//   o_regWrite   : 1 to enable writing to register file
//   o_alu_src    : 1 to use immediate as second ALU operand, 0 to use rs2
//   o_regSrc     : 1 to ignore rs2 (for I/J types), 0 to use rs2 (R-types)
//   o_alu_op     : ALU operation select (e.g., ADD, SUB, AND, etc.)
//   o_immSel     : Immediate type selector
//                    00 = None (R-type)
//                    01 = I-type (8-bit immediate)
//                    10 = J-type (14-bit immediate)
//   o_branch     : 1 to enable conditional branch logic, 0 to disable

`include "opcode_defs.vh"
`include "alu_defs.vh"

module inst_decode #(
    parameter ADDRESS_WIDTH = 2, 
    parameter OPCODE_WIDTH = 4,
    parameter IMM_SEL_WIDTH = 2,
    parameter ALU_OP_WIDTH = 3,
    parameter FUNCTION_WIDTH = 8
) (
    input [OPCODE_WIDTH-1:0]    i_opcode,
    input [FUNCTION_WIDTH-1:0]  i_funct,
    //input [ADDRESS_WIDTH-1:0] i_rd,  WILL BE IMPLEMENTED IN PIPELINE LATER
    
    output reg o_pc_src,
    output reg o_memToReg, 
    output reg o_memWrite, 
    output reg o_memRead,
    output reg o_regWrite,
    output reg o_alu_src, 
    output reg o_regSrc, 
    output reg [ALU_OP_WIDTH-1:0] o_alu_op, 
    output reg [IMM_SEL_WIDTH-1:0] o_immSel,
    output reg o_branch
);


// Initializes all outputs to default values 
task set_defaults;
    begin
         o_pc_src   = 0;
         o_memToReg = 0;
         o_memWrite = 0;
         o_memRead  = 0;
         o_regWrite = 0;
         o_alu_src  = 0;
         o_regSrc   = 0;
         o_alu_op   = `ALU_ADD;
         o_immSel   = `IMMSEL_NONE;
         o_branch   = 0;
    end    
endtask

// Begin combinatorial logic 
always @(*)
    begin 

        set_defaults(); 
    
        // I-Type instructions
        case(i_opcode)

        `R_TYPE: begin
            o_regWrite = 1; 

            case(i_funct) 
                `FUNCT_ADD: begin
                    o_alu_op = `ALU_ADD;
                end

                `FUNCT_SUB: begin
                    o_alu_op = `ALU_SUB;
                end

                `FUNCT_SUBS: begin
                    o_alu_op = `ALU_SUBS;
                end

                `FUNCT_AND: begin
                    o_alu_op = `ALU_AND; 
                end

                `FUNCT_OR: begin
                    o_alu_op = `ALU_OR;
                end
                
                // Default to ADD to ensure safe fallback
                default: begin
                    o_alu_op = `ALU_ADD;
                end
            endcase
        end

        // Load operation 
        `LDR: begin
            o_regWrite = 1;
            o_memToReg = 1;
            o_memRead  = 1;
            o_alu_src  = 1;
            o_regSrc   = 0;
            o_immSel   = `IMMSEL_I_TYPE;
            o_alu_op   = `ALU_ADD;
        end

        // Store operation
        `STR: begin
            o_memWrite   = 1;
            o_alu_src    = 1;
            o_regSrc     = 0;
            o_immSel     = `IMMSEL_I_TYPE;
            o_alu_op   = `ALU_ADD;
        end

        // I-type ALU instructions
        `ADDI: begin
            o_regWrite = 1;
            o_alu_src = 1;
            o_regSrc  = 1;
            o_immSel  = `IMMSEL_I_TYPE;
            o_alu_op   = `ALU_ADD;
        end

        `SUBI: begin
            o_regWrite = 1;
            o_alu_src = 1;
            o_regSrc  = 1;
            o_immSel  = `IMMSEL_I_TYPE;
            o_alu_op  = `ALU_SUB; 
        end

         // Conditional branch
        `BNE: begin
            o_branch  = 1;
            o_immSel  = `IMMSEL_I_TYPE;
            o_alu_op   = `ALU_SUB;
        end

        // Unconditional Jump
         `JMP: begin
            o_pc_src  = 1;
            o_immSel  = `IMMSEL_J_TYPE;
            o_alu_op   = `ALU_ADD;
        end

        endcase

    end
endmodule
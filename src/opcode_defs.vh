
// Date: May 5th, 2025: 
// Author: Evan Wu 

/* opcode_defs.vh  */
// Definition of R, I, and J type instruction opcodes 


/* R-TYPE INSTRUCTION FORMAT
//[17:14] -> opcode  
//[13:12] -> rd  
//[11:10] -> rs1  
//[9:8]   -> rs2  
//[7:0]   -> funct (R-type)
//[13:0]  -> immediate (I-type / J-type)


/* I-TYPE INSTRUCTION FORMAT */
//[17:14] -> opcode  
//[13:12] -> rd  
//[11:10] -> rs1  
//[9:8]   -> rs2  
//[7:0]   -> immediate 


/* J-TYPE INSTRUCTION FORMAT */
//[17:14] -> opcode 
//[13:0]  -> immediate

// R-type Opcodes 
`define R_TYPE 4'b0000

// Function Opcodes
`define FUNCT_ADD 8'h00
`define FUNCT_SUB 8'h01
`define FUNCT_SUBS 8'h02
`define FUNCT_AND 8'h03
`define FUNCT_OR  8'h04


// I-type Opcodes 
`define LDR  4'b0100
`define STR  4'b0101
`define ADDI 4'b0110
`define SUBI 4'b0111

// J-type Opcodes
`define BNE 4'b1000
`define JMP 4'b1001

// Immediate Select Type 
`define IMMSEL_NONE 2'b00   // No extension (R type)
`define IMMSEL_I_TYPE 2'b01 // 8 bit immediate (I type)
`define IMMSEL_J_TYPE 2'b10 // 14 bit immediate (J type)

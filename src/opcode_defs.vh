
// Date: May 5th, 2025: 
// Author: Evan Wu 

/* opcode_defs.vh  */
// Definition of R, I, and J type instruction opcodes 


// R-type Opcodes 
`define ADD 4'b0000
`define SUB 4'b0001
`define AND 4'b0010
`define OR  4'b0011

// I-type Opcodes 
`define LDR  4'b0100
`define STR  4'b0101
`define ADDI 4'b0110
`define SUBI 4'b0111

// J-type Opcodes
`define JMP 4'b1000
`define BNE 4'b1001

// Immediate Select Type 
`define IMMSEL_NONE 2'b00   // No extension (R type)
`define IMMSEL_I_TYPE 2'b01 // 8 bit immediate (I type)
`define IMMSEL_J_TYPE 2'b10 // 14 bit immediate (J type)

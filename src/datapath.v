
// Date: May 4th, 2025: 
// Author: Evan Wu 

/* Datapath  */
// Instantiates and connects all necessary components of CPU
// - ALU
// - Instruction decoder
// - Immediate extender
// - Branch_unit
// - Register file 
// - Program counter 
// - Instruction/Data memory 
// - Muxes 


// NOTE: For now this is a single cycle design. Plans are made 
// add to a 5 stage pipeline design.

`include "alu.v"
`include "reg_file.v"
`include "imm_extender.v"
`include "inst_decode.v"
`include "inst_mem.v"
`include "mux.v"
`include "branch_unit.v"
`include "pc.v"

module cpu (
    input i_clk,
    input i_rst
);
    
// Declare port connections 


// Register file
reg_file reg_file();
// ALU module 
alu alu();

// Instruction decoder 
inst_decode inst_decoder();

// Instruction/Data Memory 
inst_mem memory();


// Branch Unit 
branch_unit branch_unit();

// Program Counter 
pc pc();

// Muxes for Register file, Program counter, and WB stage

endmodule
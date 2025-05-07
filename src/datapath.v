
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

// Some signals are suffixed with the following letters depending on stage 
// in pipeline 
// D - Decode 
// E - Execute 
// M - Memory
// W - Writeback 


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

module cpu #(
    parameter INSTRUCTION_WIDTH = 18,
    parameter DATA_WIDTH = 36, 
    parameter NUM_REGS = 4, 
    parameter ADDRESS_WIDTH = $clog2(NUM_REGS)
)
(
    input i_clk,
    input i_rst
);
    

// Instruction fetch 
wire [INSTRUCTION_WIDTH-1:0] w_instruction;

// Register file interface
wire [ADDRESS_WIDTH-1:0] w_rs1, w_rs2, w_rd;
wire [DATA_WIDTH-1:0]  w_rs2_data, w_rs1_data,  w_wdata;


// ALU interface 
wire [DATA_WIDTH-1:0] w_alu_a, w_alu_b, w_alu_out;
wire w_alu_zero, w_alu_negative;

// Immediate extender inteface
wire [DATA_WIDTH-1:0] w_imm_ext;

// PC interface 
wire [INSTRUCTION_WIDTH-1:0] w_next_pc, w_pc_val;

// Instruction Decoder interface 
wire w_pc_srcD, w_memToRegD, w_memWriteD, w_memReadD,
     w_regWriteEnableD, w_alu_srcD, w_reg_srcD, w_alu_opD, w_immSelD,
     w_branchD ;

// Branch Unit interface 
wire w_condExeD; 


// second operand src register mux controlled by w_reg_srcD
mux2 rs2_sel #(.DATA_WIDTH = 2) ( 
    .i_a(w_instruction[]),
    .i_b(),
    .i_sel(w_reg_srcD)
); 


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
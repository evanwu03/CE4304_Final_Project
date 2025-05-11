
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
    parameter OPCODE_WIDTH = 4,
    parameter IMM_MAX_WIDTH = 14,
    parameter PC_WIDTH = 14,
    parameter ADDRESS_BUS_WIDTH = 14,
    parameter ADDRESS_WIDTH = $clog2(NUM_REGS)
)
(
    input i_clk,
    input i_rst,
    input  [INSTRUCTION_WIDTH-1:0] i_instruction,
    input  [DATA_WIDTH-1:0]        i_data_mem,
    output [DATA_WIDTH-1:0]        o_data_write,
    output [ADDRESS_BUS_WIDTH-1:0]        o_instr_addr,
    output [ADDRESS_BUS_WIDTH-1:0]        o_data_addr,
    output                         o_mem_write,
    output                         o_mem_read
);
    


// Instruction bitfields 
wire [INSTRUCTION_WIDTH-1:0] w_instruction = i_instruction;
wire [OPCODE_WIDTH-1:0]  w_opcode = w_instruction[17:14];
wire [ADDRESS_WIDTH-1:0] w_rd  = w_instruction[13:12];
wire [ADDRESS_WIDTH-1:0] w_rs1 = w_instruction[11:10];
wire [ADDRESS_WIDTH-1:0] w_rs2 = w_instruction[9:8];
wire [13:0] w_imm14 = w_instruction[13:0];
wire [7:0]  w_funct = w_instruction [7:0];


// Data memory read port 
wire [DATA_WIDTH-1:0] w_data_mem = i_data_mem;

// Register file read/write ports
wire [DATA_WIDTH-1:0]  w_rs2_data, w_rs1_data,  w_regWriteData;

// ALU interface 
wire [DATA_WIDTH-1:0] w_srcAE = w_rs1_data; // For now rs1 read port will be directly tied to ALU A operand
wire [DATA_WIDTH-1:0] w_srcBE, w_alu_outE;
wire w_alu_zero, w_alu_negative;

// Immediate extender inteface
wire [DATA_WIDTH-1:0] w_imm_ext;

// PC interface 
wire [PC_WIDTH-1:0] w_next_pc, w_pc_val;

// Instruction Decoder interface 
wire w_pc_srcD, w_memToRegD, w_memWriteD, w_memReadD,
     w_regWriteEnableD, w_alu_srcD, w_reg_srcD,
     w_branchD ;

wire [2:0] w_alu_opD;
wire [1:0] w_immSelD;

// Branch Unit interface 
wire w_condExeE; 


// Assign all ouputs
assign o_data_write = w_rs2_data;
assign o_instr_addr = w_pc_val;
assign o_data_addr  = w_alu_outE[13:0];
assign o_mem_write = w_memWriteD;
assign o_mem_read = w_memReadD;

// Program Counter 
pc pc(
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_pc_in(w_next_pc),
    .o_pc_out(w_pc_val)
);


// second operand src register mux controlled by w_reg_srcD
// Kind of realized this was redundant because it isn't used by LDR/STR
/*
wire [ADDRESS_WIDTH-1:0] w_rs2_addr; 
mux2 #(ADDRESS_WIDTH) rs2_sel ( 
    .i_a(w_rs2),
    .i_b(2'b00), // Dummy register, contents won't be used by ALU
    .i_sel(w_reg_srcD),
    .o_out(w_rs2_addr)
);
*/ 

// Register file
reg_file reg_file(
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_rs1(w_rs1),
    .i_rs2(w_rs2),
    .i_rd(w_rd),
    .i_wdata(w_regWriteData),
    .i_wen(w_regWriteEnableD),
    .o_rs1_data(w_rs1_data),
    .o_rs2_data(w_rs2_data)
);

// Immediate extender 
imm_extender imm_extender(
    .i_immRaw(w_imm14),
    .i_immSel(w_immSelD),
    .o_imm_ext(w_imm_ext)
);


// ALU source mux
mux2 #(DATA_WIDTH) alu_sel (
    .i_a(w_rs2_data),
    .i_b(w_imm_ext),
    .i_sel(w_alu_srcD),
    .o_out(w_srcBE)
);


// Instruction decoder 
inst_decode inst_decoder(
    .i_opcode(w_opcode),
    .i_funct(w_funct),
    //.i_rd(w_rd)
    .o_pc_src(w_pc_srcD),
    .o_memToReg(w_memToRegD), 
    .o_memWrite(w_memWriteD),
    .o_memRead(w_memReadD),
    .o_regWrite(w_regWriteEnableD),
    .o_alu_src(w_alu_srcD),
    .o_regSrc(w_reg_srcD),
    .o_alu_op(w_alu_opD),
    .o_immSel(w_immSelD),
    .o_branch(w_branchD)
);



// ALU module 
alu alu(
    .i_a(w_srcAE),
    .i_b(w_srcBE),
    .i_ALUControlS(w_alu_opD),
    .o_zero(w_alu_zero), 
    .o_negative(w_alu_negative),
    .o_ALU_Result(w_alu_outE)
);


// Branch Unit 
branch_unit branch_unit(
    .i_opcode(w_opcode),
    .i_zero(w_alu_zero),
    .i_negative(w_alu_negative),
    //.i_carry(),  Not implemented yet
    //.i_v(),
    .o_condition_met(w_condExeE)
);


// assign branchD & condExeE to pc_srcM
wire w_branchE = w_branchD; // Just to keep stage name convention consistent
wire w_pc_srcE = w_pc_srcD;
wire pc_srcM = w_pc_srcE & w_condExeE;
wire w_branchTakenE = w_branchE & w_condExeE;


// Muxes for WB - writeback stage
mux2  #(DATA_WIDTH) regWB_sel ( 
    .i_a(w_alu_outE),
    .i_b(w_data_mem),
    .i_sel(w_memToRegD),
    .o_out(w_regWriteData)
);


// Selects new PC value 
wire  [PC_WIDTH-1:0] pc_plus1; 
assign pc_plus1 = (i_rst) ? 14'h2000 : (w_pc_val + 14'b1);


wire signed [PC_WIDTH-1:0] w_branch_offset =  {{(PC_WIDTH-8){w_imm14[7]}}, w_imm14[7:0]}; // $signed allows for negative and positive branching offsets
wire signed [PC_WIDTH-1:0] w_branch_target;
assign w_branch_target =  w_pc_val + w_branch_offset;

mux2  #(PC_WIDTH) pc_sel (
    .i_a(pc_plus1),
    .i_b(w_branch_target),
    .i_sel(w_branchTakenE),
    .o_out(w_next_pc)
);



endmodule
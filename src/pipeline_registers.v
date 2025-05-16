// Date: May 16th, 2025: 
// Author: Evan Wu 

/* Instruction Decode Pipeline register*/
// Passes the Instruction fetched and PC+4 value to the Decode Stage
// Includes flush and stall for hazard handling


// Inputs:
//   i_clk              : system clock input
//   i_rst              : reset input
//   i_stall            : stall input from hazard unit
//   i_flush            : flush input from hazard unit 
//   i_pc_plus_4_in     : program counter + 4 value
//   i_instruction_in   : incoming instruction fetched

// Outputs:
//   i_pc_plus_4_out    : outputs the PC+4 value to the Decode stage 
//   i_instruction_out  : outputs 18-bit instruction that was fetched to the Decode stage

module IF_ID_PipeReg #(
    parameter INSTRUCTION_WIDTH = 18,
    parameter ADDRESS_WIDTH = 14
) (
    input i_clk,
    input i_rst,
    input i_stallD,                                  // if set, hold current values
    input i_flushD,                                  // if set, clear outputs (e.g., after branch mispredict)
    input [ADDRESS_WIDTH-1:0] i_pc_plus_4_F,       // Assuming 14-bit PC
    input [INSTRUCTION_WIDTH-1:0] i_instruction_F,   // Assuming 18-bit instruction width
    output reg [ADDRESS_WIDTH-1:0] o_pc_plus_4_D,
    output reg [INSTRUCTION_WIDTH-1:0] o_instruction_D
);
    

always @(posedge i_clk or posedge i_rst) begin
    
    if (i_rst || i_flushD) begin
        o_pc_plus_4_D <= 0;
        o_instruction_D <= 0;
    end
    else if (!i_stallD) begin
        o_pc_plus_4_D <= i_pc_plus_4_F;
        o_instruction_D <= i_instruction_F;
    end
    // If i_stall then retain previous values
end
endmodule




// Date: May 16th, 2025: 
// Author: Evan Wu 

/* Instruction Execution Pipeline register*/
// Transfers decoded control and data signals from ID to EX stage.
// Used to maintain state between stages in a pipelined processor.
// Flush signal included for clearing values in case branch was not predicted corretly

module ID_EX_PipeReg #(
    parameter INSTRUCTION_WIDTH = 18,
    parameter ADDRESS_WIDTH = 14,
    parameter DATA_WIDTH = 36,
    parameter ALU_OP_WIDTH = 3
) (
    // Inputs
    input i_clk,
    input i_rst,                                  // if set, hold current values
    input i_flush,                                  // if set, clear outputs (e.g., after branch mispredict)
    input i_pc_src_D, 
    input i_memToReg_D,
    input i_memWrite_D, 
    input i_memRead_D,
    input i_regWrite_D,
    input i_alu_src_D,
    input [ALU_OP_WIDTH-1:0] i_alu_op_D,
    input i_branch_D,


    // Register file data 
    input [1:0] i_rd_D, 
    input [DATA_WIDTH-1:0] i_rs1_data_D,
    input [DATA_WIDTH-1:0] i_rs2_data_D,
    input [DATA_WIDTH-1:0] i_imm_ext_D,

    // Output
    output reg o_pc_src_E, 
    output reg o_memToReg_E,
    output reg o_memWrite_E, 
    output reg o_memRead_E,
    output reg o_regWrite_E,
    output reg o_alu_src_E,
    output reg [ALU_OP_WIDTH-1:0] o_alu_op_E,
    output reg o_branch_E,

    output reg [1:0] o_rd_E,
    output reg [DATA_WIDTH-1:0] o_rs1_data_E,
    output reg  [DATA_WIDTH-1:0] o_rs2_data_E,
    output reg [DATA_WIDTH-1:0] o_imm_ext_E
);


always @(posedge i_clk or posedge i_rst) begin
    
    if (i_rst || i_flush) begin
        o_pc_src_E   <= 0;
        o_memToReg_E <= 0;
        o_memWrite_E <= 0;
        o_memRead_E  <= 0;
        o_regWrite_E <= 0;
        o_alu_src_E  <= 0;
        o_alu_op_E   <= 0;
        o_branch_E   <= 0;
        o_rs1_data_E <= 0;
        o_rs2_data_E <= 0;
        o_imm_ext_E  <= 0;
        o_rd_E       <= 0;
    end
    else begin
        o_pc_src_E   <= i_pc_src_D;
        o_memToReg_E <= i_memToReg_D;
        o_memWrite_E <= i_memWrite_D;
        o_memRead_E  <= i_memRead_D;
        o_regWrite_E <= i_regWrite_D;
        o_alu_src_E  <= i_alu_src_D;
        o_alu_op_E   <= i_alu_op_D;
        o_branch_E   <= i_branch_D;
        o_rs1_data_E <= i_rs1_data_D;
        o_rs2_data_E <= i_rs2_data_D;
        o_imm_ext_E  <= i_imm_ext_D;
        o_rd_E       <= i_rd_D;
    end
end
endmodule


// Date: May 16th, 2025: 
// Author: Evan Wu 

/* Execution Memory Pipeline register*/
// Transfers decoded memory control signals and ALU outputs from EX to MEM stage.
// Used to maintain state between stages in a pipelined processor.

module EX_MEM_PipeReg #(
    parameter INSTRUCTION_WIDTH = 18,
    parameter ADDRESS_WIDTH = 14,
    parameter DATA_WIDTH = 36
) (
    // Inputs
    input i_clk,
    input i_rst,
    input i_pc_src_E, 
    input i_regWrite_E,
    input i_memToReg_E,
    input i_memWrite_E,
    input i_memRead_E,
    input [1:0] i_rd_E,
    input [DATA_WIDTH-1:0] i_alu_out_E,
    input [DATA_WIDTH-1:0] i_writeData_E,


    // Output
    output reg o_pc_src_M, 
    output reg o_regWrite_M,
    output reg o_memToReg_M,
    output reg o_memWrite_M,
    output reg o_memRead_M,
    output reg [1:0] o_rd_M,
    output reg [DATA_WIDTH-1:0] o_alu_out_M,
    output reg [DATA_WIDTH-1:0] o_writedata_M
);


always @(posedge i_clk or posedge i_rst) begin
    if (i_rst) begin
        o_pc_src_M      <= 0;
        o_regWrite_M    <= 0;
        o_memToReg_M    <= 0;
        o_memWrite_M    <= 0;
        o_memRead_M     <= 0;
        o_rd_M          <= 0;
        o_alu_out_M     <= 0;
        o_writedata_M   <= 0;
    end
    else begin
        o_pc_src_M      <= i_pc_src_E;
        o_regWrite_M    <= i_regWrite_E;
        o_memToReg_M    <= i_memToReg_E;
        o_memWrite_M    <= i_memWrite_E;
        o_memRead_M     <= i_memRead_E;
        o_rd_M          <= i_rd_E;
        o_alu_out_M     <= i_alu_out_E;
        o_writedata_M   <= i_writeData_E;
    end
end
endmodule


// Date: May 16th, 2025: 
// Author: Evan Wu 

/* Memory Writeback Pipeline register*/
// Transfers ALU output and memory data from MEM to WB stage.
// Used to maintain state between stages in a pipelined processor.

module MEM_WB_PipeReg #(
    parameter INSTRUCTION_WIDTH = 18,
    parameter ADDRESS_WIDTH = 14,
    parameter DATA_WIDTH = 36
) (
    // Inputs
    input i_clk,
    input i_rst,

    input i_pc_src_M, 
    input i_regWrite_M,
    input i_memToReg_M,
    input [1:0] i_rd_M,
    input [DATA_WIDTH-1:0] i_memData_M, 
    input [DATA_WIDTH-1:0] i_alu_out_M,

    // Output
    output reg o_pc_src_W, 
    output reg o_regWrite_W,
    output reg o_memToReg_W,
    output reg [1:0] o_rd_W, 
    output reg [DATA_WIDTH-1:0] o_memData_W,
    output reg [DATA_WIDTH-1:0] o_alu_out_W 
);


always @(posedge i_clk or posedge i_rst) begin

    if (i_rst) begin
        o_pc_src_W      <= 0;
        o_regWrite_W    <= 0;
        o_memToReg_W    <= 0;
        o_rd_W          <= 0;
        o_memData_W     <= 0;
        o_alu_out_W     <= 0;
    end
    else begin
        o_pc_src_W      <= i_pc_src_M;
        o_regWrite_W    <= i_regWrite_M;
        o_memToReg_W    <= i_memToReg_M;
        o_rd_W          <= i_rd_M;
        o_memData_W     <= i_memData_M;
        o_alu_out_W     <= i_alu_out_M;
    end
end
endmodule
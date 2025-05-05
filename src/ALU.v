
// Date: April 15, 2025: 
// Author: Evan Wu 

/* ALU Module */
// Supports and computes the following operations for two operands: 
// # ADD 
// # SUB
// # LOGICAL AND
// # LOGICAL OR 


// Future improvements: 
// # Replace cases with enums for clarity 
// # Add Overflow detection logic 

`include "alu_defs.vh"

module alu #(
    parameter DATA_WIDTH = 36, 
    parameter ALU_OP_WIDTH = 3
)
(
    input [DATA_WIDTH-1:0] i_a,
    input [DATA_WIDTH-1:0] i_b, 
    input [ALU_OP_WIDTH-1:0] i_ALUControlS, 
    output [DATA_WIDTH-1:0] o_ALU_Result
);

  reg [DATA_WIDTH-1:0] ALU_Out; 
  assign o_ALU_Result = ALU_Out;

  always @(*)
  begin
  case (i_ALUControlS)
    
    `ALU_ADD: // ADDITION  A+B
        ALU_Out <= i_a + i_b;
 
    `ALU_SUB: // SUBTRACTION A-B
        ALU_Out <= i_a - i_b;
     
    `ALU_AND: // AND A&B
        ALU_Out <= i_a & i_b;
    `ALU_OR: // OR A|B
        ALU_Out <= i_a | i_b;
    default: // NO-OP
        ALU_Out <= ALU_Out;

  endcase 
  end 

endmodule
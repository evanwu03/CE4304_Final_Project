
// Date: April 15, 2025: 
// Author: Evan Wu 

/* ALU Module */
// Supports and computes the following operations for two operands: 
// # ADD 
// # SUB
// # LOGICAL AND
// # LOGICAL OR 


// Future improvements: 
// # Add Overflow detection logic V and C flags

`include "alu_defs.vh"

module alu #(
    parameter DATA_WIDTH = 36, 
    parameter ALU_OP_WIDTH = 3
)
(
    input [DATA_WIDTH-1:0] i_a,
    input [DATA_WIDTH-1:0] i_b, 
    input [ALU_OP_WIDTH-1:0] i_ALUControlS, 
    output [DATA_WIDTH-1:0] o_ALU_Result,

    // Conditional Flags 
    output reg o_zero,       // Set if rs1-rs2 = 0
    output reg o_negative   // Set if rs1-rs2 < 0 
    //output o_carry,      // Carry bit, unsigned overflow 
    //output o_v           // Signed overflow
);

  reg [DATA_WIDTH-1:0] ALU_Out; 
  assign o_ALU_Result = ALU_Out;

  always @(*)
  begin

    // Reset the flags
    //o_zero     <= 0;
    //o_negative <= 0;
    // o_carry <= 0;
    // o_v     <= 0;
    case (i_ALUControlS)
    
        `ALU_ADD: // ADDITION  A+B
            ALU_Out <= i_a + i_b;
    
        `ALU_SUB: // SUBTRACTION A-B
            ALU_Out <= i_a - i_b;

        `ALU_SUBS: begin  // SUBTRACTION A-B sets the conditional flags
            ALU_Out <= i_a - i_b;

            // Compute the result and set the zero flag
            o_zero <= (ALU_Out == 0);

            // Checks the MSB for sign of result.
            o_negative <= ALU_Out[DATA_WIDTH-1];
        end
    
        `ALU_AND: // AND A&B
        
            ALU_Out <= i_a & i_b;
        `ALU_OR: // OR A|B
            ALU_Out <= i_a | i_b;
        default: // NO-OP
            ALU_Out <= ALU_Out;

    endcase 
    end 

endmodule
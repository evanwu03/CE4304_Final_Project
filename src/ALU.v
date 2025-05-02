
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

module ALU(
    input [35:0] i_a,
    input [35:0] i_b, 
    input [1:0] i_ALUControlS, 
    output [35:0] o_ALU_Result
);

  reg [35:0] ALU_Out; 
  assign o_ALU_Result = ALU_Out;

  always @(*)
  begin
  case (i_ALUControlS)
    
    2'b00: // ADDITION  A+B
        ALU_Out <= i_a + i_b;
 
    2'b01: // SUBTRACTION A-B
        ALU_Out <= i_a - i_b;
     
    2'b10: // AND A&B
        ALU_Out <= i_a & i_b;
    2'b11: // OR A|B
        ALU_Out <= i_a | i_b;
    default: // NO-OP
        ALU_Out <= ALU_Out;

  endcase 
  end 

endmodule
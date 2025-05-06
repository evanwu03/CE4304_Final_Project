

// Date: May 4th, 2025: 
// Author: Evan Wu 

/* Instruction Decoder */
// Parses fields from 18-bit instructions which are used to 
// generate appropriate signals from control unit 

// Inputs:
//   i_opcode     : 4-bit opcode from instruction [17:14]
//   i_zero       : zero flag from ALU
//   i_negative   : negative flag from ALU
//   i_carry      : carry flag from ALU (unsigned overflow)
//   i_v          : v flagt from ALU (signed overflow)

// Outputs:
//   o_branchTaken : determines if jump will taken

`include "opcode_defs.vh"

module branch_unit #(
    parameter OPCODE_WIDTH = 4
) (
    input [OPCODE_WIDTH-1:0] i_opcode,
    input                    i_zero,
    input                    i_negative,
    //input                  i_carry, 
    //input                  i_v
    output reg               o_condition_met
);

always @(*)
    begin

        case(i_opcode)

            `BNE: begin
                o_condition_met <= ~i_zero; 
            end

            `JMP: begin
                o_condition_met <= 1'b1;    
            end

            default: begin
                o_condition_met <= 1'b0;
            end
        endcase

    end
endmodule
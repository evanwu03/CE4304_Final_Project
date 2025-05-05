

// Date: May 5th, 2025: 
// Author: Evan Wu 

/*  Immediate Extender Module */
// Receives IMM_SEL from control unit to decide how many bits immediate value needs 
// depending on instruction type
//  Inputs: 
//  i_immSel     : Immediate type selector from instruction decoder
//                    00 = None (R-type)
//                    01 = I-type (8-bit immediate)
//                    10 = J-type (14-bit immediate)
//  i_immRaw - Max size for any immediate field  
//
//  Outputs:  
//  o_imm_ext - extended immediate field

module imm_extender #(
    parameter DATA_WIDTH = 36,
    parameter SELECT_WIDTH = 2,
    parameter IMM_MAX_WIDTH = 14
) (
    input [IMM_MAX_WIDTH-1:0] i_immRaw,
    input [SELECT_WIDTH-1:0] i_immSel,
    output reg [DATA_WIDTH-1:0] o_imm_ext
);
    
endmodule
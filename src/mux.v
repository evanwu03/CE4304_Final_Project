// Date: May 6th, 2025: 
// Author: Evan Wu 

/* 2x1 multiplexer */
module mux2 #(
    parameter DATA_WIDTH = 36
) (
    input [DATA_WIDTH-1:0] i_a, 
    input [DATA_WIDTH-1:0]i_b, 
    input i_sel, 
    output [DATA_WIDTH-1:0] o_out
);

assign o_out = i_sel ? i_b : i_a;

endmodule
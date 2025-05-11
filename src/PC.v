// Date: May 2nd, 2025: 
// Author: Evan Wu 

/* Progam Counter Module */
/* TO-DO : */ 
// add branching logic when a jmp/branch command is executed 
// Branch prediction for conditional hazards
// Move PC logic into separate mux module along datapath.

module pc#(
    parameter WIDTH = 14
)(
    input i_rst,
    input i_clk, 
    input [WIDTH-1:0] i_pc_in,
    output reg [WIDTH-1:0] o_pc_out
);

always @(posedge i_clk) 
begin
    
    if (i_rst) 
        begin
            o_pc_out <= 14'h2000; 
        end
    else
        begin
            o_pc_out <= i_pc_in;
        end
end

endmodule
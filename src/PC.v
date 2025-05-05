// Date: May 2nd, 2025: 
// Author: Evan Wu 

/* Progam Counter Module */
/* TO-DO : */ 
// add branching logic when a jmp/branch command is executed 
// Branch prediction for conditional hazards
// Move PC logic into separate mux module along datapath.

module pc(
    input i_rst,
    input i_clk, 
    output reg [35:0] o_pc
);

always @(posedge i_clk) 
begin
    
    if (i_rst) 
        begin
            o_pc <= 0; 
        end
    else
        begin
            o_pc <= o_pc + 1;
        end
end

endmodule
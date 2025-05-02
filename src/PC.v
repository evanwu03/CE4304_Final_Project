


// Date: May 2nd, 2025: 
// Author: Evan Wu 

/* Progam Counter Module */
/* TO-DO : */ 
// add branching logic when a jmp command is executed 
// Branch prediction for conditional hazards

module PC(
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
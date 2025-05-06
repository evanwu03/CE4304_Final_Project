
// Date: May 2nd, 2025: 
// Author: Evan Wu 

/* Instruction Module */
// Stores and fetches the program 18-bit instructions to be executed by the microprocessor. 
// Implemented in Von Neumann architecture, 
// Instruction are addressed by the lower 13 bits of the address space.
// Instruction memory occupies addresses 0x0000 to 0x1FFF (13-bit address space). 
// Data memory occupies addresses 0x2000 to 0x3FFF (13-bit address space). 

// Future improvements: 

module inst_mem #(
    parameter INSTRUCTION_MEM_SIZE = 8192,
    parameter INSTRUCTION_WIDTH    = 18,
    parameter INSTRUCTION_ADDR_WIDTH = $clog2(INSTRUCTION_MEM_SIZE)+1,
    parameter MEM_BASE_ADDR = 14'h2000 // Programs are loaded 0x2000
) (
    input i_clk,
    input [INSTRUCTION_ADDR_WIDTH-1:0] i_address,
    output reg [INSTRUCTION_WIDTH-1:0] instruction
);
    
    // Defines Instruction 8kb memory array 
    reg [INSTRUCTION_WIDTH-1:0] memory [0:INSTRUCTION_MEM_SIZE-1]; 

    // Fetches an instruction from memory every clock cycle
    always @(posedge i_clk) 
        begin
            if (i_address >= MEM_BASE_ADDR) begin
                instruction <= memory[i_address-MEM_BASE_ADDR];
            end
            else if (i_address <= MEM_BASE_ADDR) begin
                instruction <= {INSTRUCTION_WIDTH{1'b0}}; // NOP or invalid
            end
        end
endmodule


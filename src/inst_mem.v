
// Date: May 2nd, 2025: 
// Author: Evan Wu 

/* Instruction Module */
// Stores and fetches the program 18-bit instructions to be executed by the microprocessor. 
// Implemented in Von Neumann architecture, 
// Instruction are addressed by the lower 13 bits of the address space.
// Instruction memory occupies addresses 0x2000 to 0x3FFF (14-bit address space). 
// Data memory occupies addresses 0x0000 to 0x1FFF (14-bit address space). 


// Inputs: 
// i_clk - clock input
// i_writeEnable - data write enable input 
// i_dataReadEnable - data read enable input 
// i_wdata - data to be written to data memory
// i_address - 14 bit address bus 

// Outputs: 
// o_instruction - 18 bit instruction to be fetched
// o_data - 36 bit word to be read 


// Future improvements: 
// Compact Two 18 bit half-word instructions into 1 36 bit word


module inst_mem #(
    parameter INSTRUCTION_MEM_SIZE = 16384,
    parameter INSTRUCTION_WIDTH    = 18,
    parameter DATA_WIDTH           = 36,
    parameter ADDRESS_BUS_WIDTH    = $clog2(INSTRUCTION_MEM_SIZE),
    parameter MEM_BASE_ADDR        = 14'h2000 // Programs are loaded 0x2000
) (
    input i_clk,
    input i_writeEnable,
    input i_dataReadEnable,
    input [DATA_WIDTH-1:0] i_wdata, 
    input [ADDRESS_BUS_WIDTH-1:0] i_address,
    output reg [INSTRUCTION_WIDTH-1:0] o_instruction,
    output reg [DATA_WIDTH-1:0] o_data
);
    
    // Defines Instruction 8kb memory array 
    reg [DATA_WIDTH-1:0] memory [0:INSTRUCTION_MEM_SIZE-1]; 

    // Fetches an instruction from memory every clock cycle
    always @(posedge i_clk) 
        begin

            // Write to data memory 
            if (i_writeEnable && (i_address < MEM_BASE_ADDR) && (i_address >= 0)) begin
                memory[i_address] <= i_wdata;
            end

            // Read Data memory 
            else if (i_dataReadEnable && (i_address < MEM_BASE_ADDR) ) begin
                o_data <= memory[i_address];
            end

            // Instruction Fetch
            else if (i_address >= MEM_BASE_ADDR) begin
                o_instruction <= memory[i_address-MEM_BASE_ADDR][INSTRUCTION_WIDTH-1:0];
            end

            // Out of Range/Invalid execute NOP
            else begin
                 o_instruction <= {INSTRUCTION_WIDTH{1'b0}}; // NOP or invalid 
                 o_data <= {DATA_WIDTH{1'b0}};
            end
        end
endmodule


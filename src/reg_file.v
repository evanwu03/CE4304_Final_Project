
// Date: May 3rd, 2025: 
// Author: Evan Wu 

/* 4x36 Register File */
// Inputs: 
// - i_clk: clock input
// - i_rst: reset input 
// - i_rs1: source register 1
// - i_rs2: source register 2
// - i_rd:  destination register 
// - i_w data: write data 
// - i_wen: write enable. data can only be written to register if signal is logic high.

// Outputs: 
// - o_rs1_data: source register 1 data
// - o_rs2_data: source register 2 data 

module reg_file #(
    parameter NUM_REGS = 4, 
    parameter DATA_WIDTH = 36, 
    parameter ADDRESS_WIDTH = $clog2(NUM_REGS)
) (
    input i_clk,
    input i_rst, 
    input [ADDRESS_WIDTH-1:0] i_rs1,
    input [ADDRESS_WIDTH-1:0] i_rs2, 
    input [ADDRESS_WIDTH-1:0] i_rd, 
    input [DATA_WIDTH-1:0]    i_wdata, 
    input i_wen,

    output reg [DATA_WIDTH-1:0] o_rs1_data,
    output reg [DATA_WIDTH-1:0] o_rs2_data
);
    

// Declare array of 4 general purpose registers
reg [DATA_WIDTH-1:0] r_regs [0:NUM_REGS-1];

// Asynchronous Read
always @(*)
    begin
        o_rs1_data <= r_regs[i_rs1];
        o_rs2_data <= r_regs[i_rs2];
    end

integer i = 0; 
// Synchronous Write
always @(posedge i_clk) 
    begin
        if (i_rst) // Reset all registers to 0
             begin
                for (i = 0; i < NUM_REGS; i = i+1)
                    begin
                        r_regs[i] <= 0;
                    end
            end
        else if (i_wen) // if write is enabled and is not R0, write data to destination register.
            begin
                r_regs[i_rd] <= i_wdata; 
                $display("Wrote %d to R%d", i_wdata, i_rd);
            end
    end


endmodule
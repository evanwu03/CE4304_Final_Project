

`timescale 1ns/ 1ps
`include "../src/inst_mem.v"

module inst_mem_tb;

    // Parameters
    localparam INSTRUCTION_MEM_SIZE    = 8192;
    localparam INSTRUCTION_WIDTH       = 18;
    localparam INSTRUCTION_ADDR_WIDTH  = $clog2(INSTRUCTION_MEM_SIZE);
    parameter c_CLOCK_PERIOD_NS        = 100;

    // Inputs
    reg r_clk = 0;
    reg [INSTRUCTION_ADDR_WIDTH-1:0] i_address;

    // Output
    wire [INSTRUCTION_WIDTH-1:0] o_instruction;

    // Instantiate the Instruction Memory
    inst_mem #(
        .INSTRUCTION_MEM_SIZE(INSTRUCTION_MEM_SIZE),
        .INSTRUCTION_WIDTH(INSTRUCTION_WIDTH)
    ) uut (
        .i_clk(r_clk),
        .i_address(i_address),
        .instruction(o_instruction)
    );

    // Clock generation
    always
        #(c_CLOCK_PERIOD_NS/2) r_clk <= !r_clk;


    always @(posedge r_clk) begin
        $display("Time: %0t | Addr: %0d | Instruction: %0h", $time, i_address, o_instruction);
    end


    // Test data
    initial begin
        // Initialize signals
        r_clk = 0;
        i_address = 0;

        // Preload memory (optional: create `program.hex` file with 18-bit hex values)
        $readmemh("program.hex", uut.memory);

        // Wait and then test a few addresses
        i_address <= 0;
        @(posedge r_clk)
        i_address <= 1;
        @(posedge r_clk)
        i_address <= 2;
        @(posedge r_clk)
        i_address <= 3;
        @(posedge r_clk)
        i_address <= 4;
        @(posedge r_clk)
        i_address <= 5;
        @(posedge r_clk)
        i_address <= 100;
        @(posedge r_clk)
        i_address <= 8191; // Edge of memory
        @(posedge r_clk)
        $finish;
    end
    
    initial
    begin
        // Required to dump signals to EPWave
        $dumpfile("dump.vcd");
        $dumpvars(0);
    end
endmodule

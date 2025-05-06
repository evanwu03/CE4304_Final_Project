

`timescale 1ns/ 1ps
`include "../src/inst_mem.v"

module inst_mem_tb;

    // Parameters
    localparam INSTRUCTION_MEM_SIZE    = 8192;
    localparam INSTRUCTION_WIDTH       = 18;
    localparam INSTRUCTION_ADDR_WIDTH  = $clog2(INSTRUCTION_MEM_SIZE)+1;
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
        i_address = 14'h2000;

        // Preload memory (optional: create `program.hex` file with 18-bit hex values)
        $readmemh("program.hex", uut.memory);

        // Wait and then test a few addresses        
        @(posedge r_clk)
        i_address <= 14'h2000;
        @(posedge r_clk)
        i_address <= 14'h2001;
        @(posedge r_clk)
        i_address <= 14'h2002;
        @(posedge r_clk)
        i_address <= 14'h2003;
        @(posedge r_clk)
        i_address <= 14'h2004;
        @(posedge r_clk)
        i_address <= 14'h2005;
        @(posedge r_clk)
        i_address <= 14'h2006;
        @(posedge r_clk)
        i_address <= 14'h2007; 
        @(posedge r_clk)
        i_address <= 14'h2008;
        @(posedge r_clk)
        i_address <= 14'h2009;
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

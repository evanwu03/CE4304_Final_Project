
`include "../src/datapath.v"

`timescale 1ns/ 1ps

module cpu_tb1;

    // Parameters
    localparam c_CLOCK_PERIOD_NS = 100;
    localparam DATA_WIDTH = 36; 
    localparam ADDRESS_BUS_WIDTH = 14;
    localparam INSTRUCTION_WIDTH = 18;

    reg r_clk = 0;
    reg r_rst = 0;

   
    wire w_mem_write, w_mem_read;
    wire [DATA_WIDTH-1:0] w_data_mem;
    wire [INSTRUCTION_WIDTH-1:0] w_instruction;
    wire [DATA_WIDTH-1:0] w_data_write;
    wire [ADDRESS_BUS_WIDTH-1:0] w_data_addr, w_instr_addr;


    cpu uut (
        .i_clk(r_clk),
        .i_rst(r_rst),
        .i_instruction(w_instruction),
        .i_data_mem(w_data_mem),
        .o_data_write(w_data_write),
        .o_instr_addr(w_instr_addr),
        .o_data_addr(w_data_addr),
        .o_mem_write(w_mem_write),
        .o_mem_read(w_mem_read)
    );

    inst_mem memory( 
        .i_clk(r_clk),
        .i_writeEnable(w_mem_write),
        .i_dataReadEnable(w_mem_read),
        .i_wdata(w_data_write),
        .i_instr_address(w_instr_addr),
        .i_data_address(w_data_addr),
        .o_instruction(w_instruction),
        .o_data(w_data_mem)
    );

    // Clock generation
    always
        #(c_CLOCK_PERIOD_NS/2) r_clk <= !r_clk;


    // Load program 
    initial begin
    // Preload memory (optional: create `program.hex` file with 18-bit hex values)
        $display("Trying to load program");
        $readmemb("test1.mem", memory.memory);
    end

    // Test data
    initial begin
        $display("Simulation Started");
        // Reset program counter 
        r_rst <= 1; 
        @(posedge r_clk)
        r_rst <= 0; 

        repeat (50) @(posedge r_clk);
        $finish;
        // Run rest of program       
    end
    
    

    initial
    begin
        // Required to dump signals to EPWave
        $dumpfile("dump.vcd");
        $dumpvars(0, cpu_tb1);
    end
endmodule


`include "../src/datapath.v"

`timescale 1ns/ 1ps

module cpu_tb;

    // Parameters
    localparam c_CLOCK_PERIOD_NS = 100;

    reg r_clk = 0;
    reg r_rst = 0;
    wire w_out; 

    cpu uut (
        .i_clk(r_clk),
        .i_rst(r_rst),
        .o_dummy(w_out)
    );

    // Clock generation
    always
        #(c_CLOCK_PERIOD_NS/2) r_clk <= !r_clk;

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
        $dumpvars(0, cpu_tb);
    end
endmodule

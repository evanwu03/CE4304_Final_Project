
`timescale 1ns/ 1ps
`include "../src/PC.v"

module PC_tb(); 

    parameter c_CLOCK_PERIOD_NS = 100;

    reg r_rst = 0; 
    reg r_clk = 0;
    wire [35:0] pc_out; 
    
    PC dut(
        .i_rst(r_rst),
        .i_clk(r_clk),
        .o_pc(pc_out) 
    );

    // Test Stimulus
      // Main Testing:
    always
        #(c_CLOCK_PERIOD_NS/2) r_clk <= !r_clk;

    initial
    begin

      // Toggle the rst pin on start up to ensure PC starts at 0. 
      r_rst <= 0;
      @(posedge r_clk);
      r_rst <= 1;
      @(posedge r_clk);
      r_rst <= 0; 

      // Wait 3 clock cycles 
      @(posedge r_clk);
      @(posedge r_clk); 
      @(posedge r_clk);  

      @(posedge r_clk);
      if (pc_out == 36'd3) begin
        $display("Test Passed - Correct PC value");
      end
      else begin
        $display("Test Failed - Incorrect PC value");
      end
   $finish;
   end
  
  initial 
  begin
    // Required to dump signals to EPWave
    $dumpfile("dump.vcd");
    $dumpvars(0);
  end

endmodule 
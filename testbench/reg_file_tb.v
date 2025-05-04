


`timescale 1ns/ 1ps
`include "../src/reg_file.v"

module reg_file_tb(); 

    localparam c_CLOCK_PERIOD_NS = 100; // 100MHz Clock
    localparam NUM_REGS = 4;
    localparam  DATA_WIDTH = 36;
    localparam ADDRESS_WIDTH = $clog2(NUM_REGS);
    

    // Inputs
    reg r_clk = 0;
    reg r_rst = 0; 
    reg [ADDRESS_WIDTH-1:0] r_rs1 = 0;
    reg [ADDRESS_WIDTH-1:0] r_rs2 = 0; 
    reg [ADDRESS_WIDTH-1:0] r_rd = 0;
    reg [DATA_WIDTH-1:0]    r_wdata = 0;
    reg r_wen = 0;

    // Outputs
    wire  [DATA_WIDTH-1:0] w_rs1_data;
    wire [DATA_WIDTH-1:0] w_rs2_data;

    reg_file dut(
        .i_clk(r_clk),
        .i_rst(r_rst),
        .i_rs1(r_rs1),
        .i_rs2(r_rs2),
        .i_rd(r_rd),
        .i_wdata(r_wdata),
        .i_wen(r_wen),
        .o_rs1_data(w_rs1_data),
        .o_rs2_data(w_rs2_data)
    );

    // Test Stimulus

    // 1. Reset the register file and check all registers are 0
    // 2.Write to a register (e.g., R2) and verify you can read it back
    // 3.Try writing when i_wen = 0 and verify it doesn't change the value
    // 4. Simultaneously test reading from both ports

    // Clock Generation 
    always
        #(c_CLOCK_PERIOD_NS/2) r_clk <= !r_clk;

    initial
    begin

      // Toggle the rst pin on start up to ensure register values are initialized to 0.
      @(posedge r_clk);
      r_rst <= 1;
      @(posedge r_clk);
      r_rst <= 0; 

      // Write a value of 0x11 to R0, R1, R2 R3
      @(posedge r_clk);
      r_wen <= 1; 
      r_rd <= 0; 
      r_rs1 <= 0;
      r_wdata <= 36'h11;

      @(posedge r_clk); 

      @(posedge r_clk); 
      r_rd <= 1; 
      r_rs1 <= 1;
      r_wdata <= 36'h22;

      @(posedge r_clk);
      r_rd <= 2;
      r_rs1 <= 2;
      r_wdata <= 36'h33;

      @(posedge r_clk);
      r_rd <= 3; 
      r_rs1 <= 3;
      r_wdata <= 36'h123456789;

      // Disable wen, R4 value should not change 
      @(posedge r_clk);
      r_wen <= 0; 
      r_rd <= 3;
      r_wdata <= 36'h555;

      // Wait a clock cycle
      @(posedge r_clk);

      // Toggle the rst pin again to reset all registers.
      @(posedge r_clk);
      r_rst <= 1;
      @(posedge r_clk);
      r_rst <= 0; 

      // Read all of the registers to check they are properly reset.
      @(posedge r_clk);
      r_rs1 <= 0;
      r_rs2 <= 0;
      @(posedge r_clk);
      r_rs1 <= 1;
      r_rs2 <= 1;
      @(posedge r_clk);
      r_rs1 <= 2;
      r_rs2 <= 2;
      @(posedge r_clk);
      r_rs1 <= 3;
      r_rs2 <= 3;
      @(posedge r_clk);
      $finish;
   end
  
  initial 
  begin
    // Required to dump signals to EPWave
    $dumpfile("dump.vcd");
    $dumpvars(0);
  end

endmodule 

`timescale 1ns/ 1ps
`include "../src/ALU.v"

module ALU_tb (); 

    reg [35:0] i_a; 
    reg [35:0] i_b; 
    reg [1:0]  i_ALUControlS;
    wire [35:0] o_ALU_Result; 
    
    ALU dut(
        .i_a(i_a),
        .i_b(i_b),
        .i_ALUControlS(i_ALUControlS),
        .o_ALU_Result(o_ALU_Result) 
    );

    // Test Stimulus
    initial begin
        $monitor("time=%d, i_a=%d, i_b=%d, i_ALUControlS=%2b, o_ALU_Result=%x \n", 
        $time, i_a, i_b, i_ALUControlS, o_ALU_Result);

        // Generate each input with 20ns delay
        
        // ADD 1+1 => 2
        i_a = 1;
        i_b = 1; 
        i_ALUControlS = 2'b00;
        #20

        // ADD  435+245 => 680
        i_a = 435;
        i_b = 245;
        i_ALUControlS = 2'b00;
        #20 

        // SUB 2-1 => 1
        i_a = 2; 
        i_b = 1; 
        i_ALUControlS = 2'b01;
        #20 

        // SUB 5-6 => -1
        i_a = 5; 
        i_b = 6; 
        i_ALUControlS = 2'b01;
        #20

        //  AND  2&7 => 2 
        i_a = 2; 
        i_b = 7; 
        i_ALUControlS = 2'b10;
        #20

        // OR 8 | 11 => 11
        i_a = 8;
        i_b = 11;
        i_ALUControlS = 2'b11;
        #20 

        // ADD 68719476736 + 1 Check for Overflow not currently supported
        i_a = 68719476735;
        i_b = 1; 
        i_ALUControlS = 2'b00;
        #20
        $finish;
    end

endmodule 
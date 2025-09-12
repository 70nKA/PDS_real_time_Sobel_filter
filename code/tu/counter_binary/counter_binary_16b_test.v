`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:49:11 09/12/2025
// Design Name:   counter_binary_16b
// Module Name:   /home/ise/code/tu/counter_binary/counter_binary_16b_test.v
// Project Name:  tu
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: counter_binary_16b
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module counter_binary_16b_test;

	// Inputs
	reg clk;
	reg reset;
	reg [15:0] max_count;

	// Outputs
	wire max_tick;

	// Helpers
	reg baud_rate;

	// Instantiate the Unit Under Test (UUT)
	counter_binary_16b uut (
		.clk(clk), 
		.reset(reset), 
		.max_count(max_count), 
		.max_tick(max_tick)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 1;
		max_count = 0;
		
		baud_rate = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		reset = 0;
		
		#20;
		max_count = 163;
	end
   
	always #10 clk = ~clk;
	always #26041.7 baud_rate = ~baud_rate;
endmodule


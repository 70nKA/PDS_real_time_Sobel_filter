`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   06:42:16 09/14/2025
// Design Name:   baud_rate_tick_gen_115200
// Module Name:   /home/ise/code/tu/baud_rate_tick_gen/baud_rate_tick_gen_115200_test.v
// Project Name:  tu
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: baud_rate_tick_gen_115200
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module baud_rate_tick_gen_115200_test;

	// Inputs
	reg clk;
	reg reset;

	// Outputs
	wire tick;
	
	// Helpers
	reg baud_rate;
	reg [15:0] counter;

	// Instantiate the Unit Under Test (UUT)
	baud_rate_tick_gen_115200 uut (
		.clk(clk), 
		.reset(reset), 
		.tick(tick)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 1;

		baud_rate = 0;
		counter = 0;

		// Wait 100 ns for global reset to finish
		#100;

		// Add stimulus here
		reset = 0;
	end

	always #10 clk = ~clk;
	always #4340.28 baud_rate = ~baud_rate;
	
	always@(posedge tick)
	begin
		if(baud_rate)
			counter <= counter + 1;
	end
endmodule


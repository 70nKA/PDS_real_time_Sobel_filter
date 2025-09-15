`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:03:59 09/14/2025
// Design Name:   uart_rx_circuit
// Module Name:   /home/ise/code/uart/uart_rx/uart_rx_circuit_test.v
// Project Name:  uart
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: uart_rx_circuit
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module uart_rx_circuit_test;

	// Inputs
	reg clk;
	reg reset;
	reg rx;

	// Outputs
	wire rx_done_tick;
	wire [7:0] dout;
	
	// Helpers
	wire tick;
	reg baud_rate;

	// Instantiate the Unit Under Test (UUT)
	uart_rx_circuit uut (
		.clk(clk), 
		.reset(reset), 
		.rx(rx), 
		.s_tick(tick), 
		.rx_done_tick(rx_done_tick), 
		.dout(dout)
	);

	baud_rate_tick_gen_115200 mod_baud_rate_tick_gen_115200
	(
		.clk(clk), .reset(reset),
		.tick(tick)
	);
	
	always #10 clk = ~clk;
	always #4340.27 baud_rate = ~baud_rate;

	initial begin
		// Initialize Inputs
		clk = 1;
		reset = 1;
		rx = 1;
		baud_rate = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		reset = 0;
		
		#8680.55;
		
		rx = 0;
		#8680.55;
		
		rx = 1;
		#8680.55;
		rx = 0;
		#8680.55;
		rx = 0;
		#8680.55;
		rx = 0;
		#8680.55;
		
		rx = 1;
		#8680.55;
		rx = 0;
		#8680.55;
		rx = 1;
		#8680.55;
		rx = 1;
		#8680.55;

		rx = 1;
		#8680.55;
		
		$stop;
	end
      
endmodule


`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:42:53 09/05/2025
// Design Name:   line_buffer_controller
// Module Name:   /home/ise/code/line_buffer/controller/line_buffer_controller_test.v
// Project Name:  line_buffer
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: line_buffer_controller
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////
module line_buffer_controller_test;

    // Parameters
    parameter LINEBUFFERCON_BYTE = 8;
    parameter LINEBUFFERCON_LINE_WIDTH = 64;

    // Inputs
    reg clk;
    reg reset;
    reg [LINEBUFFERCON_BYTE-1:0] data_in;
    reg [9:0] bram_byte_counter;

    // Outputs
    wire [0:8*9-1] sobel_pixels;

    // Instantiate the Unit Under Test (UUT)
    line_buffer_controller
	 #(
		.LINEBUFFERCON_BYTE(LINEBUFFERCON_BYTE),
		.LINEBUFFERCON_LINE_WIDTH(LINEBUFFERCON_LINE_WIDTH)
	 )
	 uut
	 (
        .clk(clk),
        .reset(reset),
        .data_in(data_in),
        .sobel_pixels(sobel_pixels),
        .bram_byte_counter(bram_byte_counter)
    );

    // Test data array for simulation
    reg [LINEBUFFERCON_BYTE-1:0] test_data [0:LINEBUFFERCON_LINE_WIDTH-1];
    integer i;

    initial begin
        // Initialize Inputs
        clk = 0;
        reset = 1;
        data_in = 0;
        bram_byte_counter = LINEBUFFERCON_LINE_WIDTH; // Assume BRAM has enough data initially

        // Write test data to array
        for (i = 0; i < LINEBUFFERCON_LINE_WIDTH; i = i + 1) begin
            test_data[i] = i; // Simple sequential data for testing
        end

        // Reset the system initially
        #20 reset = 0;

        // Load data into line_buffer_3
        for (i = 0; i < LINEBUFFERCON_LINE_WIDTH; i = i + 1) begin
            data_in = test_data[i];
            #20; // Wait for one clock cycle
        end
		  bram_byte_counter = 0;

        // Wait for some cycles to allow the buffers to shift and export Sobel kernels
        #1360; // Wait for 64 clock cycles

        // Display results
        $display("sobel_pixels = %h", sobel_pixels);
		  
		  #40;

        // Finish the test
        $finish;
    end

    // Clock generation
    always begin
        #10 clk = ~clk; // 10 ns clock period
    end

    // Monitor signals for debugging
    initial begin
        $monitor("Time=%0t clk=%b reset=%b data_in=%h bram_byte_counter=%d sobel_pixels=%h",
                 $time, clk, reset, data_in, bram_byte_counter, sobel_pixels);
    end

endmodule

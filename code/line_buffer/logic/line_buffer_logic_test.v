`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:02:18 09/04/2025
// Design Name:   line_buffer_logic
// Module Name:   /home/ise/code/line_buffer/logic/line_buffer_logic_test.v
// Project Name:  line_buffer
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: line_buffer_logic
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////
module line_buffer_logic_test;

    // Parameters
    parameter LINEBUFFERLOG_BYTE = 8;
    parameter LINEBUFFERLOG_LINE_WIDTH = 64;

    // Inputs
    reg clk;
    reg reset;
    reg load_line_buffer_3;
    reg shift_line_buffer;
    reg export_sobel_kernel;
    reg [LINEBUFFERLOG_BYTE-1:0] data_in;

    // Outputs
    wire [0:8*9-1] sobel_pixels;

    // Instantiate the Unit Under Test (UUT)
    line_buffer_logic uut 
    (
        .clk(clk),
        .reset(reset),
        .load_line_buffer_3(load_line_buffer_3),
        .shift_line_buffer(shift_line_buffer),
        .export_sobel_kernel(export_sobel_kernel),
        .data_in(data_in),
        .sobel_pixels(sobel_pixels)
    );

    // Test data array for simulation
    reg [LINEBUFFERLOG_BYTE-1:0] test_data [0:LINEBUFFERLOG_LINE_WIDTH-1];
    integer i;

    initial begin
        // Initialize Inputs
        clk = 1;
        reset = 1;
        load_line_buffer_3 = 0;
        shift_line_buffer = 0;
        export_sobel_kernel = 0;
        data_in = 0;

        // Write test data to array
        for (i = 0; i < LINEBUFFERLOG_LINE_WIDTH; i = i + 1) begin
            test_data[i] = i; // Simple sequential data for testing
        end

        // Reset the system initially
        #20 reset = 0;

        // Load data into line_buffer_3
        for (i = 0; i < LINEBUFFERLOG_LINE_WIDTH; i = i + 1) begin
            data_in = test_data[i];
            load_line_buffer_3 = 1;
            #20; // Wait for one clock cycle
            load_line_buffer_3 = 0;
            #20; // Wait for one clock cycle to allow the buffer to update
        end

        // Shift the line buffers
        shift_line_buffer = 1;
        #60; // Wait for 3 clock cycles
        shift_line_buffer = 0;

        // Export Sobel pixels
        export_sobel_kernel = 1;
        #1280; // Wait for 64 clock cycles
        export_sobel_kernel = 0;

        // Display results
        $display("sobel_pixels = %h", sobel_pixels);
			
		  #20

        // Finish the test
        $finish;
    end

    // Clock generation
    always begin
        #10 clk = ~clk; // 10 ns clock period
    end

    // Monitor signals for debugging
    initial begin
        $monitor("Time=%0t clk=%b reset=%b load_line_buffer_3=%b shift_line_buffer=%b export_sobel_kernel=%b data_in=%h sobel_pixels=%h",
                 $time, clk, reset, load_line_buffer_3, shift_line_buffer, export_sobel_kernel, data_in, sobel_pixels);
    end

endmodule

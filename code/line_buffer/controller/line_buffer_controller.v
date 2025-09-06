`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:12:25 09/05/2025 
// Design Name: 
// Module Name:    line_buffer_controller 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module line_buffer_controller
    #(
        parameter LINEBUFFERCON_BYTE = 8,
        parameter LINEBUFFERCON_LINE_WIDTH = 64
    )
    (
        input wire clk,
        input wire reset,
        input wire [LINEBUFFERCON_BYTE-1:0] data_in,
        output wire [0:8*9-1] sobel_pixels,
        input wire [9:0] bram_byte_counter // Input from external BRAM module indicating available bytes
    );

    // Local variables and signals
    reg load_line_buffer_3;
    reg shift_line_buffer;
    reg export_sobel_kernel;

    // Instantiate the line_buffer_logic module
    line_buffer_logic 
	 #(
		.LINEBUFFERLOG_BYTE(LINEBUFFERCON_BYTE),
		.LINEBUFFERLOG_LINE_WIDTH(LINEBUFFERCON_LINE_WIDTH)
	 )
	 mod_line_buffer_logic
	 (
        .clk(clk),
        .reset(reset),
        .load_line_buffer_3(load_line_buffer_3),
        .shift_line_buffer(shift_line_buffer),
        .export_sobel_kernel(export_sobel_kernel),
        .data_in(data_in),
        .sobel_pixels(sobel_pixels)
    );

    // States definition
    parameter IDLE = 3'b000;
    parameter LOAD_DATA = 3'b001;
    parameter SHIFT_BUFFERS = 3'b010;
    parameter EXPORT_KERNEL = 3'b011;

    // Local variables for state machine
    reg [2:0] state;
    reg [8:0] byte_counter;
    reg [8:0] pixel_counter;
    reg [3:0] shift_counter;

    always @(posedge clk or posedge reset)
		 begin
			  if (reset)
				  begin
						state <= IDLE;
						byte_counter <= 0;
						pixel_counter <= 0;
						shift_counter <= 0;
						load_line_buffer_3 <= 0;
						shift_line_buffer <= 0;
						export_sobel_kernel <= 0;
				  end
			  else
				  begin
						case (state)
							 IDLE:
								 begin
									  // Check if there are enough bytes in BRAM to fill line_buffer_3
									  if (bram_byte_counter >= LINEBUFFERCON_LINE_WIDTH)
										  begin
												state <= LOAD_DATA;
												load_line_buffer_3 <= 1;
										  end
								 end

							 LOAD_DATA:
								 begin
									  if (byte_counter == LINEBUFFERCON_LINE_WIDTH - 1)
										  begin
												byte_counter <= 0;
												load_line_buffer_3 <= 0;
												shift_line_buffer <= 1;
												state <= SHIFT_BUFFERS;
										  end
									  else
										  begin
												byte_counter <= byte_counter + 1;
										  end
								 end

							 SHIFT_BUFFERS:
								 begin
									  if (shift_counter == 3)
										  begin
												shift_counter <= 0;
												shift_line_buffer <= 0;
												export_sobel_kernel <= 1;
												state <= EXPORT_KERNEL;
										  end
									  else
										  begin
												shift_counter <= shift_counter + 1;
										  end
								end

							 EXPORT_KERNEL:
								 begin
									  if (pixel_counter == LINEBUFFERCON_LINE_WIDTH - 1)
										  begin
												pixel_counter <= 0;
												export_sobel_kernel <= 0;
												state <= IDLE;
										  end
									  else
										  begin
												pixel_counter <= pixel_counter + 1;
										  end
								end
						endcase
				  end
		 end
endmodule

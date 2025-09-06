`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:53:10 09/04/2025 
// Design Name: 
// Module Name:    line_buffer_logic 
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
module line_buffer_logic
    #(
        parameter LINEBUFFERLOG_BYTE = 8,
        parameter LINEBUFFERLOG_LINE_WIDTH = 64
    )
    (
        input wire clk,
        input wire reset,
        input wire load_line_buffer_3,
        input wire shift_line_buffer,
        input wire export_sobel_kernel,
        input wire [LINEBUFFERLOG_BYTE-1:0] data_in,
        output wire [0:8*9-1] sobel_pixels
    );

    reg [LINEBUFFERLOG_BYTE-1:0] ln_buff_3_array [0:LINEBUFFERLOG_LINE_WIDTH-1];
    reg [LINEBUFFERLOG_BYTE-1:0] ln_buff_2_array [0:LINEBUFFERLOG_LINE_WIDTH-1];
    reg [LINEBUFFERLOG_BYTE-1:0] ln_buff_1_array [0:LINEBUFFERLOG_LINE_WIDTH-1];
    reg [LINEBUFFERLOG_BYTE-1:0] ln_buff_0_array [0:LINEBUFFERLOG_LINE_WIDTH-1];

    reg [LINEBUFFERLOG_BYTE-1:0] reg_sobel_pixels [0:8];
    reg [8:0] byte_index;
    reg [8:0] pixel_index;
	 
	 integer i, idx;

    always @(posedge clk or posedge reset)
    begin
        if (reset)
        begin
            byte_index <= 0;
            pixel_index <= 0;
            // Initialize all line buffers to zero
            for (i = 0; i < LINEBUFFERLOG_LINE_WIDTH; i = i + 1)
            begin
                ln_buff_3_array[i] <= 0;
                ln_buff_2_array[i] <= 0;
                ln_buff_1_array[i] <= 0;
                ln_buff_0_array[i] <= 0;
            end
        end
        else
        begin
            if (load_line_buffer_3)
            begin
                ln_buff_3_array[byte_index] <= data_in;
                byte_index <= (byte_index == LINEBUFFERLOG_LINE_WIDTH - 1) ? 0 : byte_index + 1;
            end

            if (shift_line_buffer)
            begin
                // Shift line buffers
                for (i = 0; i < LINEBUFFERLOG_LINE_WIDTH; i = i + 1)
                begin
                    ln_buff_0_array[i] <= ln_buff_1_array[i];
                    ln_buff_1_array[i] <= ln_buff_2_array[i];
                    ln_buff_2_array[i] <= ln_buff_3_array[i];
                end
            end

            if (export_sobel_kernel)
            begin
                // Export Sobel kernel
					if (pixel_index == 0)
						begin
							reg_sobel_pixels[0] <= 0;
							reg_sobel_pixels[3] <= 0;
							reg_sobel_pixels[6] <= 0;
								
							reg_sobel_pixels[2] <= ln_buff_0_array[pixel_index + 1];
							reg_sobel_pixels[5] <= ln_buff_1_array[pixel_index + 1];
							reg_sobel_pixels[8] <= ln_buff_2_array[pixel_index + 1];
								
						end
					else if (pixel_index == LINEBUFFERLOG_LINE_WIDTH - 1)
						begin
							reg_sobel_pixels[2] <= 0;
							reg_sobel_pixels[5] <= 0;
							reg_sobel_pixels[8] <= 0;
							
							reg_sobel_pixels[0] <= ln_buff_0_array[pixel_index - 1];
							reg_sobel_pixels[3] <= ln_buff_1_array[pixel_index - 1];
							reg_sobel_pixels[6] <= ln_buff_2_array[pixel_index - 1];
						end
					else
						begin
							reg_sobel_pixels[0] <= ln_buff_0_array[pixel_index - 1];
							reg_sobel_pixels[2] <= ln_buff_0_array[pixel_index + 1];
								
							reg_sobel_pixels[3] <= ln_buff_1_array[pixel_index - 1];
							reg_sobel_pixels[5] <= ln_buff_1_array[pixel_index + 1];
								
							reg_sobel_pixels[6] <= ln_buff_2_array[pixel_index - 1];
							reg_sobel_pixels[8] <= ln_buff_2_array[pixel_index + 1];
						end

					reg_sobel_pixels[1] <= ln_buff_0_array[pixel_index];
					reg_sobel_pixels[4] <= ln_buff_1_array[pixel_index];
					reg_sobel_pixels[7] <= ln_buff_2_array[pixel_index];

					pixel_index <= (pixel_index == LINEBUFFERLOG_LINE_WIDTH - 1) ? 0 : pixel_index + 1;
            end
        end
    end

    genvar j, k;
    generate
        for (j = 0; j < 9; j = j + 1) begin : pack_bytes
            for (k = 0; k < 8; k = k + 1) begin : pack_bits
                assign sobel_pixels[j*8 + k] = reg_sobel_pixels[j][k];
            end
        end
    endgenerate
endmodule

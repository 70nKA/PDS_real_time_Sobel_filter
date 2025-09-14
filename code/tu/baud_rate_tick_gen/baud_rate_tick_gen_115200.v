`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    06:40:30 09/14/2025 
// Design Name: 
// Module Name:    baud_rate_tick_gen_115200 
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
module baud_rate_tick_gen_115200
	(
		input wire clk, reset,
		output wire tick
	);
	
	localparam BAUD_RATE_TICK_GEN_COUNT_NUMBER = 13'b11;
	localparam BAUD_RATE_TICK_GEN_COUNT_NORMAL = 3'b010;    // 11010
	localparam BAUD_RATE_TICK_GEN_COUNT_COMP1 = 3'b011;     // 11011
	localparam BAUD_RATE_TICK_GEN_COUNT_COMP2 = 3'b101;     // 11100

	localparam INIT_EDGE_COUNT = 4'b11;           // 4 - 1
	localparam FIRST_EDGE_COUNT = 4'b111;         // 8 - 1
	localparam SECOND_EDGE_COUNT = 8'b1100011;    // 100 - 1
	
	localparam [1:0]
		init = 2'b00,
		start_up = 2'b01,
		run = 2'b10;
		
	reg [1:0] state_reg, state_next;
	
	reg [2:0] counter_number_reg,
				 counter_number_next;
				  
	reg [2:0] counter1_reg,
				 counter1_next;

	reg [7:0] counter2_reg,
				 counter2_next;
	
	counter_binary_16b mod_counter_binary_16b
	(
		.clk(clk), .reset(reset),
		.max_count({BAUD_RATE_TICK_GEN_COUNT_NUMBER, counter_number_reg}),
		.max_tick(tick)
	);
	
	always@(posedge clk, posedge reset)
		if(reset)
			begin
				state_reg <= init;
				counter_number_reg <= BAUD_RATE_TICK_GEN_COUNT_NORMAL;
				counter1_reg <= 0;
				counter2_reg <= 0;
			end
		else
			begin
				state_reg <= state_next;
				counter_number_reg <= counter_number_next;
				counter1_reg <= counter1_next;
				counter2_reg <= counter2_next;
			end
	
	always@(*)
		begin
			state_next = state_reg;
			counter_number_next = counter_number_reg;
			counter1_next = counter1_reg;
			counter2_next = counter2_reg;
			
			if(tick)
				case(state_reg)
					init:
						begin
							counter2_next = counter2_reg + 1;
						
							if(counter1_reg == INIT_EDGE_COUNT)
								begin
									state_next = run;
									counter1_next = 0;
	
									counter_number_next = BAUD_RATE_TICK_GEN_COUNT_COMP1;
								end
							else
								counter1_next = counter1_reg + 1;
						end
					start_up:
						begin
							counter2_next = counter2_reg + 1;
							
							if(counter1_reg == INIT_EDGE_COUNT)
								begin
									state_next = run;
									counter1_next = 0;
	
									counter_number_next = BAUD_RATE_TICK_GEN_COUNT_COMP1;
								end
							else if(counter1_reg == 0)
								begin
									counter1_next = counter1_reg + 1;
									counter_number_next = BAUD_RATE_TICK_GEN_COUNT_NORMAL;
								end
							else
								counter1_next = counter1_reg + 1;
						end
					run:
						if(counter2_reg == SECOND_EDGE_COUNT)
							begin
								state_next = start_up;
								counter1_next = 0;
								counter2_next = 0;
	
								counter_number_next = BAUD_RATE_TICK_GEN_COUNT_COMP2;
							end
						else if(counter1_reg == FIRST_EDGE_COUNT)
							begin
								counter1_next = 0;
								counter2_next = counter2_reg + 1;
	
								counter_number_next = BAUD_RATE_TICK_GEN_COUNT_COMP1;
							end
						else if(counter1_reg == 0)
							begin
								counter1_next = counter1_reg + 1;
								counter2_next = counter2_reg + 1;

								counter_number_next = BAUD_RATE_TICK_GEN_COUNT_NORMAL;
							end
						else
							begin
								counter1_next = counter1_reg + 1;
								counter2_next = counter2_reg + 1;
							end
				endcase
		end
endmodule

// An Nguyen, Darren Do
// 1/11/2024
// EE 371
// Lab #1, Task #3

// HEX takes in 2 input logic clk and reset, in addition to a 5-bit input logic called "in". It
// uses the 5-bit input logic "in" to output 2 different 7-bit outputs called hex0 and hex1.
// clk represents the clock used and reset represents the input needed to reset the system to
// state 0. The 5-bit input logic "in" represents the counter keeping track of the number of 
// cars in the lot. The two hex outputs represent the LED number/character that will be displayed
// on the corresponding HEX display of the FPGA board. This module serves as a method for the output
// based on the counter to be more easily displayed on the 7-segement HEXs.

module HEX(clk, reset, in, hex0, hex1);
	input logic clk, reset; 
	input logic [4:0] in;
	output logic [6:0] hex0, hex1;
	// temp0 and temp1 are used to keep track of the output
	logic [6:0] temp0, temp1;
	
	// Assign 7 segnment display representation of decimal numbers to variables
	logic [6:0] zero = 7'b1000000, one=7'b1111001, two=7'b0100100, 
	three = 7'b0110000, four = 7'b0011001, five = 7'b0010010, six= 7'b0000010, 
	seven = 7'b1111000, eight= 7'b0000000, nine= 7'b0010000;
	
	// if reset is called, both hex0 and hex1 outputs the 7 segment representation of zero
	// otherwise, hex0 and hex1 outputs the corresponding 7 segment representation of the 
	// input 5 bit binary number (counter)
	always_ff @(posedge clk) begin
		if (reset) begin
			temp0 <= zero;
			temp1 <= zero;
		end
		else if (in == 5'b00000) begin
			temp0 <= zero;
			temp1 <= 7'b0101111;
		end
		else if (in == 5'b00001) begin
			temp0 <= one;
			temp1 <= zero;
		end
		else if (in == 5'b00010) begin
			temp0 <= two;
			temp1 <= zero;
		end
		else if (in == 5'b00011) begin
			temp0 <= three;
			temp1 <= zero;
		end
		else if (in == 5'b00100) begin
			temp0 <= four;
			temp1 <= zero;
		end
		else if (in == 5'b00101) begin
			temp0 <= five;
			temp1 <= zero;
		end
		else if (in == 5'b00110) begin
			temp0 <= six;
			temp1 <= zero;
		end
		else if (in == 5'b00111) begin
			temp0 <= seven;
			temp1 <= zero;
		end
		else if (in == 5'b01000) begin
			temp0 <= eight;
			temp1 <= zero;
		end
		else if (in == 5'b01001) begin
			temp0 <= nine;
			temp1 <= zero;
		end
		else if (in == 5'b01010) begin
			temp0 <= zero;
			temp1 <= one;
		end
		else if (in == 5'b01011) begin
			temp0 <= one;
			temp1 <= one;
		end
		else if (in == 5'b01100) begin
			temp0 <= two;
			temp1 <= one;
		end
		else if (in == 5'b01101) begin
			temp0 <= three;
			temp1 <= one;
		end
		else if (in == 5'b01110) begin
			temp0 <= four;
			temp1 <= one;
		end
		else if (in == 5'b01111) begin
			temp0 <= five;
			temp1 <= one;
		end
		else if (in == 5'b10000) begin
			temp0 <= six;
			temp1 <= one;
		end
		else if (in == 5'b10001) begin
			temp0 <= seven;
			temp1 <= one;
		end
		else if (in == 5'b10010) begin
			temp0 <= eight;
			temp1 <= one;
		end
		else if (in == 5'b10011) begin
			temp0 <= nine;
			temp1 <= one;
		end
		else if (in == 5'b10100) begin
			temp0 <= zero;
			temp1 <= two;
		end
		else if (in == 5'b10101) begin
			temp0 <= one;
			temp1 <= two;
		end
		else if (in == 5'b10110) begin
			temp0 <= two;
			temp1 <= two;
		end
		else if (in == 5'b10111) begin
			temp0 <= three;
			temp1 <= two;
		end
		else if (in == 5'b11000) begin
			temp0 <= four;
			temp1 <= two;
		end
		else if (in == 5'b11001) begin
			temp0 <= five;
			temp1 <= two;
		end
	end
	
	// used a temp variable to keep track of the LED output before assigning it to the
	// final output.
	assign hex0 = temp0;
	assign hex1 = temp1;
	
endmodule 

// HEX_testbench tests the functionality of the HEX module, making sure that the HEXs display
// the correct numbers, in addition to edge cases such as making sure the HEXs don't output 
// any number exceeding 25 or lower than 0. 
module HEX_testbench();
	logic clk, reset; 
	logic [4:0] in;
	logic [6:0] hex0, hex1; 
	
	HEX dut (.clk, .reset, .in, .hex0, .hex1);
	
	parameter clock_period = 100; 
	
	initial begin 
		clk <= 0; 
		forever #(clock_period /2) clk <= ~clk;
		
	end
	
	initial begin  
		reset <= 1; 			@(posedge clk);
		reset <= 0; in <= 5'b00000;	@(posedge clk); 
		for (int i = 1; i < 27; i = i + 1) begin
						in <= in + 5'b00001; @(posedge clk);
		end 
		for (int i = 27; i > 0; i--) begin
						in <= in - 5'b00001; @(posedge clk);
		end
		$stop;
	end	
endmodule 


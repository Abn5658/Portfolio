
module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, SW, LEDR, V_GPIO);

	// define ports
	input  logic CLOCK_50;
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	input  logic [3:0] KEY;
	input  logic [9:0] SW;
	output logic [9:0] LEDR;
	inout  logic [35:23] V_GPIO;

   // Initialize HEX
   assign HEX0 = '1;
	assign HEX1 = '1;
	assign HEX2 = '1;
	assign HEX3 = '1;
	assign HEX4 = '1;
	assign HEX5 = '1;

	// FPGA output
	assign V_GPIO[26] = SW[0];	// LED parking 1
	assign V_GPIO[27] = SW[1];	// LED parking 2
	assign V_GPIO[32] = SW[2];	// LED parking 3
	assign V_GPIO[34] = SW[3];	// LED full
	assign V_GPIO[31] = SW[4];	// Open entrance
	assign V_GPIO[33] = SW[5];	// Open exit

	// FPGA input
	assign LEDR[0] = V_GPIO[28];	// Presence parking 1
	assign LEDR[1] = V_GPIO[29];	// Presence parking 2
	assign LEDR[2] = V_GPIO[30];	// Presence parking 3
	assign LEDR[3] = V_GPIO[23];	// Presence entrance
	assign LEDR[4] = V_GPIO[24];	// Presence exit

endmodule  // DE1_SoC

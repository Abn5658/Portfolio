module DE1_SoC (CLOCK_50, HEX0, HEX1, KEY, GPIO_1, SW, LEDR);
	input logic 		 CLOCK_50; // 50MHz clock.
	output logic [6:0] HEX0, HEX1;
	output logic [35:0] GPIO_1;
	input logic  [3:0] KEY; 
	input logic  [9:0] SW;
	output logic [9:0] LEDR;
	logic carryover, carryover1;
	logic reset, pause;
	logic out0, out1; //for user_input
	logic stable0, stable1; //for ff
	logic [3:0] random;
	// Generate clk off of CLOCK_50, whichClock picks rate.
	logic [31:0] div_clk;
	
	assign reset = SW[9];
	assign pause = SW[0];
	assign LEDR = '0; 
	parameter whichClock = 14; // 0.75 Hz clock
	clock_divider cdiv (.clock(CLOCK_50),
							  .reset(reset),
							  .divided_clocks(div_clk));

	// Clock selection; allows for easy switching between simulation and board
	// clocks
	logic clkSelect;
	// Uncomment ONE of the following two lines depending on intention

	assign clkSelect = CLOCK_50; 			 // for simulation
	//assign clkSelect = div_clk[whichClock]; // for board
	
	logic [15:0][15:0] RedPixels; 
	logic [15:0][15:0] GrnPixels;
	int position; 
	int shift;
	logic gameover; 
	logic point;
	LEDDriver Driver (.clk(clkSelect), .rst(reset), .EnableCount(1'b1), .RedPixels, .GrnPixels, .GPIO_1);
	
	flipFlop ff0 (.clk(clkSelect), .reset(reset), .in(~KEY[0]), .out(stable0));
	user_input k0 (.clock(clkSelect), .reset(reset), .in(stable0), .out(out0));
	bird b0 (.clk(clkSelect), .reset(reset), .key(out0), .gameover(gameover), .position, .pause);
	LFSR l0 (.clk(clkSelect), .reset(reset), .gameover, .out(random), .pause);
	pipeshift ps0 (.clk(clkSelect), .reset(reset), .gameover, .shift, .pause);
   die d0 (.clk(clkSelect), .reset(reset), .in_red(RedPixels), .in_green(GrnPixels), .point(point), .gameover(gameover));
	flipFlop ff1 (.clk(clkSelect), .reset(reset), .in(point), .out(stable1));
	user_input k1 (.clock(clkSelect), .reset(reset), .in(stable1), .out(out1));
	hex h0 (.clk(clkSelect), .reset(reset), .increment(out1), .display(HEX0), .cycle(carryover));
	hex h1 (.clk(clkSelect), .reset(reset), .increment(carryover), .display(HEX1), .cycle(carryover1));
	
	always_comb begin 
		RedPixels = '0;
		RedPixels[position][14] = 1'b1;
	end
	always_comb begin
		GrnPixels='0;
				if (random == 4'b0000) begin 
					GrnPixels[0][shift] = 1'b0;
					GrnPixels[1][shift] = 1'b0;
					GrnPixels[2][shift] = 1'b0;
					GrnPixels[3][shift] = 1'b0;
					GrnPixels[4][shift] = 1'b0;
					GrnPixels[5][shift] = 1'b0;
					GrnPixels[6][shift] = 1'b0;
					GrnPixels[7][shift] = 1'b0;
					GrnPixels[8][shift] = 1'b0;
					GrnPixels[9][shift] = 1'b0;
					GrnPixels[10][shift] = 1'b0;
					GrnPixels[11][shift] = 1'b0;
					GrnPixels[12][shift] = 1'b0;
					GrnPixels[13][shift] = 1'b0;
					GrnPixels[14][shift] = 1'b0;
					GrnPixels[15][shift] = 1'b0;
				end
				if(random == 4'b0001 | random == 4'b0100) begin
					GrnPixels[0][shift] = 1'b1;
					GrnPixels[1][shift] = 1'b1;
					GrnPixels[2][shift] = 1'b1;
					GrnPixels[3][shift] = 1'b0;
					GrnPixels[4][shift] = 1'b0;
					GrnPixels[5][shift] = 1'b0;
					GrnPixels[6][shift] = 1'b1;
					GrnPixels[7][shift] = 1'b1;
					GrnPixels[8][shift] = 1'b1;
					GrnPixels[9][shift] = 1'b1;
					GrnPixels[10][shift] = 1'b1;
					GrnPixels[11][shift] = 1'b1;
					GrnPixels[12][shift] = 1'b1;
					GrnPixels[13][shift] = 1'b1;
					GrnPixels[14][shift] = 1'b1;
					GrnPixels[15][shift] = 1'b1;
				end
				else if(random == 4'b0011 | random == 4'b0111) begin
					GrnPixels[0][shift] = 1'b1;
					GrnPixels[1][shift] = 1'b1;
					GrnPixels[2][shift] = 1'b1;
					GrnPixels[3][shift] = 1'b1;
					GrnPixels[4][shift] = 1'b0;
					GrnPixels[5][shift] = 1'b0;
					GrnPixels[6][shift] = 1'b0;
					GrnPixels[7][shift] = 1'b1;
					GrnPixels[8][shift] = 1'b1;
					GrnPixels[9][shift] = 1'b1;
					GrnPixels[10][shift] = 1'b1;
					GrnPixels[11][shift] = 1'b1;
					GrnPixels[12][shift] = 1'b1;
					GrnPixels[13][shift] = 1'b1;
					GrnPixels[14][shift] = 1'b1;
					GrnPixels[15][shift] = 1'b1;
				end
				else if(random == 4'b0010 | random == 4'b0110) begin
					GrnPixels[0][shift] = 1'b1;
					GrnPixels[1][shift] = 1'b1;
					GrnPixels[2][shift] = 1'b1;
					GrnPixels[3][shift] = 1'b1;
					GrnPixels[4][shift] = 1'b1;
					GrnPixels[5][shift] = 1'b0;
					GrnPixels[6][shift] = 1'b0;
					GrnPixels[7][shift] = 1'b0;
					GrnPixels[8][shift] = 1'b1;
					GrnPixels[9][shift] = 1'b1;
					GrnPixels[10][shift] = 1'b1;
					GrnPixels[11][shift] = 1'b1;
					GrnPixels[12][shift] = 1'b1;
					GrnPixels[13][shift] = 1'b1;
					GrnPixels[14][shift] = 1'b1;
					GrnPixels[15][shift] = 1'b1;
				end
				else if(random == 4'b1000) begin
					GrnPixels[0][shift] = 1'b1;
					GrnPixels[1][shift] = 1'b1;
					GrnPixels[2][shift] = 1'b1;
					GrnPixels[3][shift] = 1'b1;
					GrnPixels[4][shift] = 1'b1;
					GrnPixels[5][shift] = 1'b1;
					GrnPixels[6][shift] = 1'b0;
					GrnPixels[7][shift] = 1'b0;
					GrnPixels[8][shift] = 1'b0;
					GrnPixels[9][shift] = 1'b1;
					GrnPixels[10][shift] = 1'b1;
					GrnPixels[11][shift] = 1'b1;
					GrnPixels[12][shift] = 1'b1;
					GrnPixels[13][shift] = 1'b1;
					GrnPixels[14][shift] = 1'b1;
					GrnPixels[15][shift] = 1'b1;
				end
				else if(random == 4'b1110 | random == 4'b0101) begin
					GrnPixels[0][shift] = 1'b1;
					GrnPixels[1][shift] = 1'b1;
					GrnPixels[2][shift] = 1'b1;
					GrnPixels[3][shift] = 1'b1;
					GrnPixels[4][shift] = 1'b1;
					GrnPixels[5][shift] = 1'b1;
					GrnPixels[6][shift] = 1'b1;
					GrnPixels[7][shift] = 1'b0;
					GrnPixels[8][shift] = 1'b0;
					GrnPixels[9][shift] = 1'b0;
					GrnPixels[10][shift] = 1'b1;
					GrnPixels[11][shift] = 1'b1;
					GrnPixels[12][shift] = 1'b1;
					GrnPixels[13][shift] = 1'b1;
					GrnPixels[14][shift] = 1'b1;
					GrnPixels[15][shift] = 1'b1;
				end
				else if(random == 4'b1010) begin
					GrnPixels[0][shift] = 1'b1;
					GrnPixels[1][shift] = 1'b1;
					GrnPixels[2][shift] = 1'b1;
					GrnPixels[3][shift] = 1'b1;
					GrnPixels[4][shift] = 1'b1;
					GrnPixels[5][shift] = 1'b1;
					GrnPixels[6][shift] = 1'b1;
					GrnPixels[7][shift] = 1'b1;
					GrnPixels[8][shift] = 1'b0;
					GrnPixels[9][shift] = 1'b0;
					GrnPixels[10][shift] = 1'b0;
					GrnPixels[11][shift] = 1'b1;
					GrnPixels[12][shift] = 1'b1;
					GrnPixels[13][shift] = 1'b1;
					GrnPixels[14][shift] = 1'b1;
					GrnPixels[15][shift] = 1'b1;
				end
				else if(random == 4'b1001 | random == 4'b1100) begin
					GrnPixels[0][shift] = 1'b1;
					GrnPixels[1][shift] = 1'b1;
					GrnPixels[2][shift] = 1'b1;
					GrnPixels[3][shift] = 1'b1;
					GrnPixels[4][shift] = 1'b1;
					GrnPixels[5][shift] = 1'b1;
					GrnPixels[6][shift] = 1'b1;
					GrnPixels[7][shift] = 1'b1;
					GrnPixels[8][shift] = 1'b1;
					GrnPixels[9][shift] = 1'b0;
					GrnPixels[10][shift] = 1'b0;
					GrnPixels[11][shift] = 1'b0;
					GrnPixels[12][shift] = 1'b1;
					GrnPixels[13][shift] = 1'b1;
					GrnPixels[14][shift] = 1'b1;
					GrnPixels[15][shift] = 1'b1;
				end
				else begin
					GrnPixels[0][shift] = 1'b1;
					GrnPixels[1][shift] = 1'b1;
					GrnPixels[2][shift] = 1'b1;
					GrnPixels[3][shift] = 1'b1;
					GrnPixels[4][shift] = 1'b1;
					GrnPixels[5][shift] = 1'b1;
					GrnPixels[6][shift] = 1'b1;
					GrnPixels[7][shift] = 1'b1;
					GrnPixels[8][shift] = 1'b1;
					GrnPixels[9][shift] = 1'b1;
					GrnPixels[10][shift] = 1'b0;
					GrnPixels[11][shift] = 1'b0;
					GrnPixels[12][shift] = 1'b0;
					GrnPixels[13][shift] = 1'b1;
					GrnPixels[14][shift] = 1'b1;
					GrnPixels[15][shift] = 1'b1;
				end
	end
endmodule 

module DE1_SoC_testbench();
	logic 		 CLOCK_50;
	logic [6:0] HEX0, HEX1;
	logic [35:0] GPIO_1;
	logic  [3:0] KEY; 
	logic  [9:0] SW;
	logic [9:0] LEDR; 
	logic [15:0][15:0] RedPixels; 
	logic [15:0][15:0] GrnPixels; 
	
	DE1_SoC dut (.CLOCK_50, .HEX0, .HEX1, .KEY, .GPIO_1, .SW, .LEDR);
	
	parameter CLOCK_PERIOD = 100;
	initial begin 
     CLOCK_50 <= 0;
     forever #(CLOCK_PERIOD / 2) CLOCK_50 <= ~CLOCK_50; // forever toggle the clock
	end
	
	initial begin
//		SW[9] <= 1; @(posedge CLOCK_50);
//		SW[9] <= 0; @(posedge CLOCK_50);
		repeat(10000) @(posedge CLOCK_50); begin
		SW[9] <= 1; @(posedge CLOCK_50);
		SW[9] <= 0; @(posedge CLOCK_50);
		KEY[0] <= 1; repeat(3) @(posedge CLOCK_50);
		KEY[0] <= 0; repeat(5) @(posedge CLOCK_50);
		KEY[0] <= 1; repeat(1) @(posedge CLOCK_50);
		KEY[0] <= 0; repeat(2) @(posedge CLOCK_50);
		KEY[0] <= 1; repeat(4) @(posedge CLOCK_50);
		KEY[0] <= 0; repeat(2) @(posedge CLOCK_50);
		KEY[0] <= 1; repeat(3) @(posedge CLOCK_50);
		KEY[0] <= 0; repeat(4) @(posedge CLOCK_50);
		end
//		SW[9] <= 1; @(posedge CLOCK_50);
//		SW[9] <= 0; repeat(3) @(posedge CLOCK_50);
		repeat(10000) @(posedge CLOCK_50); begin
		SW[9] <= 1; @(posedge CLOCK_50);
		SW[9] <= 0; repeat(3) @(posedge CLOCK_50);
		KEY[0] <= 0; repeat(8) @(posedge CLOCK_50);
		KEY[0] <= 1; repeat(2) @(posedge CLOCK_50);
		KEY[0] <= 0; repeat(1) @(posedge CLOCK_50);
		KEY[0] <= 1; repeat(5) @(posedge CLOCK_50);
		KEY[0] <= 0; repeat(4) @(posedge CLOCK_50);
		SW[0] <= 1; repeat(3) @(posedge CLOCK_50);
		SW[0] <= 0; repeat(3) @(posedge CLOCK_50);
		KEY[0] <= 1; repeat(2) @(posedge CLOCK_50);
		KEY[0] <= 0; repeat(1) @(posedge CLOCK_50);
		KEY[0] <= 1; repeat(4) @(posedge CLOCK_50);
		KEY[0] <= 0; repeat(1) @(posedge CLOCK_50);
		end
	$stop;
end 
	
endmodule 
module die(clk, reset, in_red, in_green, point, gameover); 
	input logic clk, reset;
	input logic [15:0][15:0] in_red, in_green;
	output logic point, gameover;
	
	always_ff @ (posedge clk) begin
		if (in_green[0][14] == 1'b0 
			& in_green[1][14] == 1'b0 
			& in_green[2][14] == 1'b0 
			& in_green[3][14] == 1'b0 
			& in_green[4][14] == 1'b0 
			& in_green[5][14] == 1'b0 
			& in_green[6][14] == 1'b0 
			& in_green[7][14] == 1'b0 
			& in_green[8][14] == 1'b0 
			& in_green[9][14] == 1'b0 
			& in_green[10][14] == 1'b0 
			& in_green[11][14] == 1'b0 
			& in_green[12][14] == 1'b0 
			& in_green[13][14] == 1'b0 
			& in_green[14][14] == 1'b0 
			& in_green[15][14] == 1'b0) begin
				point <= 1'b0;
				gameover <= 1'b0;
		end
		else if ((in_green[0][14] == 1'b1 & in_red[0][14] == 1'b1)
			| (in_green[1][14] == 1'b1 & in_red[1][14] == 1'b1)
			| (in_green[2][14] == 1'b1 & in_red[2][14] == 1'b1)
			| (in_green[3][14] == 1'b1 & in_red[3][14] == 1'b1)
			| (in_green[4][14] == 1'b1 & in_red[4][14] == 1'b1)
			| (in_green[5][14] == 1'b1 & in_red[5][14] == 1'b1)
			| (in_green[6][14] == 1'b1 & in_red[6][14] == 1'b1)
			| (in_green[7][14] == 1'b1 & in_red[7][14] == 1'b1)
			| (in_green[8][14] == 1'b1 & in_red[8][14] == 1'b1)
			| (in_green[9][14] == 1'b1 & in_red[9][14] == 1'b1)
			| (in_green[10][14] == 1'b1 & in_red[10][14] == 1'b1)
			| (in_green[11][14] == 1'b1 & in_red[11][14] == 1'b1)
			| (in_green[12][14] == 1'b1 & in_red[12][14] == 1'b1)
			| (in_green[13][14] == 1'b1 & in_red[13][14] == 1'b1)
			| (in_green[14][14] == 1'b1 & in_red[14][14] == 1'b1)
			| (in_green[15][14] == 1'b1 & in_red[15][14] == 1'b1))begin
				gameover <= 1'b1;
				point <= 1'b0;
		end
		else begin 
			point <= 1'b1;
			gameover <= 1'b0;
		end
		
	end
endmodule  

module die_testbench();
	logic clk, reset;
	logic [15:0][15:0] in_red, in_green;
	logic point, gameover;

	die dut (.clk, .reset, .in_red, .in_green, .point, .gameover);

	parameter CLOCK_PERIOD = 100;
	initial begin
		  clk <= 0;
		  forever #(CLOCK_PERIOD / 2) clk <= ~clk;
	end

	initial begin
		in_green <= '0; in_red <= '0;
		reset <= 1; @(posedge clk);
		reset <= 0; @(posedge clk);
		in_green[2][14] <= 1'b1; in_red[2][14] <= 1'b1; repeat(3) @(posedge clk);
		in_green <= '0; in_red <= '0;
		reset <= 1; @(posedge clk);
		reset <= 0; @(posedge clk);
		in_green[11][14] <= 1'b1; in_red[11][14] <= 1'b1; repeat(3) @(posedge clk);
		in_green <= '0; in_red <= '0;
		reset <= 1; @(posedge clk);
		reset <= 0; @(posedge clk);
		in_green[12][14] <= 1'b1; in_red[4][14] <= 1'b1; repeat(3) @(posedge clk);
		in_green <= '0; in_red <= '0;
		reset <= 1; @(posedge clk);
		reset <= 0; @(posedge clk);
		in_green[2][14] <= 1'b1; in_red[9][14] <= 1'b1; repeat(3) @(posedge clk);
		in_green <= '0; in_red <= '0;
		reset <= 1; @(posedge clk);
		reset <= 0; @(posedge clk);
		in_green[9][7] <= 1'b1; in_red[11][14] <= 1'b1; repeat(3) @(posedge clk);
		reset <= 1; @(posedge clk);
		reset <= 0; @(posedge clk);
	$stop;
	end
endmodule 
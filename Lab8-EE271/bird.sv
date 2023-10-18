module bird(clk, reset, key, gameover, position, pause);
	input logic clk, reset, key, gameover, pause;
	output int position;
	
	int gravity; 
	
	always_ff @ (posedge clk) begin
		if (reset) begin 
			position <= 7;
			gravity <= 0;
		end
		
		else begin
			if (gameover | pause) begin
				position <= position;
				gravity <= 0;
			end
			else if (position == 15 & ~key) begin
				position <= 15;
			end
			else if (position == 0 & key) begin
				position <= 0;
			end
			else if (key) begin
				position <= position - 1;
			end
			else if (~key) begin 
				gravity <= gravity + 1;
				if (gravity % 400 == 0) begin
					position <= position + 1;
				end
			end
			
		end
	end
endmodule 

module bird_testbench();
	logic clk, reset, key, gameover, pause;
	int position;
	
	bird dut (.clk, .reset, .key, .gameover, .position, .pause);	
	
	parameter CLOCK_PERIOD = 100;
	initial begin 
     clk <= 0;
     forever #(CLOCK_PERIOD / 2) clk <= ~clk; 
	end
	
	initial begin
		reset <= 1; @(posedge clk);
		reset <= 0; @(posedge clk);
		repeat (20) begin 
			key <= 1; @(posedge clk);
			key <= 0; repeat(3) @(posedge clk);
			key <= 1; @(posedge clk);
			key <= 0; repeat (6) @(posedge clk);
			key <= 1; @(posedge clk);
		end 
		
		gameover <= 1; @(posedge clk);
		key <= 1; @(posedge clk);
		key <= 0; repeat(3) @(posedge clk);
		key <= 1; @(posedge clk);
		key <= 0; repeat(3) @(posedge clk);
		reset <= 1; @(posedge clk);
		reset <= 0; @(posedge clk);
		gameover <= 1; @(posedge clk);
	$stop;
	end
	
endmodule 
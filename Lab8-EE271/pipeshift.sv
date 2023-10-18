module pipeshift(clk, reset, gameover, shift, pause);
	input logic clk, reset, gameover, pause;
	output int shift;
	
	int count;
	
	always_ff @ (posedge clk) begin
		if (reset) begin
			shift <= 0;
			count <= 0;
		end
		else begin 
			if (gameover | pause) begin 
				shift <= shift;
			end
			else if (shift == 16) begin 
				shift <= 0;
			end
			else begin 
				count <= count + 1;
				if (count % 200 == 0) begin 
					shift <= shift + 1;
				end
			end
		end
	end 
	

endmodule 

module pipeshift_testbench();
	logic clk, reset, gameover, pause;
	int shift;
	int count;
	
	pipeshift dut (.clk, .reset, .gameover, .shift, .pause);
	
	parameter CLOCK_PERIOD = 100;
	initial begin 
     clk <= 0;
     forever #(CLOCK_PERIOD / 2) clk <= ~clk; 
	end
	
	initial begin
		reset <= 1; @(posedge clk);		
		reset <= 0; @(posedge clk);
		gameover <= 1; repeat (400) @(posedge clk);
		gameover <= 0; repeat (3500) @(posedge clk);
		pause <= 1; repeat (400) @(posedge clk);
		gameover <= 1; repeat (400) @(posedge clk);
		gameover <= 0; repeat (3500) @(posedge clk);
		pause <= 0; repeat (400) @(posedge clk);
		reset <= 1; @(posedge clk);		
		reset <= 0; @(posedge clk);
		gameover <= 1; repeat (150) @(posedge clk);
		gameover <= 0; repeat (800) @(posedge clk);
		$stop;
	end
endmodule 
	
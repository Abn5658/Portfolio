module LFSR (clk, reset, gameover, out, pause);
	input logic clk, reset, gameover, pause; 
	output logic [3:0] out;
	int counter;
	
	always_ff @(posedge clk)
		begin 
			if (gameover | pause) begin
				out <= out;
				counter <= counter;
			end
			else if (reset) begin
				out <= 4'b0000;
				counter <= 0; 
			end
			else if (counter % 3200 != 0) begin 
				counter <= counter + 1;
			end
			else begin 
				out <= {~(out[0]^out[3]), out[3:1]};
				counter <= counter +1;
			end
		end 
endmodule 

module LFSR_testbench();
	logic clk, reset, gameover, pause; 
	logic [3:0] out;
	int counter;
	
	LFSR dut (.clk, .reset, .gameover, .out, .pause);
		
	parameter CLOCK_PERIOD = 100;
	initial begin 
     clk <= 0;
     forever #(CLOCK_PERIOD / 2) clk <= ~clk; 
	end
	
	initial begin 
		reset <= 1; repeat(2) @(posedge clk);		
		reset <= 0; repeat (16000) @(posedge clk);
		gameover <= 1; @(posedge clk);
		gameover <= 0; @(posedge clk);
		reset <= 1; repeat(2) @(posedge clk);		
		reset <= 0; repeat (16000) @(posedge clk);
		$stop;
	end
endmodule

		
	
	
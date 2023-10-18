module flipFlop (clk, reset, in, out);

input logic clk, reset;
input logic in;
output logic out;

logic out_ff1;

	always_ff @(posedge clk) begin
		out_ff1 <= in;
	end
	
	always_ff @(posedge clk) begin
		out <= out_ff1;
	end
endmodule 

module flipFlop_testbench();
	logic clk, reset;
	logic in;
	logic out;
	
	flipFlop dut (.clk, .reset, .in, .out);
	
	parameter CLOCK_PERIOD = 100;
	initial begin 
     clk <= 0;
     forever #(CLOCK_PERIOD / 2) clk <= ~clk; 
	end
	initial begin
		in <= 1'b0; reset <= 1'b1; repeat(4) @(posedge clk);
		reset <= 1'b0;         @(posedge clk);
		in <= 1'b1;  repeat(2) @(posedge clk);
		in <= 1'b0;  repeat(4) @(posedge clk);
		in <= 1'b1;  repeat(6) @(posedge clk);
		in <= 1'b0;  repeat(4) @(posedge clk);
		in <= 1'b1;  repeat(1) @(posedge clk);
		in <= 1'b0;  repeat(3) @(posedge clk);
		$stop;
	end

endmodule 
module hex(clk, reset, increment, display, cycle);
	input logic clk, reset, increment;
	output logic cycle;
	output logic [6:0] display;
	
	enum logic [6:0] {zero = 7'b1000000, one=7'b1111001, two=7'b0100100, 
							three = 7'b0110000, four = 7'b0011001, five = 7'b0010010, six= 7'b0000010, 
							seven = 7'b1111000, eight= 7'b0000000, nine= 7'b0010000} ps, ns;
	
	always_comb begin 
		if (increment) begin
			case(ps)
				zero: ns = one;
				one: ns = two;
				two: ns = three;
				three: ns = four;
				four: ns = five;
				five: ns = six;
				six: ns = seven;
				seven: ns = eight;
				eight: ns = nine;
				nine: ns = zero;
			default: ns = zero;
			endcase
		end
		else begin
			ns = ps;
		end
			
		display = ps;
		cycle = (ps == nine) & increment;
	
	
	end
	
	always_ff @(posedge clk) begin
		if (reset) 
			ps <= zero;
		else 
			ps <= ns;
	end
	
endmodule 

module hex_testbench();
  logic clk, reset, increment, cycle;
  logic [6:0] display;

  hex dut (.clk, .reset, .increment, .display, .cycle);

	parameter CLOCK_PERIOD = 100;
	initial begin 
     clk <= 0;
     forever #(CLOCK_PERIOD / 2) clk <= ~clk; 
	end
	

  initial begin
    reset = 1; @(posedge clk); 
    reset = 0; @(posedge clk);
    increment = 1;  repeat(30) @(posedge clk);
    increment = 0;  repeat(10) @(posedge clk);
	 increment = 1; 				 @(posedge clk);
	 increment = 0;  repeat(5)  @(posedge clk);
	 reset = 1; @(posedge clk); 
    reset = 0; @(posedge clk);
	 increment = 1; 				 @(posedge clk);
	 increment = 0;  repeat(5)  @(posedge clk);
    $stop;
  end
endmodule

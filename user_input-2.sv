module user_input(clock, reset, in, out);
	input logic in, clock, reset;
	output logic out;
	enum logic {off, on} ps, ns;

	always_comb begin
		
		case(ps)
		
		on: begin
				if(in) begin
				out = off;
				ns = on;
				end 
				else begin 
				out = 1'b0;
				ns = off;
				end
				end
		
		off: begin
			  if(in) begin 
			  ns = on;
				out = 1'b1;
				end
			  else begin 
					ns = off;
					out = 1'b0;
					end
			  end
		
		default: begin 
					ns = off;
					out = off;
					end
	endcase
	end

	
	always_ff @(posedge clock) begin
		if (reset) begin
			ps <= off;
		end 
		else begin
			ps <= ns;
		end

	end

endmodule

module user_input_testbench;
	logic in, clock, reset;
	logic out;
	
	user_input dut (.clock, .reset, .in, .out);
	
	parameter CLOCK_PERIOD = 100;
	initial begin 
     clock <= 0;
     forever #(CLOCK_PERIOD / 2) clock <= ~clock; 
	end

	initial begin
		in <= 1'b0; reset <= 1'b1; repeat(4) @(posedge clock);
		reset <= 1'b0;         @(posedge clock);
		in <= 1'b1;  repeat(2) @(posedge clock);
		in <= 1'b0;  repeat(4) @(posedge clock);
		in <= 1'b1;  repeat(6) @(posedge clock);
		in <= 1'b0;  repeat(4) @(posedge clock);
		in <= 1'b1;  repeat(1) @(posedge clock);
		in <= 1'b0;  repeat(3) @(posedge clock);
		$stop;
	end

endmodule


// An Nguyen, Darren Do
// 3/7/24
// EE 371
// LAB 6, task#2
// 
//	Inputs: 
// clk: Timer to indicate the functionality of our module. 
// reset: Resets our counter back to '0'.
// in: Indicates that a car has entered our parking lot.
// full: Indicates that no parking spots are open, nothing should be counted in this case
//
// Outputs:
//	16-bit car_in: Outputs the total number of cars in our parking lot beginning at hour 
// 					'0' to hour '7'.
//
// Logic:
// 16-bit car_in_internal: Keeps track of the number of cars in our parking lot beginning at hour 
// 					'0' to hour '7'.
module car_Tracker(clk, reset, in, full, car_in);
	input logic clk, reset, in, full;
	output logic [15:0] car_in;
	logic [15:0] car_in_internal;
	
	// if reset, the car count goes to '0'.
	// else, we keep couting when a car enters.
	always_ff @(posedge clk) begin 
		if (reset) 
			car_in_internal <= 0; 
		else begin 
			if (in && ~full)
				car_in_internal <=  car_in_internal + 1; 
		end
	end
	
	assign car_in = car_in_internal;
endmodule 


// This testbench tests for 2 different cases:
// 1.) Cars are coming in and the parking lot is not full.
// 	 In this case, the counter should go up.
// 2.) Cars are coming in and the parking lot is full.
//     In this case, the counter should NOT go up.
module car_Tracker_testbench();
	logic clk, reset, in, full;
	logic [15:0] car_in; 
	
	car_Tracker dut1(.*);
	
	parameter clock_period = 100; 
	initial begin 
		clk <= 0; 
		forever #(clock_period /2) clk <= ~clk;
		
	end
	
	initial begin 
		reset <= 1; in <= 0; full <= 0; @(posedge clk);
		reset <= 1; @(posedge clk);
		reset <= 0; @(posedge clk);
		// full is off, it should count
		for (int i = 0; i < 5; i++) begin 
			in <= 1; @(posedge clk); 
		end
		// full is off, it should NOT count
		full <=  1; @(posedge clk); 
		for (int i = 0; i < 5; i++) begin 
			in <= 1; @(posedge clk); 
		end
		$stop;
	end	

endmodule 



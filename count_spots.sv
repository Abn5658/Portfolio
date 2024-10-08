// An Nguyen, Darren Do
// 3/7/24
// EE 371
// LAB6, Task#2
// 
// Inputs: 
// car1: Signals whether parking spot 1 is taken.
// car2: Signals whether parking spot 2 is taken.
// car3: Signals whether parking spot 3 is taken.
//
// Output:
// 2-bit spot_left: Returns how many spots are available in the parking lot. 
//
// Logic: 
// 2-bit current_occ: intermediate logic to keep track of how many cars are present. 
// Summary: Module 'count_spots' is designed to keep track of how many spots are currently
// 			available in our 3D parking lot.
module count_spots(car1, car2, car3, spot_left); 
   input logic car1, car2, car3;
	output logic [1:0] spot_left; 
	logic [1:0] current_occ;
	
	// logic to determine how many cars are present
	// '0' represents open spot
	// '1' represents parked spot
   always_comb begin 
        case({car1, car2, car3}) 
            3'b111: current_occ = 0;
            3'b101: current_occ = 1; 
            3'b000: current_occ = 3; 
				3'b010: current_occ = 2;
            3'b011: current_occ = 1; 
            3'b110: current_occ = 1; 
            3'b001: current_occ = 2; 
            3'b100: current_occ = 2; 
		  endcase
   end
    
	// Assign intermediate logic to final output logic 
   assign spot_left = current_occ;
	
endmodule 

// This Testbench is testing every single combination of car parking pattern
// to ensure that our counter can account for all possible cases in terms of cars 
// entering the parking lot to determine how many parking spots are left.
module count_spots_testbench();
	logic clk;
	logic car1, car2, car3; 
	logic [1:0] spot_left; 
	
	count_spots dut1(.*);
	
	parameter clock_period = 100; 
	initial begin 
		clk <= 0; 
		forever #(clock_period /2) clk <= ~clk;
		
	end
	
	// testing all combinations of car entry
	// 1, 2, 3 spots available in different configurations
	initial begin 
		car1 <= 0; car2 <=0; car3 <=0; @(posedge clk);
		car1 <= 0; car2 <=0; car3 <=1; @(posedge clk);
		car1 <= 0; car2 <=1; car3 <=0; @(posedge clk);
		car1 <= 0; car2 <=1; car3 <=1; @(posedge clk);
		car1 <= 1; car2 <=0; car3 <=0; @(posedge clk);
		car1 <= 1; car2 <=0; car3 <=1; @(posedge clk);
		car1 <= 1; car2 <=1; car3 <=0; @(posedge clk);
		car1 <= 1; car2 <=1; car3 <=1; @(posedge clk);
		$stop;
	end	
endmodule 
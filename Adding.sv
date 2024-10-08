module Adding (
//    input clk,
//    input reset,
    input [4:0] in1, in2,
    output reg [5:0] out
);
    
    reg [5:0] count;

//    always_ff @(posedge clk) begin
//        if (reset) begin
//            count <= 6'b000000;
//        end else begin
//            count <= in1 + in2;
//        end
//    end

    assign out = in1 + in2;

endmodule

module Adding_testbench();

//    logic clk, reset;
    logic [4:0] in1, in2;
    logic [5:0] out;

    Adding dut (
        .clk(clk),
        .reset(reset),
        .in1(in1),
        .in2(in2),
        .out(out)
    );

    initial
	 for (int i = 0; i < 16; i = i + 1 ) begin
		 in1 = i; #10;
		 in2 = i; #10;
		 end
endmodule

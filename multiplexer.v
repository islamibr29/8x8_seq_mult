module mux4 (
input [3:0] mux_in_a, mux_in_b,
input [1:0] mux_sel,
output reg [3:0] mux_out
);

always @ (*)
begin
	if (mux_sel == 0) begin
	mux_out = mux_in_a;
	end
	else begin
	mux_out = mux_in_b;
	end
end

endmodule

// testbench
module Mux_TestBench();
 reg [7:0] dataa;
 reg [7:0] datab;
 reg [1:0] selector;
 wire [3:0] aout;
 
 mux4 mux(
 .dataa(dataa),
 .datab(datab),
 .selector(selector),
 .aout(aout),
 );

initial begin
 
 dataa = 8'b 1111_0000;
 datab = 8'b 1100_0011;
   selector = 2'b 00;
   #10
   selector = 2'b 01;
   #10
   selector = 2'b 10;
   #10
   selector = 2'b 11;
   
end

endmodule

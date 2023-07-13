module seven_segment_cntrl (
input [2:0] inp,
output reg seg_a, seg_b, seg_c, seg_d, seg_e, seg_f, seg_g
);

always @(*) begin

  case (inp)
  
3'b000: {seg_a, seg_b, seg_c, seg_d, seg_e, seg_f, seg_g} = 7'b1111110; //0
3'b001: {seg_a, seg_b, seg_c, seg_d, seg_e, seg_f, seg_g} = 7'b0110000; //1
3'b010: {seg_a, seg_b, seg_c, seg_d, seg_e, seg_f, seg_g} = 7'b1101101; //2
3'b011: {seg_a, seg_b, seg_c, seg_d, seg_e, seg_f, seg_g} = 7'b1111001; //3

default:
{seg_a, seg_b, seg_c, seg_d, seg_e, seg_f, seg_g} = 7'b1001111; 
  endcase

end

endmodule

// testbench
module Seven_Segment_Decoder_TestBench();
reg [2:0] inp;
wire seg_a, seg_b, seg_c, seg_d, seg_e, seg_f, seg_g;

seven_segment_cntrl SSD (
.inp(inp),
.seg_a(seg_a),
.seg_b(seg_b),
.seg_c(seg_c),
.seg_d(seg_d),
.seg_e(seg_e),
.seg_f(seg_f),
.seg_g(seg_g));

initial begin
inp = 3'b000; // Test input 0
#10;
inp = 3'b001; // Test input I
#10;
inp = 3'b010; // Test input 2
#10;
inp = 3'b011; // Test input 3
#10;
inp = 3'b100; // Test input 4 (invalid input)
#10;
inp = 3'b101; // Test input 5 (invalid input)
#10;
inp = 3'b110; // Test input 6 (invalid input)
#10;
inp = 3'b111; // Test input 7 (invalid input)
end
endmodule

module shifter (
  input [7:0] inp,
  input [1:0] shift_cntrl,
  output reg [15:0] shift_out
);


  always @(*) begin
    case(shift_cntrl)
      2'b00: shift_out = {8'b0000_0000, inp};
      2'b01: shift_out = {4'b0000, inp, 4'b0000};
      2'b10: shift_out = {inp, 8'b0000_0000};
      2'b11: shift_out = {8'b0000_0000, inp};
    endcase
  end

endmodule

// testbench
module Shifter_TestBench();

  reg [7:0] inp;
  reg [1:0] shift_cntrl;
  wire [15:0] shift_out;

  Shifter DUT (
    .inp(inp),
    .shift_cntrl(shift_cntrl),
    .shift_out(shift_out)
  );
  reg clk;
  initial begin
    inp = 8'b1010_1100;    
    shift_cntrl = 2'b00;   
    clk = 0;
    #5;                   
  end

  // Toggle clock
  always #5 clk = ~clk;

  // Stimulus
  initial begin
    // Test case 1
    #10 inp = 8'b1111_0000;
    shift_cntrl = 2'b00;
    #10;

    // Test case 2
    inp = 8'b0101_0101;
    shift_cntrl = 2'b01;
    #10;

    // Test case 3
    inp = 8'b0011_0011;
    shift_cntrl = 2'b10;
    #10;

    // Test case 4
    inp = 8'b1100_1100;
    shift_cntrl = 2'b11;
    #10;

  end

endmodule

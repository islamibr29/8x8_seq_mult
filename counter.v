module counter (
  input wire clk,
  input wire aclr_n,
  output reg [1:0] count_out
);

  always @(posedge clk or negedge aclr_n) begin
    if (!aclr_n)
      count_out <= 2'b00;
    else
      count_out <= count_out + 1;
  end

endmodule

// testbench
module Asynchronous_Counter_TestBench();
  
  reg clk;
  reg aclr_n;
  wire [1:0] count;

  // Instantiate the Asynchronous_Counter module
  Asynchronous_Counter DUT (
    .clk(clk),
    .aclr_n(aclr_n),
    .count(count)
  );

  // Toggle the clock every 5 time units
  always #5 begin
    clk = ~clk;
  end

  // Initialize signals before simulation starts
  initial begin
    clk = 0;
    aclr_n = 1;

    // Assert asynchronous reset for 20 time units
    #20;
    aclr_n = 0;

    // Deassert asynchronous reset after 20 time units
    #20;
    aclr_n = 1;
    
  end

endmodule

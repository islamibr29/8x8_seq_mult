module mult4x4(
  input [3:0] dataa,
  input [3:0] datab,
  output [7:0] product
);

  assign product = dataa * datab;

endmodule

// testbench
module Multiplier4BitTestBench;
 
  reg [3:0] dataa;
  reg [3:0] datab;
  
  
  wire [7:0] product;
  
  multiplier_4bit dut(
    .dataa(dataa),
    .datab(datab),
    .product(product)
  );
  
  initial begin
 #10
dataa = 5;
datab = 3;
 #10   
dataa = 8;
datab = 2;
 #10
dataa = 6;
datab = 4;
    
  end

endmodule

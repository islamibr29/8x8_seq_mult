module reg16(
input clk, sclr_n, clk_ena,
input [15:0] datain,
output reg[15:0] reg_out
);

always @(posedge clk) begin
 
  2'b00 : reg_out = reg_out;
  2'b01 : reg_out = reg_out;
  2'b10 : reg_out = 16'b 0000_0000_0000_0000;
  2'b11 : reg_out = datain ;
endcase

end

endmodule

// testbench
module Synchronous_register_TestBench();
  reg clk;
  reg sclr_n;
  reg clk_ena;
  reg [15:0] datain;
  wire [15:0] reg_out;
  
  reg16 DUT (
    .clk(clk),
    .sclr_n(sclr_n),
    .clk_ena(clk_ena),
    .datain(datain),
    .reg_out(reg_out)
  );


  always #5 clk = ~clk;

  initial begin
    clk = 0;
    sclr_n = 1;
    clk_ena = 1;
    datain = 16'b1010_1100_0101_0011;                               
 
    #10 sclr_n = 0;
    #10 sclr_n = 1;

    #10 clk_ena = 0;
    #10 clk_ena = 1;
  
end
endmodule

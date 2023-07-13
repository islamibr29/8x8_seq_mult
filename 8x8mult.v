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

module mult4x4(
  input [3:0] dataa,
  input [3:0] datab,
  output [7:0] product
);

  assign product = dataa * datab;

endmodule

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

module adder(
  input [15:0] dataa,
  input [15:0] datab,
  output [15:0] sum
);

  assign sum = dataa + datab;

endmodule

module mult_control (
    input clk, reset_a, start,
    input [1:0] count,
    output reg done, clk_ena, sclr_n,
    output reg [2:0] state_out,
    output reg [1:0] input_sel, shift_sel
);

    // Define states
    parameter IDLE = 3'b000, LSB = 3'b001, MID = 3'b010, MSB = 3'b011, CALC_DONE = 3'b100, ERR = 3'b101;

    reg [2:0] state;

    always @(posedge clk) begin
        if (~reset_a) begin
            state <= IDLE;
            done <= 0;

        end else begin
            case (state)
                IDLE: begin
                    if (~start & ~count) begin
                        state <= LSB;
                        clk_ena <= 1;
                    end else begin
                        state <= IDLE;
                        clk_ena <= 0;
                    end
			done <= 0;
                        sclr_n <= 1; 
			state_out <= IDLE;
                end

                LSB: begin
                    if (start) begin
                        state <= MID;
                        clk_ena <= 1;
                        sclr_n <= 0;
                        input_sel <= 2'b00;
                        shift_sel <= 2'b00;
                    end else begin
                        state <= IDLE;
                        clk_ena <= 0;
                        sclr_n <= 1;
                    end
			done <= 0;
			state_out <= LSB;
                end

                MID: begin
                    if (count == 2'b10 & ~start) begin
                        state <= MSB;
                        clk_ena <= 1;
                        input_sel <= 2'b10;
                        shift_sel <= 2'b01;
                    end else if (count == 2'b01 & ~start) begin
                        state <= MID;
                        clk_ena <= 1;
                        input_sel <= 2'b01;
                        shift_sel <= 2'b01;
                    end else begin
                        state <= ERR;
                        clk_ena <= 0;
                    end
                        done <= 0;
                        sclr_n <= 1;
			state_out <= MID;
                end

                MSB: begin
                    if(count == 2'b11 & ~start) begin
                        state <= CALC_DONE;
                        clk_ena <= 1;
                        input_sel <= 2'b11;
                        shift_sel <= 2'b10;
                    end else begin
                        state <= ERR;
                        clk_ena <= 0;
                    end
                        done <= 0;
                        sclr_n <= 1;
			state_out <= MSB;
                end

                CALC_DONE: begin
                    if(~start) begin
                        state <= IDLE;
                        done <= 1;
                    end else if (start) begin
                        state <= ERR;
                        done <= 0;
                    end
                        clk_ena <= 0;
                        sclr_n <= 1;
			state_out <= CALC_DONE;
                end

                ERR: begin
                    if(~start) begin
                        state <= ERR;
                        clk_ena <= 0;
                        sclr_n <= 1;
                    end else if (start) begin
                        state <= LSB;
                        clk_ena <= 1;
                        sclr_n <= 0;
                    end
                        done <= 0;
			state_out <= ERR;
                end

                default: state <= IDLE;

            endcase
        end
    end
endmodule

module mult8x8(
	input [7:0] dataa, datab,
	input start, reset_a, clk,
	output done_flag, seg_a, seg_b, seg_c, seg_d, seg_e, seg_f, seg_g,
	output [15:0] product8x8_out
);

wire clk_ena ,sclr_n  ;
wire [1:0] sel, shift, count;
wire [2:0] state_out;
wire[3:0] aout, bout;
wire [7:0] product;
wire [15:0] shift_out, sum;

mux4 A(
	.mux_in_a(dataa[3:0]),
	.mux_in_b(dataa[7:4]),
	.mux_sel(sel[1]),
	.mux_out(aout)
);

mux4 B(
	.mux_in_a(datab[3:0]),
	.mux_in_b(datab[7:4]),
	.mux_sel(sel[0]),
	.mux_out(bout[3:0])
);

mult4x4 MA(
	.dataa(aout[3:0]),
	.datab(bout[3:0]),
	.product(product[7:0])
);

shifter SA(
	.inp(product[7:0]),
	.shift_cntrl(shift[1:0]),
	.shift_out(shift_out[15:0])
);

adder AA(
	.dataa(shift_out[15:0]),
	.datab(product8x8_out[15:0]),
	.sum(sum[15:0])
);

reg16 RA(
	.clk(clk),
	.sclr_n(sclr_n),
	.clk_ena(clk_ena),
	.datain(sum[15:0]),
	.reg_out(product8x8_out[15:0])
);

counter CA(
	.aclr_n(~start),
	.clk(clk),
	.count_out(count[1:0])
);

mult_control MCA(
	.clk(clk),
	.reset_a(reset_a),
	.start(start),
	.count(count[1:0]),
	.input_sel(sel[1:0]),
	.shift_sel(shift[1:0]),
	.state_out(state_out[2:0]),
	.done(done_flag),
	.clk_ena(clk_ena),
	.sclr_n(sclr_n)
);

seven_segment_cntrl SSCA(
	.inp(state_out[2:0]),
	.seg_a(seg_a),
	.seg_b(seg_b),
	.seg_c(seg_c),
	.seg_d(seg_d),
	.seg_e(seg_e),
	.seg_f(seg_f),
	.seg_g(seg_g)
);

endmodule

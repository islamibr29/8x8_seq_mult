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

// testbench
module mult_control_Test;

    // Inputs
    reg clk;
    reg reset_a;
    reg start;
    reg [1:0] count;

    // Outputs
    wire done;
    wire clk_ena;
    wire sclr_n;
    wire [2:0] state_out;
    wire [1:0] input_sel;
    wire [1:0] shift_sel;

    // Instantiate the Unit Under Test (UUT)
    mult_control uut (
        .clk(clk), 
        .reset_a(reset_a), 
        .start(start), 
        .count(count), 
        .done(done), 
        .clk_ena(clk_ena), 
        .sclr_n(sclr_n), 
        .state_out(state_out), 
        .input_sel(input_sel), 
        .shift_sel(shift_sel)
    );

    initial begin
        // Initialize Inputs
        clk = 0;
        reset_a = 0;
        start = 0;
        count = 0;

        // Wait for 100 ns for global reset to finish
        #100;
        
        // De-assert reset
        reset_a = 1;
        #100;

        // Assert start and provide count
        start = 1;
        count = 2'b10;
        #100;

        // De-assert start
        start = 0;
        #100;

        // Assert start and provide count
        start = 1;
        count = 2'b11;
        #100;

        // De-assert start
        start = 0;
        #100;

        // Assert start and provide count
        start = 1;
        count = 2'b01;
        #100;

        // De-assert start
        start = 0;
        #100;

        // Assert start and provide count
        start = 1;
        count = 2'b00;
        #100;

        // De-assert start
        start = 0;
        #100;

        // Finish the simulation
        $finish;
    end

    always #10 clk = ~clk;

endmodule

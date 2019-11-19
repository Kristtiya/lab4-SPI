timescale 1ns / 1ps

//------------------------------------------------------------------------
// Input Conditioner test bench
//------------------------------------------------------------------------
`include "inputconditioner.v"

module testConditioner();

    reg clk;
    reg pin;
    wire conditioned;
    wire rising;
    wire falling;

    inputconditioner dut(.clk(clk),
    			         .noisysignal(pin),
			             .conditioned(conditioned),
			             .positiveedge(rising),
			             .negativeedge(falling));
    // Generate clock (50MHz)
    initial clk = 1;
    always #10 clk=!clk;    // 50MHz Clock

    initial begin
    $dumpfile("inputconditioner.vcd");
        $dumpvars(0, dut);
    repeat(10) begin
    pin = 0;
	$display("%t | %d | %d | %d | %d | %d |", $time, clk, pin, conditioned, rising, falling); #20;
	end
    repeat(20) begin
        pin = 1;
	    $display("%t | %d | %d | %d | %d | %d |", $time, clk, pin, conditioned, rising, falling); #20;
	end
    repeat(10) begin
    pin = 0;
	$display("%t | %d | %d | %d | %d | %d |", $time, clk, pin, conditioned, rising, falling); #20;
    end
    repeat(5) begin
        pin = 1;
	    $display("%t | %d | %d | %d | %d | %d |", $time, clk, pin, conditioned, rising, falling); #20;
	end

    repeat(10) begin
    pin = 0;
	$display("%t | %d | %d | %d | %d | %d |", $time, clk, pin, conditioned, rising, falling); #20;
	end

    repeat(10) begin   //Ensure super noisy singal does not send posedge or negedge signals
        pin = 1;
	    $display("%t | %d | %d | %d | %d | %d |", $time, clk, pin, conditioned, rising, falling); #20;
        pin = 0;
	    $display("%t | %d | %d | %d | %d | %d |", $time, clk, pin, conditioned, rising, falling); #20;
	end

    repeat(10) begin
    pin = 0;
	$display("%t | %d | %d | %d | %d | %d |", $time, clk, pin, conditioned, rising, falling); #20;
	end

    repeat(5) begin  //Short Signal _too short for wait-time so should not send posedge or negedge outputs
        pin = 1;
	    $display("%t | %d | %d | %d | %d | %d |", $time, clk, pin, conditioned, rising, falling); #20;
	end

    repeat(10) begin
    pin = 0;
	$display("%t | %d | %d | %d | %d | %d |", $time, clk, pin, conditioned, rising, falling); #20;
	end

    repeat(4) begin  //Short Signal _too short for wait-time so should not send posedge or negedge outputs
        pin = 1;
	    $display("%t | %d | %d | %d | %d | %d |", $time, clk, pin, conditioned, rising, falling); #20;
	end

    repeat(10) begin
    pin = 0;
	$display("%t | %d | %d | %d | %d | %d |", $time, clk, pin, conditioned, rising, falling); #20;
	end

    repeat(3) begin  //Short Signal _too short for wait-time so should not send posedge or negedge outputs
        pin = 1;
	    $display("%t | %d | %d | %d | %d | %d |", $time, clk, pin, conditioned, rising, falling); #20;
	end

    repeat(10) begin
    pin = 0;
	$display("%t | %d | %d | %d | %d | %d |", $time, clk, pin, conditioned, rising, falling); #20;
	end

	$display("... more execution (see waveform)");
		$finish();
	end

endmodule

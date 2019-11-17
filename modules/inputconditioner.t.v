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
    repeat(50) begin 
    pin = 0;
	$display("%t | %d | %d | %d | %d | %d |", $time, clk, pin, conditioned, rising, falling); #20;
	end
	$display("... more execution (see waveform)");
		$finish();
	end
    
endmodule

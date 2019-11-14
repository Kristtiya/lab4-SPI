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
    initial clk = 0;
    always #10 clk=!clk;    // 50MHz Clock
    
    initial begin
    $dumpfile("inputconditioner.vcd");
        $dumpvars(0, dut);
	repeat(3) begin 
	    $display("%t |%d|", $time, clk, rising, falling); #10;
	end
	$display("... more execution (see waveform)");
		$finish();
	end
    
    end
endmodule
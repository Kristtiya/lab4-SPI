`include "dflipflop.v"

module d_flipflop_test();
    reg D;
    reg clk;
    reg enable;

    wire reg Q;


    d_flipflop dut(.D(D),
                      .clk(clk),
                      .enable(enable),
                      .Q(Q));

        // Generate clock (50MHz)
    initial clk = 0;
    always #10 clk=!clk;    // 50MHz Clock
    
    initial begin
        repeat(10) begin 
        D = 1; enable = 1; #10;
        $display("%t | %d | %b | %b |", $time, clk, D, Q);#10;
        end
        $finish();
    end

endmodulet
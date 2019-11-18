`include "addresslatch.v"

module Address_Latch_Test();
    reg[6:0] D;
    reg clk;
    reg enable;

    wire reg[7:0] Q;


    Address_Latch dut(.D(D),
                      .clk(clk),
                      .enable(enable),
                      .Q(Q));

        // Generate clock (50MHz)
    initial clk = 1;
    always #10 clk=!clk;    // 50MHz Clock
    
    initial begin
        repeat(10) begin 
        D = 8'd7; enable = 1; ;
        $display("%t | %d | %b | %b |", $time, clk, D, Q);#10;
        end
        $finish();
    end

endmodule

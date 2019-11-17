`timescale 1 ns  / 1 ns

`include "statemachine.v"


module TAKS();

    reg clk;
    reg cs;

    initial clk = 0;
    always #5 clk= !clk;

    statemachine fsm(
        .clk(clk),
        .cs(cs),
        .shiftregout(),
        .misobuff(),
        .mem_we(),
        .add_latch_we(),
        .shift_ref_we()
    );

    initial begin
        $dumpfile("statemachine.vcd");
        $dumpvars();
        $display("Testing Begin...");
        cs = 1;
        #100
        cs = 0;
        #100
        cs = 1;
        #100

        $finish();
    end
endmodule

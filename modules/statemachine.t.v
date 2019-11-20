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
        .RW(rw)
    );

    initial begin
        $dumpfile("statemachine.vcd");
        $dumpvars();
        $display("Testing Begin...");
        cs = 1;
        #105
        cs = 0;
        #150
        cs = 1;
        #100
        $display("View GTKwave for information");

        $finish();
    end
endmodule

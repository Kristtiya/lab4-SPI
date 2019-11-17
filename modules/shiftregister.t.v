//------------------------------------------------------------------------
// Shift Register test bench
//------------------------------------------------------------------------

`timescale 1ns / 1ps

`include "shiftregister.v"
`include "shiftregmodes.v"

`define ASSERT_EQ(val, exp, msg) \
  if (val !== exp) $display("[FAIL] %s (got:0b%b expected:0b%b)", msg, val, exp);


module testshiftregister();

    reg             clk;
    reg             peripheralClkEdge;
    reg             parallelLoad;
    wire[7:0]       parallelDataOut;
    wire            serialDataOut;
    reg[7:0]        parallelDataIn;
    reg             serialDataIn; 
    
    reg[1:0]       mode; 

    // Instantiate with parameter width = 8
    shiftregister #(8) dut(.clk(clk), 
    		           .peripheralClkEdge(peripheralClkEdge),
    		           .parallelLoad(parallelLoad), 
    		           .parallelDataIn(parallelDataIn), 
    		           .serialDataIn(serialDataIn), 
    		           .parallelDataOut(parallelDataOut), 
    		           .serialDataOut(serialDataOut),
                       .mode(mode));
    
    initial clk=0;
    always #10 clk = !clk;


    initial begin

        `ifdef DUMPS
        $dumpfile("shiftregister.vcd");
        $dumpvars(0, dut);
        `endif    

        //Test PARALLEL LOAD
        @(negedge clk); mode=`PLOAD; serialDataIn=1'bX; parallelDataIn=8'b10101100;
        @(posedge clk); #1   `ASSERT_EQ(parallelDataOut, 8'b10101100, "PARALLEL LOAD")

        //Test HOLD 

        @(negedge clk);  mode=`HOLD; serialDataIn=1'bX; parallelDataIn=8'bX;
        @(posedge clk); #1  `ASSERT_EQ(parallelDataOut, 8'b10101100, "HOLD")

        //Test LEFT SHIFT
        @(negedge clk);  mode=`LSHIFT; serialDataIn=1'b1; parallelDataIn=8'bX;
        @(posedge clk); #1  `ASSERT_EQ(parallelDataOut, 8'b01011001, "LEFT SHIT")

        //TEST RIGHT SHIFT
        @(negedge clk);  mode=`RSHIFT; serialDataIn=1'b1; parallelDataIn=8'bX;
        @(posedge clk); #1  `ASSERT_EQ(parallelDataOut, 8'b10101100, "RIGHT SHIFT")

    #20 $finish();  // End the simulation (otherwise the clock will keep running forever)

    end

endmodule


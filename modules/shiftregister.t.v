//------------------------------------------------------------------------
// Shift Register test bench
//------------------------------------------------------------------------

`timescale 1ns / 1ps

`include "shiftregister.v"

module testshiftregister();

    reg             clk;
    reg             peripheralClkEdge;
    reg             parallelLoad;
    wire[7:0]       parallelDataOut;
    wire            serialDataOut;
    reg[7:0]        parallelDataIn;
    reg             serialDataIn; 
    wire            rewr;


    // Instantiate with parameter width = 8
    shiftregister #(8) dut(.clk(clk), 
    		           .peripheralClkEdge(peripheralClkEdge),
    		           .parallelLoad(parallelLoad), 
    		           .parallelDataIn(parallelDataIn), 
    		           .serialDataIn(serialDataIn), 
    		           .parallelDataOut(parallelDataOut), 
    		           .serialDataOut(serialDataOut),
                       .rewr(rewr));
    

        initial begin
        $display("testing");


		$monitor(" %b | %b | %b | %b | %b", peripheralClkEdge, parallelDataIn, serialDataIn, parallelDataOut, serialDataOut, rewr);
		peripheralClkEdge=1'b1; parallelLoad = 1'b1; parallelDataIn = 8'b10101010; serialDataIn = 1'b1; #100

		peripheralClkEdge=1'b0; parallelLoad = 1'b1; parallelDataIn = 8'b10101010; serialDataIn = 1'b1; #100

		peripheralClkEdge=1'b1; parallelLoad = 1'b1; parallelDataIn = 8'b10101010; serialDataIn = 1'b0; #100

	    peripheralClkEdge=1'b0; parallelLoad = 1'b1; parallelDataIn = 8'b10101010; serialDataIn = 1'b1; #100



		$display("END");
	end

endmodule


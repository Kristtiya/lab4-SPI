//------------------------------------------------------------------------
// Shift Register
//   Parameterized width (in bits)
//   Shift register can operate in two modes:
//      - serial in, parallel out
//      - parallel in, serial out
//------------------------------------------------------------------------

`include "shiftregmodes.v"

module shiftregister
#(parameter width = 8)
(
input               clk,                // FPGA Clock
input               peripheralClkEdge,  // Edge indicator
input               parallelLoad,       // 1 = Load shift reg with parallelDataIn
input  [width-1:0]  parallelDataIn,     // Load shift reg in parallel
input               serialDataIn,       // Load shift reg serially
output   reg [width-1:0]  parallelDataOut,    // Shift reg data contents
output              serialDataOut,      // Positive edge synchronized
output   reg        rewr                  //1 for write, 0 for read

);

    always @(parallelDataIn[7])
        rewr <= parallelDataIn[7];

    always @(peripheralClkEdge) begin

        parallelDataOut <= {parallelDataOut[6:0], serialDataIn};
    end

    assign serialDataOut = parallelDataOut[width-1];

endmodule

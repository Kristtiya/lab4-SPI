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
output [width-1:0]  parallelDataOut,    // Shift reg data contents
output              serialDataOut,      // Positive edge synchronized

input   [1:0]       mode

);

    reg [width-1:0] shiftregistermem = 8'b0;
    // assign shiftregistermem <= {width{1'b0}}

    // always @(peripheralClkEdge) begin

    //     `LSHIFT: begin shiftregistermem <= {shiftregistermem[width-2:0], serialDataIn}; end

    // end

    always @(posedge clk) begin

        shiftregistermem <= {shiftregistermem[width-2:0], serialDataIn};

        case (mode)
            `HOLD:   begin shiftregistermem <= {shiftregistermem[width-1:0]}; end
            `PLOAD:  begin shiftregistermem <= {parallelDataIn[width-1:0]}; end
            `LSHIFT: begin shiftregistermem <= {shiftregistermem[width-2:0], serialDataIn}; end
            `RSHIFT: begin shiftregistermem <= {serialDataIn, shiftregistermem[width-1:1]}; end
        endcase
    end

    assign parallelDataOut = shiftregistermem;
    assign serialDataOut = shiftregistermem[width-1];

endmodule

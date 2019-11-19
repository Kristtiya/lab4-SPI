//------------------------------------------------------------------------
// Data Memory
//   Positive edge triggered
//   dataOut always has the value mem[address]
//   If writeEnable is true, writes dataIn to mem[address]
//------------------------------------------------------------------------

module datamemory
#(
    parameter addresswidth  = 7,
    parameter depth         = 2**addresswidth,
    parameter width         = 8
)
(
    input 		                clk,
    output reg [width-1:0]      dataOut,
    input [addresswidth-1:0]    address,
    input                       writeEnable,
    input [width-1:0]           dataIn,
    input                       reset
);

    reg [width-1:0] memory [depth-1:0];

    always @(posedge clk) begin
        if(writeEnable)
            memory[address] <= dataIn;
            dataOut <= memory[address];
    end


    //SO I've read that FPGAs have no known value for any registers
    //on startup so it's common practice to set a reset line to necessary
    //modules in order to set them to a known value -> Stack Overflow
    reg[31:0] k;
    always@(posedge reset)begin
      if (reset) begin
        for (k =0 ;k<3'b111 ;k = k + 1 ) begin
          memory[k] = 8'b0;
          end
          // memory[7] = 8'b101010; //points to the begening of the stack
          //                      //source -> Mars
      end
    end


endmodule

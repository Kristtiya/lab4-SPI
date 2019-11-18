//------------------------------------------------------------------------
// SPI Memory
//------------------------------------------------------------------------
`include "inputconditioner.v"
`include "statemachine.v"
`include "shiftregister.v"
`include "datamemory.v"
module spiMemory
(
    input           clk,        // FPGA clock
    input           sclk_pin,   // SPI clock
    input           cs_pin,     // SPI chip select
    output          miso_pin,   // SPI master in slave out
    input           mosi_pin,   // SPI master out slave in
    output [3:0]    leds        // LEDs for debugging
)
    wire cond_cs;
    wire cond_sclk;
    wire cond_mosi;

    wire posedge0;
    wire posedge1;
    wire posedge2;
    
    wire negedge0;
    wire negeedge1;
    wire negedge2;

    wire misobuff;
    wire mem_we;
    wire add_latch_we;

    wire parallelDataOut;


inputconditioner MOSI_cond(.conditioned(cond_mosi), .positiveedge(posedge0), .negativeedge(negeedge0), .noisysignal(mosi_pin), .clk(clk));
inputconditioner SCLK_cond(.conditioned(cond_sclk), .positiveedge(posedge1), .negativeedge(negedge1), .noisysignal(sclk_pin), .clk(clk));
inputconditioner CS_cond(.conditioned(cond_cs), .positiveedge(posedge2), .negativeedge(negedge2), .noisysignal(cs_pin), .clk(clk));


shiftregister shift_register(.parallelDataOut(parallelDataOut), serialDataOut(), serialDataIn(cond_mosi), .parallelDataIn(), parallelLoad(), peripheralClkEdge(posedge1),.clk(clk));

datamemory Data_Memory(.dataOut(), .address(), .writeEnable(), .dataIn(), .clk(clk));

statemachine FSM(.misobuff(misobuff), .mem_we(mem_we), .add_latch_we(add_latch_we), .RW(), .shiftregout(serialDataOut), .cs(cond_cs), .clk(clk));

endmodule
   


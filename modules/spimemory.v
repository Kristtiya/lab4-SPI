//------------------------------------------------------------------------
// SPI Memory
//------------------------------------------------------------------------
`include "inputconditioner.v"
`include "statemachine.v"
`include "shiftregister.v"
`include "datamemory.v"
`include "addresslatch.v"
`include "dflipflop.v"
`include "enable_not.v"

module spiMemory
(
    input           clk,        // FPGA clock
    input           sclk_pin,   // SPI clock
    input           cs_pin,     // SPI chip select
    output          miso_pin,   // SPI master in slave out
    input           mosi_pin,   // SPI master out slave in
    output [3:0]    leds        // LEDs for debugging
);
    wire[7:0] dataMemOut;
    wire Q_S_out;
    wire cond_cs;
    wire cond_sclk;
    wire cond_mosi;
    wire posedge0;
    wire posedge1; 
    wire posedge2;
    wire negedge0;
    wire negedge1;
    wire negedge2;
    wire[6:0] data_address;
    wire[7:0] parallelDataOut;
    wire serialDataOut;

    wire RW;
    wire misobuff;
    wire mem_we;
    wire add_latch_we;

    inputconditioner MOSI_cond(.conditioned(cond_mosi), .positiveedge(posedge0), .negativeedge(negedge0), .noisysignal(mosi_pin), .clk(clk));
    inputconditioner SCLK_cond(.conditioned(cond_sclk), .positiveedge(posedge1), .negativeedge(negedge1), .noisysignal(sclk_pin), .clk(clk));
    inputconditioner CS_cond(.conditioned(cond_cs), .positiveedge(posedge2), .negativeedge(negedge2), .noisysignal(cs_pin), .clk(clk));

    shiftregister shift_register(.peripheralClkEdge(posedge1), .parallelLoad(RW), .parallelDataIn(dataMemOut), .serialDataIn(cond_mosi), .parallelDataOut(parallelDataOut), .serialDataOut(serialDataOut), .rewr(RW), .clk(clk));

 
    datamemory Data_Memory(.dataOut(dataMemOut), .address(data_address), .writeEnable(mem_we), .dataIn(parallelDataOut), .clk(clk));
  


    statemachine FSM(.misobuff(misobuff), .mem_we(mem_we), .add_latch_we(add_latch_we), .RW(RW), .shiftregout(parallelDataOut[0]), .cs(cond_cs), .clk(clk));



    Address_Latch addr_latch(.Q(data_address), .D(parallelDataOut), .enable(add_latch_we), .clk(clk));


    d_flipflop DFF(.Q(Q_S_out), .D(serialDataOut), .enable(negedge1), .clk(clk));

    enablenot e_not(.out(miso_pin), .enable(misobuff), .data_in(Q_S_out));

endmodule


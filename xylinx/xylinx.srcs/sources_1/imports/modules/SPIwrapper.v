`timescale 1ns / 1ps


`include "spimemory.v"


module spi_wrapper
(
    input   clk,
    input[3:0] jb_p,
    output jc_p,
    output reg[3:0] led
);


spiMemory DUT(
    .clk(clk),
    .sclk_pin(jb_p[0]),
    .cs_pin(jb_p[1]),
    .mosi(jb_p[2]),
    .reset(jb_p[3]),
    .miso(jc_p),
    .leds()
);

always@(posedge clk)
    led[0] <= jb_p[3];


endmodule
//------------------------------------------------------------------------
// Finite State Machine for SPI Module
// Contributors: @aditya-sudhakar, @coreyacl, @Kristya
//------------------------------------------------------------------------

module statemachine(
    input clk,
    input cs,
    input shiftregout,
    output misobuff,
    output mem_we,
    output add_latch_we,
    output shift_ref_we
);

//SOLVE KNOWN VALUE ISSUE
reg[6:0] tim;
initial tim = 0;
wire out;
wire enable;
wire CS_N;

not notCS(CS_N,cs);
nand oxgate(out,tim[0],tim[1],tim[2],tim[3],tim[4],tim[5],tim[6]);


and orgate(enable,out,CS_N);

always@(posedge clk)
    tim[0] <= enable;

always@(posedge clk)
    tim[1] <= tim[0];

always@(posedge clk)
    tim[2] <= tim[1];

always@(posedge clk)
    tim[3] <= tim[2];

always@(posedge clk)
    tim[4] <= tim[3];

always@(posedge clk)
    tim[5] <= tim[4];

always@(posedge clk)
    tim[6] <= tim[5];


wire RW;

and andgate(RW,tim[0],tim[1],tim[2],tim[3],tim[4],tim[5],tim[6]);



endmodule
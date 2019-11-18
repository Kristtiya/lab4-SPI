//------------------------------------------------------------------------
// Finite State Machine for SPI Module
// Contributors: @aditya-sudhakar, @coreyacl, @Kristya
//------------------------------------------------------------------------

module statemachine(
    input clk,
    input cs,
    input shiftregout,
    input RW,
    output misobuff,
    output mem_we,
    output reg add_latch_we
);
parameter t_count = 15;


//SOLVE KNOWN VALUE ISSUE
reg[t_count-1:0] tim;
initial tim = 0;
wire out;
wire enable;
wire CS_N;

not notCS(CS_N,cs);


// Timer for 15
nor yep(out,tim[0],tim[1],tim[2],tim[3],tim[4],tim[5],tim[6],tim[7],tim[8],tim[9],tim[10],tim[11],tim[12],tim[13],tim[14]);
and orgate(enable,out,CS_N);

always@(posedge clk)
    tim[0] <= enable;

generate
genvar i;
for (i = 1;i<t_count ;i = i +1 ) begin
    always@(posedge clk)
        tim[i] <= tim[i-1];
end
endgenerate

// Signals the RW phase of the message
always@(tim[7]) 
    add_latch_we <= tim[7];

wire rw_enable;

// Signals end of message
and rwandgate(mem_we,RW,tim[t_count-1]);


endmodule
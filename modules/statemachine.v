//------------------------------------------------------------------------
// Finite State Machine for SPI Module
// Contributors: @aditya-sudhakar, @coreyacl, @Kristya
//------------------------------------------------------------------------

module statemachine(
    input clk,
    input cs,
    input shiftregout,
    output reg RW,
    output misobuff,
    output mem_we,
    output reg add_latch_we,
    input serialDataIn
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
wire res;
and andgateTimer(res,CS_N,tim[i-1]);
    always@(posedge clk)
        tim[i] <= res;
end
endgenerate

// Signals the RW phase of the message
always@(tim[7]) 
    add_latch_we <= tim[7];

wire rw_enable;

wire ifRead;

and andgate1(ifRead,tim[7],serialDataIn);

// Load parallel data in
always@(negedge clk)
    RW <= ifRead;

// Signals end of message
// and rwandgate(mem_we,RW,tim[t_count-1]);


endmodule
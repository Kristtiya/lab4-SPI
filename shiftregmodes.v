`ifndef SHIFTREGMODES_V
`define SHIFTREGMODES_V

//List of input cases
`define HOLD      2'b00    //hold current state
`define PLOAD     2'b01    //Parallel Load: parallelIn replaces entire shift register contents
`define LSHIFT    2'b10    //Left Shift: serialIn becomes new LSB, MSB is dropped
`define RSHIFT    2'b11    //Right Shift: serialIn become the new MSB, LSB is dropped

`endif
module enablenot(
input data_in,
input enable,
output reg out
);
always @ (enable) 
    if (enable)
        out <= ~data_in;
    else
        out <= data_in;
    
endmodule
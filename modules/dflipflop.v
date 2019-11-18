module d_flipflop(
input D,
input clk,
input enable,
output reg Q
);
    initial Q =  0;
    always @ (posedge clk) begin
        if (enable)begin
            Q <= D;
            end
         else begin
            Q <= Q;
        end
    end
endmodule
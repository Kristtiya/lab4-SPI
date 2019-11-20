module d_flipflop(
input D,
input clk,
input enable,
output reg Q
);
    initial Q =  0;
    always @ (negedge clk) begin
        if (enable)begin
            Q <= D;
            end
         else begin
            Q <= Q;
        end
    end
endmodule

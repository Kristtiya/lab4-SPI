module Address_Latch(
input [7:0] D,
input clk,
input enable,
output reg[6:0] Q
);
    initial Q =  0;
    always @ (posedge clk) begin
        if (enable)begin
            Q <= D[6:0];
            end
         else begin
            Q <= Q;
        end
    end
endmodule
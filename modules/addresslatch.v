module Address_Latch(
input [7:0] D,
input clk,
input enable,
output reg[7:0] Q
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
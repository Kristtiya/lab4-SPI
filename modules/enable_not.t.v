`include "enable_not.v"

module enablenottest();
    reg data_in;
    reg enable;
    wire reg out;

enablenot dut(.data_in(data_in), .enable(enable), .out(out));

    initial begin
        data_in = 1; enable = 1; #10;
        $display("| %b | %b | %b |", data_in, enable, out);#10;
        data_in = 0; enable = 0; #10;
        $display("| %b | %b | %b |", data_in, enable, out);#10;
        data_in = 0; enable = 1; #10;
        $display("| %b | %b | %b |", data_in, enable, out);#10;
        data_in = 1; enable = 0; #10;
        $display("| %b | %b | %b |", data_in, enable, out);#10;
           
        $finish();
    end

endmodule
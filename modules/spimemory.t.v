`include "spimemory.v"

module SPI_Test();    
    reg           clk;       // FPGA clock
    reg           sclk_pin;   // SPI clock
    reg           cs_pin;     // SPI chip select
    wire          miso_pin;   // SPI master in slave out
    reg           mosi_pin;   // SPI master out slave in

    spiMemory dut(.miso_pin(miso_pin), 
                  .mosi_pin(mosi_pin),
                  .cs_pin(cs_pin),
                  .sclk_pin(sclk_pin),
                  .clk(clk));

    // Generate clock (50MHz)
    initial clk = 0;
    always #10 clk=!clk;    // 50MHz Clock
    
        initial begin
        $dumpfile("spimemory.vcd");
        $dumpvars(0, dut);
        $display("testing");
		$monitor("| %b | %b | %b | %b | %b |", clk, sclk_pin, mosi_pin, cs_pin, miso_pin);
		mosi_pin=1'b0; sclk_pin = 1'b0; cs_pin = 8'b0; #100

		mosi_pin=1'b1; sclk_pin = 1'b0; cs_pin = 8'b0; #100

		mosi_pin=1'b1; sclk_pin = 1'b1; cs_pin = 8'b0; #100

	    mosi_pin=1'b0; sclk_pin = 1'b1; cs_pin = 8'b0; #100

		mosi_pin=1'b0; sclk_pin = 1'b0; cs_pin = 8'b0; #100

		mosi_pin=1'b0; sclk_pin = 1'b0; cs_pin = 8'b0; #100

		mosi_pin=1'b0; sclk_pin = 1'b1; cs_pin = 8'b0; #100

	    mosi_pin=1'b0; sclk_pin = 1'b1; cs_pin = 8'b0; #100

		$display("END");
        $finish();
	end
endmodule

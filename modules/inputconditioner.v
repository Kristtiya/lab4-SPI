//------------------------------------------------------------------------
// Input Conditioner
//    1) Synchronizes input to clock domain
//    2) Debounces input
//    3) Creates pulses at edge transitions
//------------------------------------------------------------------------

module inputconditioner
(
input 	    clk,            // Clock domain to synchronize input to
input	    noisysignal,    // (Potentially) noisy input signal
output reg  conditioned,    // Conditioned output signal
output reg  positiveedge,   // 1 clk pulse at rising edge of conditioned
output reg  negativeedge    // 1 clk pulse at falling edge of conditioned
);


    initial positiveedge = 0;
    initial negativeedge = 0;
    initial conditioned = 0;
    
    parameter counterwidth = 3; // Counter size, in bits, >= log2(waittime)
    parameter waittime = 3;     // Debounce delay, in clock cycles
    
    reg[counterwidth-1:0] counter = 0;
    reg synchronizer0 = 0;
    reg synchronizer1 = 0;
    
    reg signal;
    //Posedge for conditioned button
    always @(posedge clk) begin
        if(conditioned == synchronizer1)
            counter <= 0;

        else begin
            if( counter == waittime) begin
                counter <= 0;
                conditioned <= synchronizer1;
            end

            else 
                counter <= counter+1;
        end
        synchronizer0 <= noisysignal;
        synchronizer1 <= synchronizer0;
    end    
        //https://www.edaboard.com/showthread.php?40349-how-can-i-detect-the-positive-edge-of-a-signal-in-verilog
    always @(posedge clk or negedge conditioned)
        begin
        if (~conditioned)
            signal <= 1'b0;
        else
            signal <= 1'b1;
        assign positiveedge = conditioned & (~signal);
        assign negativeedge = ~conditioned & (signal);

        end

endmodule
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
output reg conditioned,    // Conditioned output signal
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
    
    reg[waittime-1:0] inputFilter;

    always@(posedge clk)
        inputFilter[0] <= noisysignal;

    generate
    genvar i;
    for (i = 1; i<waittime;i=i+1 ) begin
        always@(posedge clk)
            inputFilter[i] <= inputFilter[i-1];
    end
    endgenerate

    wire h1;
    wire h2;
    //MUST CHANGE IF COUNTERWIDTH CHANGES
    and outputsignal(h1,inputFilter[0],inputFilter[1],inputFilter[2]);
    nor outputsignal1(h2,inputFilter[0],inputFilter[1],inputFilter[2]);

    reg holder;

    wire timer_clock;
    or orgate(timer_clock,h1,h2);

    always@(posedge timer_clock)
        conditioned <= noisysignal;


    reg signal;
    // //Posedge for conditioned button
    // always @(posedge clk) begin
    //     if(conditioned == synchronizer1)
    //         counter <= 0;

    //     else begin
    //         if( counter == waittime) begin
    //             counter <= 0;
    //             conditioned <= synchronizer1;
    //         end

    //         else 
    //             counter <= counter+1;
    //     end
    //     synchronizer0 <= noisysignal;
    //     synchronizer1 <= synchronizer0;
    // end    
    //     //https://www.edaboard.com/showthread.php?40349-how-can-i-detect-the-positive-edge-of-a-signal-in-verilog
    always @(posedge clk or negedge conditioned or posedge conditioned)
        begin
        if (~conditioned)
            signal <= 1'b0;
        else
            signal <= 1'b1;
        assign negativeedge = ~conditioned & (signal);
        assign positiveedge = conditioned & (~signal);

        end

endmodule
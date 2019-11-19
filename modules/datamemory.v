//------------------------------------------------------------------------
// Data Memory
//   Positive edge triggered
//   dataOut always has the value mem[address]
//   If writeEnable is true, writes dataIn to mem[address]
//------------------------------------------------------------------------

module datamemory
#(
    parameter addresswidth  = 7,
    parameter depth         = 2**addresswidth,
    parameter width         = 8
)
(
    input 		                clk,
    output reg [width-1:0]      dataOut,
    input [addresswidth-1:0]    address,
    input                       writeEnable,
    input [width-1:0]           dataIn,
    input                       reset
);
 signals are not exactly equal and opposite. Let one signal be +i1 and the other be -i2, where i1 and i2 are similar but not equal in magnitude. The sum of their return currents is: (i1 - i2). Since this is not zero, then this incremental current must be returning somewhere else-presumably ground.

So what, you ask? Let's assume the sending circuit sends a differential pair of signals that are exactly equal and opposite. Then we assume they will still be so at the receiving end of the path. But what if the path lengths are different? If one path (of the differential pair) is longer than the other path, then the signals are no longer equal and opposite during their transition phase at the receiver (see Figure 2). If the signals are no longer equal and opposite during their transition from one state to another, then it is no longer true that there is no return signal through ground. If there is a return signal through ground, then power system integrity does become an issue, and EMI may become a problem.

Design Rule 1

This brings us to my first design rule when dealing with differential signals: The traces should be of equal length.

Some people argue passionately against this rule. Generally, the basis for their argument involves signal timing. They point out in great detail that many differential circuits can tolerate significant differences in the timing between the two halves of a differential signal pair and still switch reliably. Depending on the logic family used, trace length difference of 500 mils can be tolerated. This can be very convincingly illustrated with parts specs and signal timing diagrams. The problem is-in my opinion-that they miss the point. The reason differential traces must be equal length has almost nothing to do with signal timing. It has everything to do with the assumption that differential signals are equal and opposite, and what happens when that assumption is violated. And what happens is this: uncontrolled ground currents start flowing that at the very best are benign but at worst can generate serious common-mode EMI problems.

So, if you are depending on the assumption that your differential signals are equal and opposite, and that therefore there is no signal flowing through ground, a necessary consequence of that assumption is that your differential pair signal lengths should be equal.

Differential signals and loop areas

If our differential circuits are dealing with signals that have slow rise times, high-speed design rules are not an issue. However, when dealing with fast rise time signals, additional issues come into play with differential traces.

Consider a design where a differential signal pair is routed across a plane from driver to receiver. Let's also assume that the trace lengths are perfectly equal and the signals are exactly equal and opposite. Therefore, there is no return current path through ground, but nevertheless there is an induced current on the plane.

Any high-speed signal can and will induce a coupled signal into an adjacent trace or plane. The mechanism is exactly the same mechanism as crosstalk. It is caused by electromagnetic coupling, the combined effects of mutually inductive coupling and capacitive coupling. Just as the return current for a single-ended signal trace tends to travel on the plane directly under the trace, a differential trace also will have an induced current on the plane underneath it.

But this is not a return current. All the return currents have cancelled. This is purely a coupled noise current on the plane. The question is: if current must flow in a loop, where is the rest of the current flow? Remember, we have two traces with equal and opposite signals. One trace couples a signal on the plane in one direction, the other trace couples a signal on the plane in the other direction. These two coupled currents on the plane are equal in magnitude (assuming otherwise good design practices.) So the currents simply flow in a closed loop underneath the differential traces (see Figure 3). They look like eddy currents. The loop these coupled currents flow in is defined by: (a) the differential traces themselves, and (b) the separation between the traces at each end. The loop "area" is defined by these four boundaries.

Design Rule 2

Now it is generally known that EMI is related to loop area.3 Therefore, if we want to keep EMI under control, we need to minimize this loop area. The way we do that brings us to the second design rule: Route differential traces closely together. There are people who argue against this rule, and indeed the rule is not necessary if rise times are slow and EMI is not an issue. But in high-speed environments, the closer we route the differential traces to each other, the smaller will be the loop area of the induced currents under the traces, and the better control over EMI we will have.

It is worthwhile to note that some engineers ask designers to remove the plane under differential traces. Reducing or eliminating the induced current loops under the traces is one reason for this. Another reason is to prevent any noise that might already be on the plane from coupling into the (presumably) low signal levels on the traces themselves.4

There is another reason to route differential traces close together. Differential receivers are designed to be sensitive to the difference between a pair of inputs, but also to be insensitive to a common-mode shift of those inputs. That means if the (+) input shifts even slightly in relation to the (-) input, the receiver will detect it. But if the (+) and (-) inputs shift together-i.e., in the same direction-the receiver is relatively insensitive to this shift. Therefore, if any external noise such as EMI or crosstalk is coupled equally into the differential traces, the receiver will be insensitive to this common-mode coupled noise. The more closely differential traces are routed together, the more equal any coupled noise will be on each trace, and the better will be the rejection of the noise in the circuit.

Rule 2 consequence

Assuming a high-speed environment, if differential traces are routed closely to each other (to minimize the loop area underneath them) then the traces will couple into each other. If the traces are long enough that termination becomes an issue, this coupling impacts the calculation of the correct termination impedance.5

Consider a differential pair of traces, Trace 1 and Trace 2. Let's say they carry signals V1 and V2, respectively. Since they are differential traces, V2 = -V1. V1 causes a current, i1, along Trace 1, and V2 causes a current, i2, along trace 2. The current is derived from Ohm's Law, I = V/Zo, where Zo is the characteristic impedance of the trace. In the example, the current carried by Trace 1 actually consists of i1 and also k*i2, where k is proportional to the coupling between Trace 1 and 2. It can be shown that the net effect of this coupling is an apparent impedance along Trace 1 equal to Z = Zo - Z12, where Z12 is caused by the mutual coupling between Trace 1 and Trace 2.6

If Trace 1 and 2 are far apart, the coupling between them is very small, and the correct termination of each trace is simply Zo, the characteristic impedance of the single-ended trace. But as the traces come closer together and the coupling between them increases, then the impedance of the trace reduces proportional to this coupling-which means the proper termination of the trace (to prevent reflections) is Zo - Z12, or something less than Zo. This applies to both traces in the differential pair. And since no return current flows through ground (or so it is assumed) then the terminating resisters are connected in series between Traces 1 and 2, and the correct terminating impedance is calculated as 2(Zo - Z12). This value is often given the name "differential impedance."7

Design Rule 3

Differential impedance changes with coupling, which changes with trace separation. Since it is always important that the trace impedance remain constant over the entire length, this means that the coupling must remain constant over the entire length. And this leads to our third rule: The separation between the two traces (of the differential pair) must remain constant over the entire length.

Note that these differential impedance impacts are merely consequences of Design Rule 2. There is nothing inherent about them. The reason we want to route differential traces close together has to do with EMI and noise immunity. The fact that this has an impact on the correct termination of "long" traces, and this in turn has an impact on the uniformity of trace separation, is simply a consequence of routing the traces close together for EMI control.8

Conclusion

Differential signals have several advantages, three of which can be: (1) effective isolation from power systems, (2) noise immunity, and (3) improvement in S/N ratios. Isolation from power systems-and in particular from system ground(s)-depends on the assumption that the signals on the differential traces are truly equal and opposite. This assumption may not be correct if the trace lengths of the individual traces of the differential pair are not evenly matched. Noise immunity often depends on close coupling of the traces. This has an impact on the value of the proper termination of the traces to prevent reflections, and also generally requires that if the traces must be close coupled, their separation must also be constant over their entire length.

Doug Brooks is the president of UltraCAD Design Inc. (Bellevue, WA). His e-mail address is doug@eskimo.com.

Footnotes

1. The signal can return through either or both the ground or power system. The singular term "ground" is used throughout this article simply for convenience.

2. Optically coupled devices are another approach to solving this same type of problem.

3. See "Loop Areas: Close 'Em Tight," Printed Circuit Design, January 1999.

4. I know of no definitive studies that either support or refute this practice.

5. There are many references throughout the industry on impedance-controlled traces. See, for example, "PCB Impedance Control: Formulas and Resources," Printed Circuit Design, March 1998; "Impedance Terminations: What's the Value?," Printed Circuit Design, March 1999; and "What Is Characteristic Impedance," January 2000, p. 18.

6. See "Differential Impedance: What's the Difference," Printed Circuit Design, August 1998.

7. For an interesting discussion about how to terminate both the differential mode and common-mode components of a pair of traces, see "Terminating Differential Signals on PCBs," Printed Circuit Design, March 1999, p. 25.

8. The reason this doesn't happen with other closely routed traces-those subject to crosstalk, for example-is that other traces don't have a coupling between them that is perfectly correlated (i.e., equal and opposite). If the coupled signals are simply randomly related to each other, the average coupling is zero and there is no impact on the impedance termination.


2001 CMP Media LLC.
11/1/01, Issue # 1811, page 12.

Reproduction and distribution of material appearing in PCD and on the www.pcdmag.com Web site is forbidden without written permission from the editor.
Contact information for Reprints.

NOTE: The articles presented here contain only the text originally published in Printed Circuit Design magazine. Any accompanying graphics and illustrations have not been recreated here. You may view the article in its entirety in each printed issue of PCD.

0 COMMENTS
POST COMMENT
Login to Post Your Comment
PODCAST

    reg [width-1:0] memory [depth-1:0];

    always @(posedge clk) begin
        if(writeEnable)
            memory[address] <= dataIn;
            dataOut <= memory[address];
    end


    //SO I've read that FPGAs have no known value for any registers
    //on startup so it's common practice to set a reset line to necessary
    //modules in order to set them to a known value -> Stack Overflow
    reg[31:0] k;
    always@(posedge reset)begin
      if (reset) begin
        for (k =0 ;k<3'b111 ;k = k + 1 ) begin
          memory[k] = 8'b0;
          end
          // memory[7] = 8'b101010; //points to the begening of the stack
          //                      //source -> Mars
      end
    end


endmodule

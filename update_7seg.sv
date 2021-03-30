`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/04/2018 06:17:30 AM
// Design Name: 
// Module Name: update_7seg
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


//--------------------------------updates 7 sgement----------------------------------//
module update_7seg(
    input clk, //100Mhz on Basys3
	input in0, in1, in2, in3,
	//7-segment signals
	output a, b, c, d, e, f, g, dp, 
    output [3:0] an
);

SevSeg_4digit SevSeg_updater(
	.clk(clk),
	.in3(in3), .in2(in2), .in1(in1), .in0(in0), //user inputs for each digit (hexadecimal)
	.a(a), .b(b), .c(c), .d(d), .e(e), .f(f), .g(g), .dp(dp), // just connect them to FPGA pins (individual LEDs).
	.an(an)   // just connect them to FPGA pins (enable vector for 4 digits active low) 
);
    
endmodule

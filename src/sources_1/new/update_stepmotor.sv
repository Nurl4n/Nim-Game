`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/04/2018 06:09:23 AM
// Design Name: 
// Module Name: update_stepmotor
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


//--------------------------------updates stepmotor----------------------------------//
module update_stepmotor(
    //step motor
    input clk,
	input direction,
	input [1:0] speed,
	output [3:0] phases,
	input stop
);
       
    
stepmotor stepmotor_updater(
        .clk(clk),
        .direction(direction), //user input for motor direction
        .speed(speed), // user input for motor speed
        .phases(phases), // just connect them to FPGA (motor driver)
        .stop(stop) // user input for stopping the motor
    );
endmodule

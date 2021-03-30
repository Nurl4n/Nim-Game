`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/04/2018 06:20:54 AM
// Design Name: 
// Module Name: reset_game
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


//--------------------------------resets game----------------------------------//
module reset_game(
            input clk,
            //7-segment signals
            output a, b, c, d, e, f, g, dp,
            output [3:0] an,
                 
            //step motor
            input direction,
            input [1:0] speed,
            output [3:0] phases,
            input stop,
            
            // FPGA pins for 8x8 display
            output reset_out, //shift register's reset
            output OE,     //output enable, active low 
            output SH_CP,  //pulse to the shift register
            output ST_CP,  //pulse to store shift register
            output DS,     //shift register's serial input data
            output [7:0] col_select // active column, active high
);
    
            //4 numbers to keep value of any of 4 digits
            //user's hex inputs for 4 digits
            logic [3:0] in0 = 4'h0; //initial value
            logic [3:0] in1 = 4'h0; //initial value
            logic [3:0] in2 = 4'h0; //initial value
            logic [3:0] in3 = 4'h0; //initial value
            update_7seg(clk, in0, in1, in2, in3,a, b, c, d, e, f, g, dp,an);
            
            update_stepmotor(clk, direction, speed, phases, stop);
            
            logic [3:0] col_num;
            // initial value for RGB images:
            //    image_???[0]     : left column  .... image_???[7]     : right column
            //    image_???[?]'MSB : top line     .... image_???[?]'LSB : bottom line
            logic [0:7] [7:0] image_red = 
            {8'b00000011, 8'b00000011, 8'b00110011, 8'b00110011, 8'b00110011, 8'b00000011, 8'b00000011, 8'b00000000};
            logic [0:7] [7:0]  image_green = 
            {8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000};
            logic [0:7] [7:0]  image_blue = 
            {8'b00000000, 8'b00001100, 8'b00001100, 8'b11001100, 8'b00001100, 8'b00001100, 8'b00000000, 8'b00000000};
            update_led_matrix(clk, col_num, image_red, image_green, image_blue, reset_out, OE, SH_CP, ST_CP, DS, col_select);    
    
endmodule
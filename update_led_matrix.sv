`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/04/2018 06:19:14 AM
// Design Name: 
// Module Name: update_led_matrix
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


//--------------------------------updates led matrix----------------------------------//
module update_led_matrix(
    input clk, //100Mhz on Basys3
    logic [2:0] col_num,
    logic [0:7] [7:0] image_red,
    logic [0:7] [7:0] image_green,
    logic [0:7] [7:0] image_blue,
	// FPGA pins for 8x8 display
	output reset_out, //shift register's reset
	output OE, 	//output enable, active low 
	output SH_CP,  //pulse to the shift register
	output ST_CP,  //pulse to store shift register
	output DS, 	//shift register's serial input data
	output [7:0] col_select // active column, active high
);    

        
// This module displays 8x8 image on LED display module. 
display_8x8 display_8x8_updater(
        .clk(clk),
        
        // RGB data for display current column
        .red_vect_in(image_red[col_num]),
        .green_vect_in(image_green[col_num]),
        .blue_vect_in(image_blue[col_num]),
        
        .col_data_capture(), // unused
        .col_num(col_num),
        
        // FPGA pins for display
        .reset_out(reset_out),
        .OE(OE),
        .SH_CP(SH_CP),
        .ST_CP(ST_CP),
        .DS(DS),
        .col_select(col_select)   
    );
endmodule

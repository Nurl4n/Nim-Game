`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/04/2018 06:08:02 AM
// Design Name: 
// Module Name: subtractor
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


module subtractor(input reg a, b,
                  output reg difference);
//        wire d,e,f;
        
//        xor(difference,a,b,c);
//        and(d,~a,b);
//        and(e,b,c);
//        and(f,~a,c);
//        or(borrow,d,e,f);
          assign difference = a - b; 

endmodule

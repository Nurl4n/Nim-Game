`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/03/2018 04:18:45 AM
// Design Name: 
// Module Name: Game
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


module Game(input logic clk, 
            input logic rst, i_dlp, i_drp, i_ilp, i_irp, i_chgp, i_selr1, i_selr2, i_selr3, i_selr4,
            output reg a, b, c, d, e, f, g, dp,
            output reg [3:0] an
);            
            reg o_lps, o_rps, o_smp;
            //7-segment signals
             // OUTPUT
                            // OUTPUT
                 
            //step motor
            reg direction;         // INPUT
            reg [1:0] speed;       // INPUT 
            reg [3:0] phases;      // OUTPUT 
            reg stop;              // INPUT
            
            // FPGA pins for 8x8 display
            reg reset_out; //shift register's reset               OUTPUT
            reg OE;     //output enable, active low               OUTPUT
            reg SH_CP;  //pulse to the shift register             OUTPUT
            reg ST_CP;  //pulse to store shift register           OUTPUT
            reg DS;     //shift register's serial input data      OUTPUT
            reg [7:0] col_select; // active column, active high   OUTPUT
            
            //added regs
            reg led_winner;
            reg max_score_lp;
            reg max_score_rp;
            //to count number of sticks left in each row and in total
            reg gameOver;
            reg row1_sticks;
            reg row2_sticks;
            reg row3_sticks;
            reg row4_sticks;
            // synchronized values
            reg i_chgp_sync;
            
            
//            logic counter;
//            logic clock = 0;
//            always_ff@(posedge clk)
//                begin
//                    counter = counter + speed;  
//                    if(counter % 1000000 == 0)
//                        clock = ~clock;
//                end
            
            assign o_lps = 0;
            assign o_rps = 0;
            
            // led
            assign row1_sticks = 1;
            assign row2_sticks = 3;
            assign row3_sticks = 5;
            assign row4_sticks = 7;   
            assign gameOver = 16;
            
            //7_seg
            assign an = 1111;
            
            // stepmotor
            assign speed = 1;
            assign stop = 1;
            
            
            //subtarctor s_dlp(o_lps, 1, o_lps);
            update_7seg up_7seg1(clk, 1, o_lps, 1, o_rps, a, b, c, d, e, f, g, dp,an);
            reset_game rg(clk, a, b, c, d, e, f, g, dp, an, direction, speed, phases, stop, reset_out, 
                                        OE, SH_CP, ST_CP, DS, col_select);
//            always_ff @(negedge i_chgp)
//                begin
//                    update_stepmotor sm_chgp(clk, direction, speed, phases, stop);    
//                end   
             //decrease left player score
            always @(posedge clk)
                begin
                    if(i_dlp == 0)
                        begin
                            subtarctor s_dlp(o_lps, 1, o_lps);
                            update_7seg up_7seg1(clk, 1, o_lps, 1, o_rps, a, b, c, d, e, f, g, dp,an);
                            //update_7seg(clk, in0, in1, in2, in3,a, b, c, d, e, f, g, dp,an);  
                        end
                    if(i_drp == 0)
                        begin
                            subtarctor s_drp(o_rps, 1, o_rps);
                            update_7seg up_7seg2(clk, 1, o_lps, 1, o_rps, a, b, c, d, e, f, g, dp,an);
                            //update_7seg(clk, in0, in1, in2, in3,a, b, c, d, e, f, g, dp,an);   
                        end 
                    if(i_ilp == 0)
                        begin
                            adder a_ilp(o_lps, 1, o_lps);
                            update_7seg up_7seg3(clk, 1, o_lps, 1, o_rps, a, b, c, d, e, f, g, dp,an);
                            //update_7seg(clk, in0, in1, in2, in3,a, b, c, d, e, f, g, dp,an);
                        end
                    if(i_irp == 0)
                        begin
                           adder a_irp(o_lps, 1, o_lps);
                           update_7seg up_7seg4(clk, 1, o_lps, 1, o_rps, a, b, c, d, e, f, g, dp,an);
                           //update_7seg(clk, in0, in1, in2, in3,a, b, c, d, e, f, g, dp,an);
                        end
                        
                    //resets game to default
                    if(rst == 0)
                        begin
                            reset_game rg(clk, a, b, c, d, e, f, g, dp, an, direction, speed, phases, stop, reset_out, 
                            OE, SH_CP, ST_CP, DS, col_select);
                        end 
                    
                    // change player    
                    button_synchronizer_FSM bs_i_chngp(clk, i_chgp, i_chgp_sync);   
                    if(i_chgp_sync == 1)  
                        begin
                            update_stepmotor sm_chgp(clk, direction, speed, phases, stop);
                        end 
                    
                                              
                end
            
            
            always_ff @(posedge i_selr1 or posedge i_selr2 or posedge i_selr3 or posedge i_selr4)
                begin
                    if(i_selr1 == 1)
                        if(row1_sticks > 0)
                            begin
                                subtractor s_selr1(row1_sticks, 1, row1_sticks);
                                subtractor s_gameOver(gameOver, 1, gameOver);
                            end
                    if(i_selr2 == 1)
                        if(row2_sticks > 0)
                            begin
                                subtractor s_selr2(row2_sticks, 1, row3_sticks);
                                subtractor s_gameOver(gameOver, 1, gameOver);
                            end
                    if(i_selr3 == 1)
                        if(row3_sticks > 0)
                            begin
                                subtractor s_selr3(row3_sticks, 1, row3_sticks);
                                subtractor s_gameOver(gameOver, 1, gameOver);
                            end
                    if(i_selr4 == 1)
                        if(row4_sticks > 0)
                            begin
                                subtractor s_selr4(row4_sticks, 1, row4_sticks);
                                subtractor s_gameOver(gameOver, 1, gameOver);
                            end  
                end     
                
                                                                 
endmodule








//            logic counter_i_dlp;
//            always @(posedge clk, negedge i_dlp)
//                begin
//                    counter_i_dlp = counter_i_dlp + 1;  
//                    if(counter_i_dlp % 1000000 == 0)
//                        subtarctor s_dlp(o_lps, 1, o_lps);
//                    update_7seg(clk, 1, o_lps, 1, o_rps, a, b, c, d, e, f, g, dp,1111);
//                    //update_7seg(clk, in0, in1, in2, in3,a, b, c, d, e, f, g, dp,an);    
//                end
//            logic counter_i_drp;
//            always @(posedge clk, negedge i_drp)
//                begin
//                        counter_i_drp = counter_i_drp + 1;  
//                        if(counter_i_drp % 1000000 == 0)
//                            subtarctor s_drp(o_rps, 1, o_rps);
//                        update_7seg(clk, 1, o_lps, 1, o_rps, a, b, c, d, e, f, g, dp,1111);
//                        //update_7seg(clk, in0, in1, in2, in3,a, b, c, d, e, f, g, dp,an);    
//                    end
//            logic counter_i_ilp;
//            always @(posedge clk, negedge i_ilp)
//                begin
//                    counter_i_ilp = counter_i_ilp + 1;  
//                    if(counter_i_ilp % 1000000 == 0)
//                        adder a_ilp(o_lps, 1, o_lps);
//                    update_7seg(clk, 1, o_lps, 1, o_rps, a, b, c, d, e, f, g, dp,1111);
//                    //update_7seg(clk, in0, in1, in2, in3,a, b, c, d, e, f, g, dp,an);    
//                end
//            logic counter_i_irp;
//            always @(posedge clk, negedge i_irp)
//                begin
//                    counter_i_irp = counter_i_irp + 1;  
//                    if(counter_i_irp % 1000000 == 0)
//                        adder a_irp(o_rps, 1, o_rps);
//                    update_7seg(clk, 1, o_lps, 1, o_rps, a, b, c, d, e, f, g, dp,1111);
//                    //update_7seg(clk, in0, in1, in2, in3,a, b, c, d, e, f, g, dp,an);    
//                end





//            assign o_lps = 0;
//            assign o_rps = 0;
            
//            // decrease left player score
//            always @(negedge i_dlp)
//                begin
//                    subtarctor s_dlp(o_lps, 1, o_lps);
//                    update_7seg(clk, 1, o_lps, 1, o_rps, a, b, c, d, e, f, g, dp,1111);
//                    //update_7seg(clk, in0, in1, in2, in3,a, b, c, d, e, f, g, dp,an);    
//                end
             
//            // decrease right player score    
//            always @(negedge i_drp)
//                begin
//                    subtarctor s_drp(o_rps, 1, o_rps);
//                    update_7seg(clk, 1, o_lps, 1, o_rps, a, b, c, d, e, f, g, dp,1111);
//                    //update_7seg(clk, in0, in1, in2, in3,a, b, c, d, e, f, g, dp,an);    
//                end
                
//            // increase left player score
//            always @(negedge i_ilp)
//                begin
//                    adder a_ilp(o_lps, 1, o_lps);
//                    update_7seg(clk, 1, o_lps, 1, o_rps, a, b, c, d, e, f, g, dp,1111);
//                    //update_7seg(clk, in0, in1, in2, in3,a, b, c, d, e, f, g, dp,an);    
//                end
            
//            // increase right player score
//            always @(negedge i_irp)
//                begin
//                    adder a_irp(o_rps, 1, o_rps);
//                    update_7seg(clk, 1, o_lps, 1, o_rps, a, b, c, d, e, f, g, dp,1111);
////                  update_7seg(clk, in0, in1, in2, in3,a, b, c, d, e, f, g, dp,an);    
//                end  
            
//            // changes player
              
//            always @(negedge i_chgp)
//                begin
//                    update_stepmotor sm_chgp(clk, direction, speed, phases, stop);    
//                end    


//// changes player
              
//            always @(negedge i_chgp)
//                begin
//                    update_stepmotor sm_chgp(clk, direction, speed, phases, stop);    
//                end 


//            assign direction = 0;    
//            logic counter_stop;
//            always @(posedge i_chgp)
//                begin
//                    counter_stop = counter_stop + 1;  
//                    if(counter_stop % 1000000 == 0)
//                        begin
//                            update_stepmotor sm_stop(clk, direction, speed, phases, stop);
//                            direction = ~direction;
                            
//                        end    
//                    //update_7seg(clk, in0, in1, in2, in3,a, b, c, d, e, f, g, dp,an);   
//                end   
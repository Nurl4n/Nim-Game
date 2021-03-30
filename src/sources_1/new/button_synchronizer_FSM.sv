`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 05/04/2018 08:43:47 AM
// Design Name:
// Module Name: button_synchronizer_FSM
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


module button_synchronizer_FSM(input logic clk, i_button,
                               output logic o_button);

        typedef enum logic [1:0] {S0,S1,S2,S3} stateType;
        stateType state, nextState;

        always @(posedge clk)
            begin
                 case (state)
                        S0:
                                    if(~i_button)
                                        begin
                                            o_button <= 0;
                                            nextState <= S0;
                                        end
                                   else
                                        begin
                                            nextState <= S1;
                                            o_button <= 1;
                                        end
                        S1:        if(~i_button)
                                        begin
                                              nextState <= S0;
                                              o_button <= 0;
                                        end
                                  else
                                        begin
                                              nextState <= S2;
                                              o_button <= 0;
                                        end
                        S2:        if(i_button)
                                        begin
                                              nextState <= S2;
                                              o_button <= 0;
                                        end
                                   else
                                        begin
                                              nextState <= S0;
                                              o_button <= 0;
                                        end
                  endcase
            end
endmodule

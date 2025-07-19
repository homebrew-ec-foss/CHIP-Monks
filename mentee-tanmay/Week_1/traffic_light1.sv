`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.10.2024 21:42:19
// Design Name: 
// Module Name: exp_vend
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Commenshortt:
// 
//////////////////////////////////////////////////////////////////////////////////


module exp_traffic1(
            input logic clk,reset,
            input logic cow1,
            output logic Highway_R,Highway_Y,Highway_G,Farm_R,Farm_Y,Farm_G);

            logic cow1reg;
            integer count;

            parameter 
                S0=6'b001100,
                S1=6'b010100,
                S2=6'b100001,
                S3=6'b100010;
            logic [5:0]state1,statenext;

            assign {Highway_R, Highway_Y, Highway_G, Farm_R, Farm_Y, Farm_G} = state1;      
            
            always_ff @(posedge clk) 
                        begin          
                            if (reset) 
                                begin
                                    cow1reg <= 0;
                                    state1 <= S0;
                                    count <= 0;
                                end 
                            else 
                                begin
                                    cow1reg <= cow1;
                                    if (state1 == statenext)
                                        count <= count + 1;
                                    else
                                        count <= 0;
                                    state1 <= statenext;
                                end
                        end 
                                                  
            always_comb
                       begin
                           case(state1)
                               S0: 
                                   if(cow1reg==1 & count==4'd14)      
                                       begin 
                                           statenext =S1; 
                                       end
                               S1: 
                                   if(count==4'd2)      
                                       begin 
                                           statenext =S2;  
                                       end
                               S2: 
                                   if(cow1reg==0 | count==4'd14)      
                                       begin 
                                           statenext = S3;  
                                       end
                               S3:
                                   if(count==4'd2)      
                                       begin  
                                           statenext = S0; 
                                       end                                                                           
                               default:
                                   begin 
                                       statenext = S0; 
                                   end
                               endcase
               end                         
endmodule

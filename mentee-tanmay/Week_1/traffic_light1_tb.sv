`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.10.2024 21:03:04
// Design Name: 
// Module Name: exp_6a_tb
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


module exp_traffic1_tb();
    logic clk,reset;
    logic cow1;
    logic Highway_R,Highway_Y,Highway_G,Farm_R,Farm_Y,Farm_G;
    exp_traffic1 UUT(.clk(clk),.reset(reset),.cow1(cow1),.Highway_R(Highway_R),.Highway_Y(Highway_Y),.Highway_G(Highway_G),.Farm_R(Farm_R),.Farm_Y(Farm_Y),.Farm_G(Farm_G));
    
    always #5 clk=(~clk);
    
    initial
        begin
        clk = 0;reset = 1;
        cow1 = 0;
        #10;
        reset = 0;
        #50;
        cow1 = 1;
        #150;
        #30;
        #150;
        cow1 = 0;
        #30;
        #50;
        $finish;
        end
endmodule

`timescale 1ns / 1ps


module chip8_mem( 
    input wire clk,
    input wire write,
    input wire read,
    input wire [7:0] mem_data_in,
    input wire [11:0] mem_address,
    output reg [7:0] mem_data_out
    );

reg [7:0] memory[0:4095];

always @(posedge clk) begin
    if (read) begin
        mem_data_out <= memory[mem_address];
    end
    else begin
        memory[mem_address] <= mem_data_in;
    end
end     
    
endmodule

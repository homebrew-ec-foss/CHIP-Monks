`timescale 1ns / 1ps

module chip8_display(
    input wire clk,
    input wire reset,
    input wire draw,
    input wire [5:0] x,
    input wire [4:0] y,
    input wire [3:0] row_index,
    input wire [7:0] sprite_data,
    input wire [2047:0] display_in,
    output reg  [2047:0] display_out,
    output reg collision
    );
    
     reg [2047:0] next_display;
     reg collide;
     integer i;
     integer index;
    
    always @(*) begin
        
        collide = 0;
        next_display = display_in;
        
        for (i = 0;i<8;i=i+1) begin
        if (sprite_data[7-i]) begin
                index = ((y + row_index) % 32) * 64 + ((x + i) % 64);
            
                if (display_in[index])
                        collide = 1;
                         
                next_display[index] = display_in[index] ^ 1'b1;
            end
        end
    end
    
    always @(posedge clk) begin
        if (reset) {display_out, collision} <= 0;
        end else if (draw) begin
            display_out <= next_display;
            collision <= collide;
        end
    end
endmodule

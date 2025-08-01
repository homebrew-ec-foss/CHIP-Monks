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
     reg collision_next;
     integer x_cord,y_cord;
     integer i;
     integer index;
    
    always @(*) begin
        
        collision_next = 0;
        next_display = display_in;
        
        for (i = 0;i<8;i=i+1) begin
        if (sprite_data[7-i]) begin
                x_cord = (x + i) % 64;
                y_cord = (y + row_index) % 32;
                index <= y_cord * 64 + x_cord;
                
    
                if (display_in[index])
                        collision_next = 1;
                         
                next_display[index] = display_in[index] ^ 1'b1;
            end
        end
    end
    
    always @(posedge clk) begin
        if (reset) begin
            display_out <= 0;
            collision <= 0;
        end else if (draw) begin
            display_out <= next_display;
            collision <= collision_next;
        end
    end
endmodule

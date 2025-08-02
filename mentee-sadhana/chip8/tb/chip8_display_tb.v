`timescale 1ns / 1ps

module chip8_display_tb;
    parameter CLK_PERIOD = 10; 
    reg clk;
    reg reset;
    reg draw;
    reg [5:0] x;
    reg [4:0] y;
    reg [3:0] row_index;
    reg [7:0] sprite_data;
    reg [2047:0] display_in;
    wire [2047:0] display_out;
    wire collision;


    chip8_display DUT (
        .clk(clk),
        .reset(reset),
        .draw(draw),
        .x(x),
        .y(y),
        .row_index(row_index),
        .sprite_data(sprite_data),
        .display_in(display_in),
        .display_out(display_out),
        .collision(collision)
    );

    // Clock generation
    always begin
        clk = 1'b0;
        #(CLK_PERIOD/2);
        clk = 1'b1;
        #(CLK_PERIOD/2);
    end


    initial begin
        reset = 1'b1;
        draw = 1'b0;
        x = 6'b0;
        y = 5'b0;
        row_index = 4'b0;
        sprite_data = 8'b0;
        display_in = 2048'b0;

        // Reset
        #10;
        reset = 1'b0;
        $display("Time=%0t: Clear Display.", $time);

        // Draw sprite 
        #10;
        x = 6'd60; 
        y = 5'd1;  
        row_index = 4'd0;
        sprite_data = 8'h0F; 
        display_in = display_out;
        draw = 1'b1;
        #10;
        draw = 1'b0;
        $display("Time=%0t: Drawing sprite. Collision=%b", $time, collision);
        
        // Collision
        #10;
        display_in = display_out;
        draw = 1'b1;
        #10;
        draw = 1'b0;
        $display("Time=%0t: Collision=%b", $time, collision);

        #100;
        $display("End simulation");
        $finish;
    end
endmodule

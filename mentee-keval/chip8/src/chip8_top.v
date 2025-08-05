`timescale 1ns / 1ps

module chip8_top(
    input wire clk,reset,
    input wire [15:0] key_pressed,
    output wire [2047:0] display
    );
    
    wire [7:0] mem_data_in;
    wire [7:0] mem_data_out;
    wire [7:0] sprite_data;
    wire [3:0] draw_row_index;
    wire [5:0] x;
    wire [4:0] y;
    wire [11:0] mem_addr_out;
    wire mem_read,mem_write;
    wire draw;
    reg [2047:0] display_now;
    wire [2047:0] display_after;
    
    
    chip8_cpu cpu(.clk(clk),.reset(reset),.mem_data_in(mem_data_in),.key_pressed(key_pressed),.mem_read(mem_read),.mem_addr_out(mem_addr_out),.mem_data_out(mem_data_out),.mem_write(mem_write),.draw(draw),.x(x),.y(y),.sprite_data(sprite_data),.draw_row_index(draw_row_index));
    
    chip8_mem mem(.clk(clk),.write(mem_write),.read(mem_read),.mem_data_in(mem_data_in),.mem_data_out(mem_data_out),.mem_address(mem_addr_out));
    
    chip8_display display_module(.clk(clk),.reset(reset),.draw(draw),.x(x),.y(y),.row_index(draw_row_index),.sprite_data(sprite_data),.display_in(display_now),.display_out(display_after),.collision(collision));
    
    always @(posedge clk or posedge reset) begin
    if (reset)
        display_now <= 2048'd0;
    else if (draw)
        display_now <= display_after;
    end

assign display = display_now;

endmodule

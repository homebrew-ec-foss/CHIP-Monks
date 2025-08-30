`timescale 1ns / 1ps

module chip8_top (
    input wire clk,
    input wire reset,
    output wire [2047:0] display_pixels,
    output wire collision_flag,
    output wire [7:0] sound_timer,
    output wire [7:0] delay_timer
);

    // Memory
    wire [11:0] mem_addr;
    wire [7:0] mem_write_data;
    wire [7:0] mem_read_data;
    wire mem_write_en;

    // Display
    wire draw;
    wire [5:0] x;
    wire [4:0] y;
    wire [3:0] row_index;
    wire [7:0] sprite_data;
    wire [2047:0] display_out;
    wire display_update;

    // CPU
    chip8_cpu cpu_inst (
        .clk(clk),
        .reset(reset),
        .mem_read_data(mem_read_data),
        .mem_addr(mem_addr),
        .mem_write_data(mem_write_data),
        .mem_write_en(mem_write_en),
        .display_update(display_update),
        .delay_timer_out(delay_timer),
        .sound_timer_out(sound_timer)
    );

  
    chip8_memory memory_inst (
        .clk(clk),
        .we(mem_write_en),
        .addr(mem_addr),
        .data_in(mem_write_data),
        .data_out(mem_read_data)
    );

 
    chip8_display display_inst (
        .clk(clk),
        .reset(reset),
        .draw(draw),
        .x(x),
        .y(y),
        .row_index(row_index),
        .sprite_data(sprite_data),
        .display_in(display_pixels),
        .display_out(display_pixels),
        .collision(collision_flag)
    );

endmodule


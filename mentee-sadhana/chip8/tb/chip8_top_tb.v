`timescale 1ns / 1ps

module chip8_top_tb();

    reg clk;
    reg reset;

    wire [2047:0] display_pixels;
    wire collision_flag;
    wire [7:0] sound_timer;
    wire [7:0] delay_timer;

    chip8_top dut (
        .clk(clk),
        .reset(reset),
        .display_pixels(display_pixels),
        .collision_flag(collision_flag),
        .sound_timer(sound_timer),
        .delay_timer(delay_timer)
    );


    initial clk = 0;
    always #5 clk = ~clk;

    initial 
    begin
        $display("CHIP-8 Top Module Test bench");
        $dumpfile("chip8_top_tb.vcd"); 
        $dumpvars(0, chip8_top_tb);

        reset = 1;
        #20;        
        reset = 0;

        #1000;

        $display("Delay Timer: %d", delay_timer);
        $display("Sound Timer: %d", sound_timer);
        $display("Collision: %b", collision_flag);
        $display("Simulation complete.");
        $finish;
    end
endmodule


`timescale 1ns / 1ps

module chip8_cpu_tb;

    reg clk;
    reg reset;
    reg  [7:0] mem_read_data;
    wire [11:0] mem_addr;
    wire [7:0] mem_write_data;
    wire mem_write_en;
    wire display_update;
    wire [7:0] delay_timer_out;
    wire [7:0] sound_timer_out;
   
// Initialize DUT
    chip8_cpu dut (
        .clk(clk),
        .reset(reset),
        .mem_addr(mem_addr),
        .mem_write_data(mem_write_data),
        .mem_write_en(mem_write_en),
        .mem_read_data(mem_read_data),
        .display_update(display_update),
        .delay_timer_out(delay_timer_out),
        .sound_timer_out(sound_timer_out)
    );

    reg [7:0] memory [0:4095];
    integer i;

    always #10 clk = ~clk; // clock signal with 10ns High and 10ns Low
    initial clk = 0;

    // Memory read 
    always @(*) begin
        #5 mem_read_data = memory[mem_addr];
    end

    initial begin
        for (i = 0; i < 4096; i = i + 1) memory[i] = 8'h00;

        memory[12'h200] = 8'h00; memory[12'h201] = 8'hE0; // CLS
        memory[12'h202] = 8'h60; memory[12'h203] = 8'h05; // LD V0, 0x05
        memory[12'h204] = 8'h70; memory[12'h205] = 8'h01; // ADD V0, 0x01
        memory[12'h206] = 8'h30; memory[12'h207] = 8'h06; // SE V0, 0x06
        memory[12'h208] = 8'h12; memory[12'h209] = 8'h04; // JP 0x204
        memory[12'h20A] = 8'h12; memory[12'h20B] = 8'h0A; // JP 0x20A - halt

	// Reset sequence
        reset = 1;
        #40 reset = 0;

        $monitor("Time: %0t | PC: %h | V0: %h | Delay: %d | Update: %b | PixelRow0: %h",
                 $time, dut.pc, dut.V[0], delay_timer_out, display_update, dut.display_pixels[0]);

        #2000;
        $display("Simulation finished.");
        $finish;
    end

endmodule

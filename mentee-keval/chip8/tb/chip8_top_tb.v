`timescale 1ns / 1ps

module chip8_top_testbench();

    reg         clock;
    reg         reset;
    reg  [15:0] key_pressed;
    wire [2047:0] display;
    
    chip8_top DUT (
        .clk(clock),
        .reset(reset),
        .key_pressed(key_pressed),
        .display(display)
    );

    initial clock = 0;
    always #10 clock = ~clock;

    initial begin

        key_pressed = 16'd0;
        reset = 1;
        
        $monitor("Time=%0t | PC=%h | State=%d | Opcode=%h | I_reg=%h | V0=%h V1=%h VA=%h VB=%h | mem_addr_out=%h | mem_data_in = %h | mem_data_out = %h | mem_read = %h | mem_write = %h",
                 $time,
                 DUT.cpu.pc,           
                 DUT.cpu.state,        
                 DUT.cpu.opcode,       
                 DUT.cpu.I,            
                 DUT.cpu.V[0],         
                 DUT.cpu.V[1],         
                 DUT.cpu.V[10],        
                 DUT.cpu.V[11],         
                 DUT.cpu.mem_addr_out,
                 DUT.cpu.mem_data_in,
                 DUT.cpu.mem_data_out,
                 DUT.cpu.mem_read,
                 DUT.cpu.mem_write
        );
        
        #20;
        reset = 0;
        
        #10000;
        $finish;
    end

endmodule

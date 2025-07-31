`timescale 1ns / 1ps

module test_bench_chip8_memory;

    // Drive signals
    reg clk;
    reg we;
    reg [11:0] addr;
    reg [7:0] data_in;

    // Receives signals
    wire [7:0] data_out;

    chip8_memory DUT (.clk(clk), .we(we), .addr(addr), .data_in(data_in), .data_out(data_out));

    // Clock signal for 10ns
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test Sequence
    initial begin
        we = 0;
        addr = 12'h000;
        data_in = 8'h00;

        $display("Start CHIP-8 Memory Test Bench at %0t", $time);
        #10;

        
        // Read operation 
        addr = 12'h000; 
        we = 0; 
        #10;
        $display("Reading from address 0x%h. Got: 0x%h", addr, data_out);

        // Write operation
        we = 1; 
        addr = 12'h200;
        data_in = 8'hAA;
        #10;
        $display("Writing value 0x%h to address 0x%h.", data_in, addr);

        // Read the written value
        we = 0; 
        #10;
        $display("Reading from address 0x%h. Got: 0x%h", addr, data_out);

        $display("Finished Test Bench at time %0t", $time);
        $finish;
    end

endmodule

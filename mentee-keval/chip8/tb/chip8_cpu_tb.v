`timescale 1ns / 1ps


module chip8_cpu_tb();
reg clk;
reg reset;
reg [7:0] mem_data_in;
reg [15:0] key_pressed;

wire mem_read;
wire [11:0] mem_addr_out;
wire [7:0] mem_data_out;
wire mem_write;
wire [3:0] flag;

reg [7:0] memory[0:4095];

chip8_cpu DUT (.clk(clk),
               .reset(reset),
               .mem_data_in(mem_data_in),
               .mem_read(mem_read),
               .mem_addr_out(mem_addr_out),
               .mem_data_out(mem_data_out),
               .mem_write(mem_write),
               .flag(flag),
               .key_pressed(key_pressed));
               
    always #10 clk = ~clk;    
    initial clk = 0;    
        
    initial begin
        
      $readmemh("program_tb.mem",memory); // HERE CHANGE THE MEM FILE FOR THE TESTS THAT YOU WANT 
        $monitor("clk = %b, reset = %b, mem_data_in = %h, mem_read = %b, mem_addr_out = %h, mem_data_out = %h, mem_write = %b, flag = %h, opcode = %h, msbcode = %h, lsbcode = %h",clk,reset,mem_data_in,mem_read,mem_addr_out,mem_data_out,mem_write,flag,DUT.opcode,DUT.opcode_fh,DUT.opcode_sh);
        
        
        reset = 1;
        #10;
        reset = 0;
        
        #100000;
        $finish;
    end
    
        
    always @(posedge clk) begin
        if (mem_read == 1)
            mem_data_in <= memory[mem_addr_out];
            
        if (mem_write == 1)
            memory[mem_addr_out] <= mem_data_out;
    end
        
    
endmodule

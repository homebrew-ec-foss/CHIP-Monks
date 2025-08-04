`timescale 1ns / 1ps

module chip8_mem_tb;

reg clk;
reg write;
reg read;
reg [7:0] mem_data_in;
reg [11:0] mem_address;
wire [7:0] mem_data_out;
integer i;

initial clk = 0;
always #10 clk = ~clk;

chip8_mem DUT(.clk(clk),.read(read),.mem_data_in(mem_data_in),.mem_address(mem_address),.mem_data_out(mem_data_out));

initial begin

    $monitor("clk = %b | write = %b | read = %b | mem_data_in = %h | mem_address = %h | mem_data_out = %h",clk,write,read,mem_data_in,mem_address,mem_data_out);
    
    
    
    #10
    read = 1;
    mem_address = 12'h200;
    
    #10
    for (i=0;i<20;i=i+1) begin
        #10
        mem_address = mem_address + 1;
    end
    
    #10
    mem_address = 12'h300;
    
    #10
    for (i=0;i<10;i=i+1) begin
        #10
        mem_address = mem_address + 1;
    end
    
    #10
    read = 0;
    
    #10
    mem_address = 12'h600;
    write = 1;
    mem_data_in = 8'h34;
    
    #10
    mem_address = 12'h601;
    write = 1;
    mem_data_in = 8'h43;
   
    #10
    read = 1;
    write = 0;
    
    #10
    mem_address = 12'h600;
    
    #10
    mem_address = 12'h601;
    
    #5000
    $finish;
     
end

endmodule

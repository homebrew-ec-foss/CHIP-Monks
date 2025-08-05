`timescale 1ns / 1ps


module chip8_mem( 
    input wire clk,
    input wire write,
    input wire read,
    input wire [7:0] mem_data_in,
    input wire [11:0] mem_address,
    output reg [7:0] mem_data_out
    );

reg [7:0] memory[0:4095];

initial begin

        memory[0] = 8'hF0; memory[1] = 8'h90; memory[2] = 8'h90; memory[3] = 8'h90; memory[4] = 8'hF0;
        memory[5] = 8'h20; memory[6] = 8'h60; memory[7] = 8'h20; memory[8] = 8'h20; memory[9] = 8'h70;
        memory[10] = 8'hF0; memory[11] = 8'h10; memory[12] = 8'hF0; memory[13] = 8'h80; memory[14] = 8'hF0;
        memory[15] = 8'hF0; memory[16] = 8'h10; memory[17] = 8'hF0; memory[18] = 8'h10; memory[19] = 8'hF0;
        memory[20] = 8'h90; memory[21] = 8'h90; memory[22] = 8'hF0; memory[23] = 8'h10; memory[24] = 8'h10;
        memory[25] = 8'hF0; memory[26] = 8'h80; memory[27] = 8'hF0; memory[28] = 8'h10; memory[29] = 8'hF0;
        memory[30] = 8'hF0; memory[31] = 8'h80; memory[32] = 8'hF0; memory[33] = 8'h90; memory[34] = 8'hF0;
        memory[35] = 8'hF0; memory[36] = 8'h10; memory[37] = 8'h20; memory[38] = 8'h40; memory[39] = 8'h40;
        memory[40] = 8'hF0; memory[41] = 8'h90; memory[42] = 8'hF0; memory[43] = 8'h90; memory[44] = 8'hF0;
        memory[45] = 8'hF0; memory[46] = 8'h90; memory[47] = 8'hF0; memory[48] = 8'h10; memory[49] = 8'hF0;
        memory[50] = 8'hF0; memory[51] = 8'h90; memory[52] = 8'hF0; memory[53] = 8'h90; memory[54] = 8'h90;
        memory[55] = 8'hE0; memory[56] = 8'h90; memory[57] = 8'hE0; memory[58] = 8'h90; memory[59] = 8'hE0;
        memory[60] = 8'hF0; memory[61] = 8'h80; memory[62] = 8'h80; memory[63] = 8'h80; memory[64] = 8'hF0;
        memory[65] = 8'hE0; memory[66] = 8'h90; memory[67] = 8'h90; memory[68] = 8'h90; memory[69] = 8'hE0;
        memory[70] = 8'hF0; memory[71] = 8'h80; memory[72] = 8'hF0; memory[73] = 8'h80; memory[74] = 8'hF0;
        memory[75] = 8'hF0; memory[76] = 8'h80; memory[77] = 8'hF0; memory[78] = 8'h80; memory[79] = 8'h80;
        
        $readmemh("game.mem",memory,512);  
         
        $display("Memory @ 0x200 = %h", memory[512]);   
        $display("Memory @ 0x201 = %h", memory[513]);
        // game.mem will be the memory of the game
              
end


always @(posedge clk) begin
    if (read) begin
        mem_data_out <= memory[mem_address];
    end
    else begin
        memory[mem_address] <= mem_data_in;
    end
end     
    
endmodule

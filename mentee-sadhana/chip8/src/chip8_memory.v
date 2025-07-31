// Stores and retrieves 8-bit data from given 12-bit address

module chip8_memory (
    input wire clk,       
    input wire we,            // Write Enable wire
    input wire [11:0] addr,   // Address input
    input wire [7:0] data_in, // Data to be written
    output reg [7:0] data_out // Data read
);  
    reg [7:0] mem [0:4095]; // The memory array 


    initial begin // First 80 bytes describing fonts for sprites (0-9 and A-F)
        mem[0] = 8'hF0; mem[1] = 8'h90; mem[2] = 8'h90; mem[3] = 8'h90; mem[4] = 8'hF0;
        mem[5] = 8'h20; mem[6] = 8'h60; mem[7] = 8'h20; mem[8] = 8'h20; mem[9] = 8'h70;
        mem[10] = 8'hF0; mem[11] = 8'h10; mem[12] = 8'hF0; mem[13] = 8'h80; mem[14] = 8'hF0;
        mem[15] = 8'hF0; mem[16] = 8'h10; mem[17] = 8'hF0; mem[18] = 8'h10; mem[19] = 8'hF0;
        mem[20] = 8'h90; mem[21] = 8'h90; mem[22] = 8'hF0; mem[23] = 8'h10; mem[24] = 8'h10;
        mem[25] = 8'hF0; mem[26] = 8'h80; mem[27] = 8'hF0; mem[28] = 8'h10; mem[29] = 8'hF0;
        mem[30] = 8'hF0; mem[31] = 8'h80; mem[32] = 8'hF0; mem[33] = 8'h90; mem[34] = 8'hF0;
        mem[35] = 8'hF0; mem[36] = 8'h10; mem[37] = 8'h20; mem[38] = 8'h40; mem[39] = 8'h40;
        mem[40] = 8'hF0; mem[41] = 8'h90; mem[42] = 8'hF0; mem[43] = 8'h90; mem[44] = 8'hF0;
        mem[45] = 8'hF0; mem[46] = 8'h90; mem[47] = 8'hF0; mem[48] = 8'h10; mem[49] = 8'hF0;
        mem[50] = 8'hF0; mem[51] = 8'h90; mem[52] = 8'hF0; mem[53] = 8'h90; mem[54] = 8'h90;
        mem[55] = 8'hE0; mem[56] = 8'h90; mem[57] = 8'hE0; mem[58] = 8'h90; mem[59] = 8'hE0;
        mem[60] = 8'hF0; mem[61] = 8'h80; mem[62] = 8'h80; mem[63] = 8'h80; mem[64] = 8'hF0;
        mem[65] = 8'hE0; mem[66] = 8'h90; mem[67] = 8'h90; mem[68] = 8'h90; mem[69] = 8'hE0;
        mem[70] = 8'hF0; mem[71] = 8'h80; mem[72] = 8'hF0; mem[73] = 8'h80; mem[74] = 8'hF0;
        mem[75] = 8'hF0; mem[76] = 8'h80; mem[77] = 8'hF0; mem[78] = 8'h80; mem[79] = 8'h80;
    end


    always @(posedge clk) begin
        if (we) begin
            mem[addr] <= data_in; // write data
        end else begin
            data_out <= mem[addr]; // read data
        end
    end

endmodule

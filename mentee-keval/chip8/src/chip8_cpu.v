`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.07.2025 16:41:19
// Design Name: 
// Module Name: chip8_cpu
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



module chip8_cpu (
    input wire clk,
    input wire reset,
    input wire [7:0] mem_data_in,
    input wire [15:0] keys,

    output reg mem_read,
    output reg [11:0] mem_addr_out,
    output reg [7:0] mem_data_out,
    output reg mem_write
);
    reg [11:0]    pc;
    reg [11:0]    I;
    reg [7:0]     V[0:15];
    reg [15:0]    opcode;
    reg [3:0]     state;
    reg [3:0]     pc_data;
    reg [11:0]    stack[0:15];
    
    localparam FETCH1 = 0;
    localparam FETCH2 = 1;
    localparam EXECUTE = 2;
    
    always @(posedge clk or posedge reset) begin
        if(reset) begin
            pc <= 12'h200;
            state <= FETCH1;
            opcode <= 0;
            I <= 0;
            mem_read <= 0;
            mem_write <= 0;
            pc_data <= 0;
        end else begin
            mem_read <= 0;
            mem_write <= 0;
        
        case(state)
            FETCH1: begin
                mem_addr_out <= pc;
                mem_read <= 1;
                state <= FETCH2;
            end
            
            FETCH2: begin
                opcode[15:8] <= mem_data_in;
                mem_addr_out <= pc + 1;
                mem_read <= 1;
                state <= EXECUTE;
            end
            
            EXECUTE: begin
                opcode[7:0] <= mem_data_in;
                
                case(opcode[15:12])
                    4'h6: begin
                        V[opcode[11:8]] <= opcode[7:0];
                        pc <= pc + 2;
                        state <= FETCH1;
                    end
                    
                    4'h7: begin
                        V[opcode[11:8]] <= V[opcode[11:8]] + opcode[7:0];
                        pc <= pc + 2;
                        state <= FETCH1;
                    end
                    
                    4'h1: begin
                        pc <= opcode[11:0];
                        state <= FETCH1;
                    end
                    
                    4'h2: begin
                        stack[pc_data] <= pc + 2;
                        pc <= opcode[11:0];
                        pc_data <= pc_data + 1;
                        state <= FETCH1;
                    end
                    
                    4'h3: begin
                        if (V[opcode[11:8]] == opcode[7:0])
                            pc <= pc + 4;
                        else 
                            pc <= pc + 2;
                        state <= FETCH1;
                    end
                    
                    4'h4: begin
                        if (V[opcode[11:8]] != opcode[7:0])
                            pc <= pc + 4;
                        else 
                            pc <= pc + 2;
                        state <= FETCH1;
                    end
                    
                    4'hA: begin 
                        I <= opcode[11:0];
                        pc <= pc + 2;
                        state <= FETCH1;
                    end
                    
                    default: begin
                        pc <= pc + 2;
                        state <= FETCH1;
                    end
            endcase 
          end
        endcase
      end
    end
endmodule

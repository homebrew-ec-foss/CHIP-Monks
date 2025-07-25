    `timescale 1ns / 1ps
    
    module chip8_cpu (
        input wire clk,
        input wire reset,
        input wire [7:0] mem_data_in,
        input wire [15:0] key_pressed,
    
        output reg mem_read,
        output reg [11:0] mem_addr_out,
        output reg [7:0] mem_data_out,
        output reg mem_write,
        output reg [3:0] flag
    );
        reg [11:0]    pc;
        reg [11:0]    I;
        reg [7:0]     V[0:15];
        reg [15:0]    opcode;
        reg [3:0]     state;
        reg [3:0]     pc_data;
        reg [11:0]    stack[0:15];
        reg [7:0]     opcode_fh;
        reg [7:0]     opcode_sh;
        reg [7:0]     delay_timer,sound_timer; 
        reg [20:0]    one_hz;
        reg [3:0]     i;
        
        localparam FETCH1 = 0;
        localparam FETCH1_WAIT = 1;
        localparam FETCH2 = 2;
        localparam FETCH2_WAIT = 3;
        localparam LASTFETCH = 4;
        localparam EXECUTE = 5;
        localparam LASTFETCH_WAIT = 6;
        localparam STORE = 7;
        localparam RETRIEVE = 8;
        localparam RETRIEVE_WAIT = 9;
        
        always @(posedge clk or posedge reset) begin
            if(reset) begin
                pc <= 12'h200;
                state <= FETCH1;
                opcode <= 0;
                I <= 12'd0;
                opcode_fh <= 0;
                opcode_sh <= 0;
                mem_read <= 0;
                mem_write <= 0;
                delay_timer <= 0;
                pc_data <= 0;
                one_hz <= 0;
                sound_timer <= 0;
            end else begin
                if (one_hz == 833333) begin // calculation of 1/60 th second using the clk signal (50000000/833333 = 60Hz)
                    one_hz <= 0;
                    if (delay_timer > 0)
                        delay_timer <= delay_timer - 1;
                    if (sound_timer > 0)
                        sound_timer <= sound_timer - 1;
                end else begin
                    one_hz <= one_hz + 1;
                end

                mem_read <= 0;
                mem_write <= 0;
            
            case(state)
                FETCH1: begin
                    flag <= 4'h0; // for debug
                    mem_addr_out <= pc;
                    mem_read <= 1;
                    state <= FETCH1_WAIT;
                end
                
                FETCH1_WAIT: begin
                    state <= FETCH2;
                end
                
                FETCH2: begin
                    flag <= 4'h1; // for debug
                    opcode_fh <= mem_data_in;
                    mem_addr_out <= pc + 1;
                    mem_read <= 1;
                    state <= FETCH2_WAIT;
                end
                
                FETCH2_WAIT: begin
                    state <= LASTFETCH;
                end
                
                LASTFETCH: begin
                    flag <= 4'h2; // for debug
                    opcode_sh <= mem_data_in;
                  //opcode <= {opcode_fh, opcode_sh};
                    state <= LASTFETCH_WAIT;
                end 
                
                LASTFETCH_WAIT: begin
                    opcode <= {opcode_fh, opcode_sh};
                    state <= EXECUTE;
                end
                
                EXECUTE: begin
                    flag <= 4'h3; // for debug
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
                            flag <= 4'h4;
                            pc <= opcode[11:0];
                            state <= FETCH1;
                        end 
                        
                        4'h2: begin
                            stack[pc_data] <= pc + 2;
                            pc <= opcode[11:0];
                            pc_data <= pc_data + 1;
                            state <= FETCH1;
                        end
                        
                        4'h9: begin
                            if (V[opcode[11:8]] != V[opcode[7:4]])
                                pc <= pc + 4;
                            else
                                pc <= pc + 2;
                            state <= FETCH1;
                        end
                        
                        4'h5: begin
                            if (V[opcode[11:8]] == V[opcode[7:4]])
                                pc <= pc + 4;
                            else
                                pc <= pc + 2;
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
                        
                        4'h8: begin
                            case(opcode[3:0])
                                4'h0: begin
                                    V[opcode[11:8]] <= V[opcode[7:4]];
                                    pc <= pc + 2;
                                    state <= FETCH1;
                                end
                                
                                4'h1: begin
                                    V[opcode[11:8]] <= V[opcode[11:8]] | V[opcode[7:4]];
                                    pc <= pc + 2;
                                    state <= FETCH1;
                                end
                                
                                4'h2: begin
                                    V[opcode[11:8]] <= V[opcode[11:8]] & V[opcode[7:4]];
                                    pc <= pc + 2;
                                    state <= FETCH1;
                                end
                                
                                4'h3: begin
                                    V[opcode[11:8]] <= V[opcode[11:8]] & V[opcode[7:4]];
                                    pc <= pc + 2;
                                    state <= FETCH1;
                                end
                                
                                4'h4: begin
                                    {V[15],V[opcode[11:8]]} <= V[opcode[7:4]] + V[opcode[11:8]];
                                    pc <= pc + 2;
                                    state <= FETCH1;
                                end
                                
                                4'h5: begin
                                    {V[15],V[opcode[11:8]]} <= V[opcode[7:4]] - V[opcode[11:8]];
                                    pc <= pc + 2;
                                    state <= FETCH1;
                                end
                                
                                4'h6: begin
                                    V[opcode[11:8]] <= V[opcode[7:4]];
                                    V[opcode[11:8]] <= V[opcode[11:8]] >> 1;
                                    pc <= pc + 2;
                                    state <= FETCH1;
                                end 
                                
                                4'h7: begin
                                    {V[15],V[opcode[11:8]]} <= V[opcode[11:8]] - V[opcode[7:4]];
                                    pc <= pc + 2;
                                    state <= FETCH1;
                                end
                                
                                4'hE: begin
                                    V[opcode[11:8]] <= V[opcode[7:4]];
                                    V[opcode[11:8]] <= V[opcode[11:8]] << 1;
                                    pc <= pc + 2;
                                    state <= FETCH1;
                                end                                
                            endcase
                        end
                        
                        4'hA: begin 
                            I <= opcode[11:0];
                            pc <= pc + 2;
                            state <= FETCH1;
                        end
                        
                        4'hB: begin
                            pc <= opcode[11:0];
                            V[opcode[11:8]] <= opcode[11:0];
                            state <= FETCH1;
                        end
                        
                        4'hC: begin
                            V[opcode[11:8]] <= opcode[7:0] & $random;
                            pc <= pc + 2;
                            state <= FETCH1;
                        end
                        
                        4'hE: begin
                            case(opcode[3:0])
                                4'hE: begin
                                    if (key_pressed[V[opcode[11:8]]])
                                        pc <= pc + 4;
                                    else
                                        pc <= pc + 2;
                                    state <= FETCH1;
                                end
                                
                                4'h1: begin
                                    if (key_pressed[V[opcode[11:8]]] != 1)
                                        pc <= pc + 4;
                                    else
                                        pc <= pc + 2;
                                    state <= FETCH1;
                                end
                            endcase        
                        end    
                        
                        4'hF: begin
                            case(opcode[7:0])
                                8'h07: begin
                                    V[opcode[11:8]] <= delay_timer;
                                    pc <= pc + 2;
                                    state <= FETCH1; 
                                end
                                
                                8'h0A: begin       // TO BE DONE 
                                    pc <= pc + 2;  // TO BE DONE 
                                end                // TO BE DONE 
                                
                                8'h15: begin
                                    delay_timer <= V[opcode[11:8]];
                                    pc <= pc + 2;
                                    state <= FETCH1;
                                end
                                
                                8'h18: begin
                                    sound_timer <= V[opcode[11:8]];
                                    pc <= pc + 2;
                                    state <= FETCH1;
                                end
                                
                                8'h1E: begin
                                    I <= I + V[opcode[11:8]];
                                    pc <= pc + 2;
                                    state <= FETCH1;
                                end
                                
                                8'h29: begin        // TO BE DONE 
                                    pc <= pc + 2;   // TO BE DONE
                                end                 // TO BE DONE 
                                
                                8'h33: begin        // TO BE DONE
                                    pc <= pc + 2;   // TO BE DONE
                                end                 // TO BE DONE 
                                
                                8'h55: begin
                                    i <= 0;
                                    state <= STORE;
                                end
                                
                                8'h65: begin
                                    i <= 0;
                                    state <= RETRIEVE;
                                end 
                                
                            endcase
                        end
                        
                        4'hD: begin   // TO BE DONE
                        pc <= pc + 2; // TO BE DONE
                        end           // TO BE DONE
                        
                        default: begin
                            pc <= pc + 2;
                            state <= FETCH1;
                        end
                        
                        4'h0: begin
                            case(opcode[3:0])
                                4'h0: begin
                                    pc <= pc + 2;
                                end 
                                
                                4'hE: begin
                                    pc <= stack[pc_data - 1];
                                    pc_data <= pc_data - 1;
                                end
                            endcase     
                        end
                        
                    endcase 
                end
              
                STORE: begin 
                    mem_addr_out <= I + i;
                    mem_data_out <= V[i];
                    mem_write <= 1;
                    
                    if (i == opcode[11:8]) begin
                        pc <= pc + 2;
                        state <= FETCH1;
                    end else begin
                        i <= i+1;
                        state <= STORE;
                    end
                end
                
                RETRIEVE: begin
                    if(i <= opcode[11:8]) begin
                        mem_addr_out <= I + i;
                        mem_read <= 1;
                    end
                    else begin  
                        pc <= pc + 2;
                        state <= FETCH1;
                    end
                end
                    
                RETRIEVE_WAIT: begin
                  V[i] <= mem_data_in;
                  i <= i + 1;
                  state <= RETRIEVE;  
                end                
            endcase
          end
        end
    endmodule

module chip8_cpu (
    input wire clk,
    input wire reset,
    input wire [7:0] mem_read_data,
    output reg [11:0] mem_addr,
    output reg [7:0] mem_write_data,
    output reg mem_write_en,
    output reg display_update,
    output wire [7:0] delay_timer_out,
    output wire [7:0] sound_timer_out
);

//Registers and Wires
    reg [11:0] pc;
    reg [7:0] V[0:15];
    reg [11:0] I;
    reg [11:0] stack[0:15];
    reg [3:0] sp;
    reg [7:0] delay_timer;
    reg [7:0] sound_timer;
    reg [5:0] timer_divider;
    reg [15:0] instruction;
    reg [7:0] instr_high_byte;
    reg [63:0] display_pixels [0:31];

    wire [3:0] opcode_nibble = instruction[15:12];
    wire [11:0] NNN = instruction[11:0];
    wire [7:0] NN = instruction[7:0];
    wire [3:0] X = instruction[11:8];
    wire [3:0] Y = instruction[7:4];
    wire [3:0] N = instruction[3:0];

// State Machine Parameters
    parameter FETCH_HIGH = 2'b00; // Fetch most significant byte of instruction
    parameter FETCH_LOW  = 2'b01; // Fetch least significant byte of instruction 
    parameter EXECUTE    = 2'b10; // Execute instruction

    reg [1:0] cpu_state;

    integer i, y;

    initial begin
        pc = 12'h200;
        I = 12'h000;
        sp = 0;
        delay_timer = 0;
        sound_timer = 0;
        timer_divider = 0;
        cpu_state = FETCH_HIGH;
        mem_write_en = 0;
        display_update = 0;
        for (i = 0; i < 16; i = i + 1) V[i] = 0;
        for (i = 0; i < 16; i = i + 1) stack[i] = 0;
        for (i = 0; i < 32; i = i + 1) display_pixels[i] = 0;
    end

// Main CPU Logic
    always @(posedge clk or posedge reset) begin
    	// Asynchronous reset
        if (reset) begin
            pc <= 12'h200;
            I <= 0;
            sp <= 0;
            delay_timer <= 0;
            sound_timer <= 0;
            timer_divider <= 0;
            cpu_state <= FETCH_HIGH;
            mem_write_en <= 0;
            display_update <= 0;
        end else begin
            // 60Hz time update
            timer_divider <= timer_divider + 1;
            if (timer_divider == 6'd59) begin // Count to 59 then resets
                timer_divider <= 0;
                if (delay_timer > 0) delay_timer <= delay_timer - 1;
                if (sound_timer > 0) sound_timer <= sound_timer - 1;
            end

            case (cpu_state) // Fetch High byte instruction
                FETCH_HIGH: begin
                    mem_addr <= pc;
                    cpu_state <= FETCH_LOW;
                end

                FETCH_LOW: begin // Fetch low byte instruction
                    instr_high_byte <= mem_read_data;
                    mem_addr <= pc + 1;
                    cpu_state <= EXECUTE;
                end

                EXECUTE: begin
                    instruction <= {instr_high_byte, mem_read_data};
                    pc <= pc + 2;

                    case (opcode_nibble)
                        4'h0:
                            if (NNN == 12'h0E0) begin // 00E0 - Clear Display
                                for (y = 0; y < 32; y = y + 1)
                                    display_pixels[y] <= 0;
                                display_update <= 1;
                            end
                        4'h6: V[X] <= NN; // 6XNN - Set Vx=NN
                        4'h7: V[X] <= V[X] + NN; //7XNN Add
                        4'h3: if (V[X] == NN) pc <= pc + 2; //8XY3 - XOR
                        4'h1: pc <= NNN; // NNN - Jumps to address NNN
                        default: ;
                    endcase
                    cpu_state <= FETCH_HIGH;
                end
            endcase
        end
    end   
    
// Timer outputs
    assign delay_timer_out = delay_timer;
    assign sound_timer_out = sound_timer;

endmodule

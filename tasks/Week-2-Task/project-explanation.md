# Designing the CHIP-8 CPU Core in Verilog

This tutorial will help you implement your own CHIP-8 CPU module using FSMs and `case` statements. The goal is to simulate a working CPU that can fetch, decode, and execute real CHIP-8 programs — all in Verilog.

---

## Overview

Your CPU will be a single Verilog module that:

- Fetches 2-byte (16-bit) opcodes from memory
    
- Decodes the opcode using a `case` statement
    
- Executes instructions using internal registers
    
- Interfaces with memory, display, and keypad
    
- Follows a Finite State Machine (FSM) structure
    

---

## What is Fetch-Decode-Execute?

The CPU runs an endless loop broken into three core phases:

1. **Fetch**  
    Read 2 bytes from memory at the current PC (Program Counter).  
    Since CHIP-8 opcodes are 2 bytes and memory is byte-addressed, you need two cycles.
    
2. **Decode**  
    Break down the 16-bit opcode into fields — upper nibble, X, Y, N, NN, NNN — and figure out what instruction it represents.
    
3. **Execute**  
    Perform the action: modify registers, jump, store to memory, etc. Then increment or change the PC based on the instruction.
    

This loop continues for every instruction.

---

## Inputs and Outputs

Here’s a simplified I/O interface for your CPU module:

```verilog
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
```

> This interface will evolve as we implement more instructions and peripherals.

---
## Internal Registers

You’ll need the following inside your `chip8_cpu` module:

```reg [11:0] pc;              // Program counter (starts at 0x200)
reg [11:0] I;               // Address register
reg [7:0] V[0:15];          // General-purpose registers V0–VF
reg [15:0] opcode;          // Current instruction
reg [3:0] state;            // FSM state
```

---

## FSM Structure (Fetch-Decode-Execute)

Your CPU should follow this loop:

```text
[FETCH1] → [FETCH2] → [EXECUTE] → [FETCH1] ...
```

>We break the fetch phase into two steps, since memory is byte-wide but instructions are 2 bytes.

---

## Skeleton Code

Below is a simple FSM-based CPU skeleton with support for `6XNN`, `7XNN`, and `1NNN`:

```verilog
localparam FETCH1 = 0, FETCH2 = 1, EXECUTE = 2;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    pc <= 12'h200; // Programs start at 0x200
    state <= FETCH1;
    opcode <= 0;
    I <= 0;
    mem_read <= 0;
    mem_write <= 0;
    // Optionally clear V[x] here
  end else begin
    mem_read <= 0;
    mem_write <= 0;

    case (state)
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

        case (opcode[15:12])
          4'h6: begin // 6XNN: Vx = NN
            V[opcode[11:8]] <= opcode[7:0];
            pc <= pc + 2;
            state <= FETCH1;
          end

          4'h7: begin // 7XNN: Vx += NN
            V[opcode[11:8]] <= V[opcode[11:8]] + opcode[7:0];
            pc <= pc + 2;
            state <= FETCH1;
          end

          4'h1: begin // 1NNN: jump to NNN
            pc <= opcode[11:0];
            state <= FETCH1;
          end

          default: begin
            // Unknown instruction — just skip
            pc <= pc + 2;
            state <= FETCH1;
          end
        endcase
      end
    endcase
  end
end
```

---

## Testing & Debugging

- Start with a small testbench that feeds known opcodes into the CPU.
    
- Use `$display()` to trace PC, state, and register values.
    
- Dump waveforms (`.vcd`) and use GTKWave to visually inspect state transitions.
    
- Check the values of `V[x]` registers after each instruction.

---
## Tips

- Always reset internal state properly (`pc`, `I`, `V[x]`, timers).
    
- Add a `default` case to every `case` statement.
    
- Add only a few instructions at first — build confidence.
    
- Delay hard instructions like `DXYN` (draw), `FX33` (BCD), `FX0A` (wait for key).
# Designing the CHIP-8 CPU Core in Verilog

This tutorial will help you implement your own CHIP-8 CPU module using FSMs and `case` statements. The goal is to simulate a working CPU that can fetch, decode, and execute real CHIP-8 programs.

## Overview

Your CPU will be a single Verilog module that:

- Fetches 2-byte opcodes from memory
- Decodes opcodes using a `case` statement
- Executes instructions using internal registers
- Interfaces with memory, display, and keypad
- Follows a Finite State Machine (FSM) structure

---

## Inputs and Outputs

Here’s a simplified I/O spec for your `chip8_cpu`:

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

>[!NOTE]
> This I/O spec will be extended as we implement more instructions :D

---

## Internal Registers

Inside the module, you’ll need:

- `reg [11:0] pc;` — program counter
    
- `reg [11:0] I;` — address register
    
- `reg [7:0] V[0:15];` — general-purpose registers
    
- `reg [15:0] opcode;` — current instruction
    
- `reg [3:0] state;` — current FSM state
    
- Optional: timers, stack, draw logic, keywait flag, etc.

---

## CPU Flow (FSM + Case)

Your CPU should follow this loop:

1. **FETCH1**: request first byte of opcode from memory
    
2. **FETCH2**: request second byte, assemble full opcode
    
3. **EXECUTE**: decode and perform the instruction
    
4. **Go back to FETCH1**

Below is a starter skeleton that you can utilize in your project!

```verilog
always @(posedge clk or posedge reset) begin
  if (reset) begin
    pc <= 12'h200;
    state <= FETCH1;
    // initialize everything
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
        // now decode and run opcode
        case (opcode[15:12])
          4'h6: begin // 6XNN: set Vx = NN (add comments like this for clarity pls)
            V[opcode[11:8]] <= opcode[7:0];
            pc <= pc + 2;
            state <= FETCH1;
          end

          4'h7: begin // 7XNN: Vx += NN (add comments like this for clarity pls)
            V[opcode[11:8]] <= V[opcode[11:8]] + opcode[7:0];
            pc <= pc + 2;
            state <= FETCH1;
          end

          4'h1: begin // 1NNN: jump (add comments like this for clarity pls)
            pc <= opcode[11:0];
            state <= FETCH1;
          end

          // ... more stuff as we expand the ISA!

          default: begin
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

## Testing and Debugging

- Write a small testbench that loads a few known opcodes
    
- Use `$display` to trace PC and state transitions
    
- Dump waveforms using GTKWave if needed
    
- Check `V[x]` registers after each step
    

---

## Tips

- Always reset everything properly
    
- Use a `default` in each `case`
    
- Keep state transitions explicit
    
- Delay complex instructions (e.g., draw, BCD, wait) to later
    
- Tackle one opcode at a time — don’t rush
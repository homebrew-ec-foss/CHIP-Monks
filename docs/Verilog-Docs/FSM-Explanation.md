# FSM Design in Verilog – Quick Tutorial

Finite State Machines (FSMs) are one of the most important design patterns in digital systems. CPUs, controllers, and protocols are all built on FSMs.

> [!NOTE]
> This tutorial is written for **pure Verilog**.


## What is an FSM?

An FSM is a circuit that:

- Has a **current state**
- Changes to a **next state** depending on inputs
- Performs actions depending on the state

Think of it like a traffic light or a game menu: you’re always in one mode, and switch modes based on what’s happening.

## Three Parts of an FSM in Verilog

1. **State encoding** – define constants for each state
2. **State register** – holds the current state
3. **Transition logic** – rules for moving between states


## Step 1: State Definitions

Use parameters to name each state. This improves readability.

```verilog
parameter FETCH  = 3'd0;
parameter DECODE = 3'd1;
parameter EXEC   = 3'd2;
parameter HALT   = 3'd3;
```

## Step 2: State Register

You’ll need a `reg` to hold the current state.

```verilog
reg [2:0] state;
```

## Step 3: State Transition Logic

Write an always block that updates `state` every clock edge.

```verilog
always @(posedge clk or posedge reset) begin
  if (reset)
    state <= FETCH;
  else begin
    case (state)
      FETCH:  state <= DECODE;
      DECODE: state <= EXEC;
      EXEC:   state <= FETCH;
      default: state <= FETCH;
    endcase
  end
end
```

---

## FSM in Your CHIP-8 CPU

In your `chip8_cpu.v`, you’ll use states like:

- `FETCH1` – request first byte of opcode
    
- `FETCH2` – request second byte
    
- `EXECUTE` – decode and run instruction
    
- `WAIT` – wait for memory or key input
    
- `DRAW` – update display statefully
    

Declare these as `parameter`, and use a `reg [4:0] state;` or whatever bitwidth fits.

---

## Best Practices

- Always handle `reset` cleanly
    
- Always cover all states in the `case` statement
    
- Avoid latches by giving a default value when needed
    
- Add comments next to each state to describe its purpose and for your easiness too!
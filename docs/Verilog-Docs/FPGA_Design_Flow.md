# RTL Design & FPGA Flow – Teaching Notes

## 1. RTL Design Flow Overview

**RTL** stands for **Register-Transfer Level**, and it’s one of the most important abstraction levels used in digital hardware design.

RTL describes a digital system in terms of:

1. **Registers** — storage elements that hold values (like `reg [7:0] counter`).
    
2. **Transfers** — how data moves between those registers, often on clock edges.
    
3. **Logic** — combinational operations that transform or route data.

```verilog
always @(posedge clk) begin
  if (reset)
    out <= 0; // <= non-blocking assignment
  else
    out <= in1 + in2;
end

always_comb begin
	sum = a + b; // = blocking assignment
	cout = a ^ b;
end
```
This describes an RTL block that:

- Has a **register** `out`
    
- **Transfers** the sum of `in1 + in2` to `out`
    
- On the **rising edge of the clock**
    
- Under control of a **reset condition**

>it’s describing **how data flows** between registers under clock control, and **what logic** computes the new values

So TLDR;  **RTL is the level at which you write Verilog to describe how your circuit processes data over time.**

The general hardware design flow using Verilog looks like this:

```
         +-----------+     +-------------+     +-------------+
         |           |     |             |     |             |
         |  Verilog  | --> | Simulation  | --> | Synthesis   | --> Bitstream
         |  Design   |     | (Functional)|     | (Netlist)   |     Generation
         +-----------+     +-------------+     +-------------+
                                |
                                v
                        +----------------+
                        | Implementation |
                        |  (Placement &  |
                        |     Routing)   |
                        +----------------+
```

Each block has a specific purpose.

---

## 2. RTL Stages Breakdown

### a. Linting

- Linting catches static errors in code: undeclared wires, missing `endmodule`, unused signals.
    
- Use built-in Vivado syntax checker (`Elaborated Design`) or tools like Verilator/iverilog for simple checks.
    
- Encourages clean, portable code.
    

### b. Simulation

- Test functionality before touching hardware.
    
- Requires a testbench module to provide stimulus and check outputs.
    

---

## 3. Understanding Testbenches

A testbench is a separate Verilog module that exists purely for simulation. It does not get synthesized or mapped to hardware.

### Why use testbenches?

- To verify your design works correctly before synthesis
    
- To stimulate the DUT (Design Under Test) with inputs
    
- To observe outputs using `$display`, waveform viewers, or assertions
    

### Structure of a Basic Testbench:

```verilog
module tb;
  reg clk, rst;
  reg [3:0] a, b;
  wire [3:0] y;

  your_design dut(
    .clk(clk), .rst(rst),
    .a(a), .b(b), .y(y)
  );

  initial begin
    clk = 0; rst = 1;
    #10 rst = 0;
    a = 4'd2; b = 4'd3;
    #20 a = 4'd5;
  end

  always #5 clk = ~clk;
endmodule
```

### Key Points to Emphasize

- A testbench instantiates the DUT (your design module)
    
- It drives all inputs and observes outputs
    
- There is no I/O port in the testbench—it is not a synthesizable module
    

### Best Practices:

- Always initialize all inputs.
    
- Use self-checking assertions if possible:
    
    ```verilog
    if (y !== expected) $display("FAIL: y = %b", y);
    ```
    
- Keep testbenches modular and readable
    
- Add comments for every phase: reset, stimulus, check
    
- Use `timescale` directive at the top to define simulation units:
    
    ```verilog
    `timescale 1ns/1ps
    ```
    

---

## 4. Synthesis

- Translates Verilog RTL into a gate-level netlist using FPGA primitives.
    
- Vivado maps logic to LUTs, FFs, DSPs, BRAMs, etc.
    
- Reports:
    
    - Schematic view of datapath
        
    - Resource utilization
        
    - Timing estimates (pre-place)
        

## 5. Implementation

- Takes the netlist and maps it to actual FPGA fabric.
    
- Two key steps:
    
    - Placement: Assign logic to physical regions
        
    - Routing: Connect wires between logic blocks
        
- Produces:
    
    - Timing summary (slack, delay paths)
        
    - Device utilization
        
    - Floorplanning view
        

## 6. Bitstream Generation

- Generates `.bit` or `.bin` file to configure FPGA fabric.
    
- This file can be loaded via Vivado (JTAG or USB) or exported for use with flash loaders.
    

---

## 7. Vivado Walkthrough Steps

1. Create project (RTL Project, skip constraints if not using I/O)
    
2. Add sources: Add `*.v` files, testbenches, etc.
    
3. Run Simulation (XSIM) and view waveform
    
4. Synthesize Design: Review schematic and timing
    
5. Run Implementation: Place & route fabric
    
6. Generate Bitstream: Prepare `.bit` file
    
7. Program Device: Load onto FPGA via USB/JTAG
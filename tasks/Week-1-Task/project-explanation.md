# Week 01 – Project Explanations

Welcome to the **hands‑on mini‑system sprint**! Below are explanations of each of the four projects you can choose from. Every project is intentionally small—aim to finish all three blocks (Easy 🟢, Medium 🟡, Hard 🔴) in **1½ days**.

---

## 1 Mini Calculator Core 

A bite‑size datapath that performs basic 8‑bit arithmetic & logic operations under the control of a tiny opcode decoder.

### System Overview

```
           +-------------------+
A 8‑bit -->|                   |--> 8‑bit RESULT
           |      ALU          |
B 8‑bit -->|    ADD SUB AND XOR|
           +----^---------^----+
                |         |
          OPCODE[1:0]   SEL_MUX (from decoder)
```

### Block Specs

| Stage     | Block        | Purpose                            | Details                                                                 |
| --------- | ------------ | ---------------------------------- | ----------------------------------------------------------------------- |
| Easy 🟢   | **mux2**     | Select between A and B             | Inputs: `a[7:0]`, `b[7:0]`, `sel`; Output: `y[7:0]`                     |
| Medium 🟡 | **regfile2** | Store intermediate results         | Two 8‑bit registers with synchronous write on `we`; outputs `ra` & `rb` |
| Hard 🔴   | **alu3**     | Perform `ADD`, `SUB`, `AND`, `XOR` | Opcode: `00=ADD`, `01=SUB`, `10=AND`, `11=XOR`                          |

### Integration Hints

* Top module `system.v` wires `regfile2` outputs into `alu3` and loops result back for the next cycle.
* Accept external `opcode[1:0]`, `data_in`, `we` so testbench can drive different instructions.

---

## 2  LED Pattern Blinker 

Create eye‑catching LED sequences by cycling through stored patterns at a human‑visible rate.

### System Overview

```
        +-----------+   tick   +-------------+
clk --->|  counter  |--------->|  pattern    |--> led[7:0]
        +-----------+          |   ROM       |
                               +-------------+
```

### Block Specs

| Stage     | Block             | Purpose                 | Details                                                                                |
| --------- | ----------------- | ----------------------- | -------------------------------------------------------------------------------------- |
| Easy 🟢   | **pattern\_rom**  | Store patterns          | Hard‑code 3–4 8‑bit values in a case/array                                             |
| Medium 🟡 | **tick\_counter** | Timing                  | Divide main `clk` so `tick` pulses every \~0.5 s (adjustable via parameter `BLINK_MS`) |
| Hard 🔴   | **pattern\_fsm**  | Cycle & output patterns | On each `tick`, increment address; wrap around; drive `led[7:0]`                       |

### Integration Hints

* Keep `pattern_rom` address 2‑bits wide if you have four patterns.
* Testbench: apply 10–12 `clk` cycles per `tick` and check LED output sequence.

---

## 3 Binary‑to‑7‑Segment Display 

Show hexadecimal digits (0–F) on a simulated 7‑seg display and optionally multiplex two digits.

### System Overview

```
       +-----------+    +----------------+
clk -->| counter 4 |--->| hex_to_7seg     |--> seg[6:0]
       +-----------+    +----------------+
```

### Block Specs

| Stage     | Block                      | Purpose         | Details                                                                                    |
| --------- | -------------------------- | --------------- | ------------------------------------------------------------------------------------------ |
| Easy 🟢   | **hex\_to\_7seg**          | Decode nibble   | Combinational mapping (case) from 4‑bit `val` to `seg[6:0]`                                |
| Medium 🟡 | **nibble\_counter**        | Iterate 0→F     | Simple up‑counter that rolls over after 15; enable every 1 s via `slow_clk`                |
| Hard 🔴   | **digit\_mux** *(stretch)* | 2‑digit display | Time‑division multiplexer toggling between upper & lower nibble using a fast toggle signal |

### Integration Hints

* For beginners, the stretch goal can be skipped—single‑digit is enough.
* Testbench: simulate 20 seconds of `clk` and verify seg codes sequence 0‑F.

---

## 4 Traffic Light Controller

Model a simple crossroads controller with precise phase durations.

### System Overview

```
        +-------------+   done   +-----------+
clk --->|   timer     |--------->|  FSM      |--> ns_light[2:0]
reset ->|  preset T   |          |           |    ew_light[2:0]
        +-------------+          +-----------+
```

### Block Specs

| Stage     | Block             | Purpose              | Details                                                 |
| --------- | ----------------- | -------------------- | ------------------------------------------------------- |
| Easy 🟢   | **decoder\_1hot** | Encode state to LEDs | Map 2‑bit state to one‑hot 3‑bit (G,Y,R)                |
| Medium 🟡 | **preset\_timer** | Generate `done`      | Countdown from preset value; reload on `start`          |
| Hard 🔴   | **traffic\_fsm**  | Control phases       | States: `NS_G`, `NS_Y`, `EW_G`, `EW_Y`; each uses timer |

### Integration Hints

* Choose phase durations in seconds; convert to cycles via parameter (`CLK_HZ`).
* Testbench: drive `reset` low and let the FSM run for several cycles; assert light patterns match expected timeline.

---

## General Tips for All Projects

* **Parameterize frequencies/constants** so testbenches can run fast.
* Write **small self‑checking tasks** in the testbench; use `$display` to print pass/fail.
* Commit early, commit often—use message pattern `commit-type: commit-message @github-user-name`.

Happy hacking! Reach out on Discord if stuck.
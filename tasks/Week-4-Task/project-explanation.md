# Wrapping up CHIP-Monks

### Memory Module

The memory module implements the 4KB address space of the CHIP-8 architecture. It is a synchronous module responsible for storing both the built-in fontset and external game ROMs. Key responsibilities include:

- Handling instruction fetches from the CPU.
    
- Supporting byte-aligned read and write access.
    
- Loading game data (ROM) into memory starting from address `0x200`.
    

During simulation, the ROM is passed as an argument using a Test Plus Argument (`ROM=...`) and copied to `rom.mem` before simulation begins. This file is read during initialization to preload the memory.

---

### Display Module

The display module is a 64x32 monochrome framebuffer, implemented as a 2D array of single-bit values. It supports:

- Pixel-level updates using XOR logic, as required by CHIP-8’s drawing instructions (`Dxyn`).
    
- Clearing the screen when the `CLS` opcode is executed.
    
- Generating a `.frame` text file dump at the end of each frame, which is parsed and rendered by the GUI for visualization.
    

This module is purely combinational in terms of rendering but is driven by control signals and data from the CPU and memory.

---

### GUI (Shell + Visualizer)

The GUI is a Python-based interface designed for simulation-only workflows. It has two components:

#### 1. Shell Script Interface (`chip8.sh`)

This acts as a user-facing frontend to manage simulation and emulator tasks. Features include:

- `./play` – Launches the game selector and GUI visualizer.
    
- `./exit` – Gracefully shuts down the GUI and any background music.
    
- `./uptime` – Reports how long the emulator has been running.
    
- `./music on/off` – Toggles optional background music.
    

It also displays an ASCII banner and tracks uptime via temporary files.

#### 2. GUI Visualizer (`gui/main.py`)

This Python script:

- Parses the `.frame` dumps generated during simulation.
    
- Renders the CHIP-8 screen in a simple window using Pygame.
    
- Provides a visual view of game graphics, enabling debug and verification of drawing operations.

### 3. Launch Script: `launch_sim.sh`

This Bash script automates simulation setup and ROM loading. Responsibilities:

- Accepts a `.mem` ROM file path as a command-line argument.
    
- Verifies that the file exists.
    
- Invokes `vivado` in batch mode using a companion Tcl script, forwarding the ROM path as an argument.
    
Internally, this script calls `run_sim.tcl` and passes the ROM via `-testplusarg ROM=...`.


### 4. ### Tcl Script: `run_sim.tcl`

This Tcl script is used by Vivado to automate the entire simulation flow. It:

- Opens the Vivado project.
    
- Checks that a ROM argument was provided.
    
- Sets simulation properties like runtime and test arguments.
    
- Copies the `.mem` file into the simulation directory (`xsim/rom.mem`).
    
- Launches and runs simulation using the provided ROM.
    

This lets you simulate with any CHIP-8 ROM without rebuilding the project or manually setting simulation inputs.
# Code in Verilog

*Declare a module :*

*module __name__ (output/input);*

*assign ____;*
  
*endmodule*

**Wire**

- Directional
- Continuous assignment

*Assign values to wires :*

*assign output_wire = input_wire;*

They can also be declared within the body of the module using the keyword *wire*. The only condition that it must be declared before its use.

## Gate symbols

**~**  NOT

**&** AND

**^** XOR

Complex gates are broken down in the form of fundamental gates.


## Rules of Verilog

1. No need to indent. However, it improves code readability.
2. To name identifiers in Verilog :
   - Letters
   - digits
   - '_'
   - '$' is also allowed but try to avoid it as it is used in functions. (Eg: $display, $monitor)



**Note**
- Ports are also directional.
- The order in which the assignment statement occurs does not matter.
- Values are always assigned as bits.
- Input and Output statements are by default considered as wires.
- Operations can be performed only on wires declared as *output*.


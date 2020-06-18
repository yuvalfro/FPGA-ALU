# FPGA-ALU
Assignment in CPU architecture course

In this assigment we synthesize a 8 bit basic registered ALU for the Cyclone II FPGA:
1. Two input bus named A and B, width of 8 bit each
2. One input bus named OPC, width of 5 bit
3. Two ouput bus named RES(HI,LO), width of 8 bit each
4. One output but named STATUS, width of 2 bit

The ALU suppurt 15 different commands (add, sub, xor, different shifts etc).
The output (RES and STATUS) is shown in the leds of the FPGA and RES is also shown in the LCD of the FPGA in HEX representation.

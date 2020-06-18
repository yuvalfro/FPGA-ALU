LIBRARY ieee;
USE ieee.std_logic_1164.all;
--------------------------------------------------------
ENTITY MUX IS
	PORT (a, b, s0: IN std_logic;
		  y: OUT std_logic);
END MUX;
--------------------------------------------------------
ARCHITECTURE dataflow OF MUX IS
BEGIN
	y <= (a AND NOT s0) OR
		 (b AND s0);
END dataflow;


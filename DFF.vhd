LIBRARY ieee;
USE ieee.std_logic_1164.all;
--------------------------------------------------------
ENTITY DFF1 IS
  GENERIC (n : INTEGER);
	PORT ( clk: IN std_logic;
	       D: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
			   Q: OUT STD_LOGIC_VECTOR (n-1 DOWNTO 0));
END DFF1;
--------------------------------------------------------
ARCHITECTURE dataflow OF DFF1 IS
BEGIN
	PROCESS (clk)
	  BEGIN
    if (clk'EVENT and clk = '1') then
	      Q <= D;
	    END if;
	 END PROCESS;
END dataflow;


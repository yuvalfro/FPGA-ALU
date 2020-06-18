LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE work.aux_package.all;
-------------------------------------------------------------
entity top is
	generic (
		n : positive := 8 ; -- A,B length
		m : positive := 5 ; -- OPC length
		k : positive := 2   -- STATUS length
	);
	port(
		Key0,Key1,Key2,Key3 : in std_logic;
		SWITCH : in std_logic_vector(n-1 downto 0);
		----------------------------------------
		RES : buffer std_logic_vector(2*n-1 downto 0); -- RES(HI,LO)
		STATUS : out std_logic_vector(k-1 downto 0);
		hex0,hex1,hex2,hex3 : out std_logic_vector(n-2 downto 0)
	);
end top;
------------- complete the top Architecture code --------------
architecture arc_sys of top is
SIGNAL res_addsub,res_others,res_ArithLog : STD_LOGIC_VECTOR(2*n-1 DOWNTO 0);	
SIGNAL res_shifter : STD_LOGIC_VECTOR(2*n-1 DOWNTO 0);
SIGNAL status_addsub,status_others,status_ArithLog : STD_LOGIC_VECTOR(k-1 downto 0);
SIGNAL status_shifter : STD_LOGIC_VECTOR(k-1 downto 0);
SIGNAL dinA,dinB : STD_LOGIC_VECTOR(n-1 downto 0);
SIGNAL dinOP : STD_LOGIC_VECTOR(m-1 downto 0);
	
BEGIN
 -- If we want to do signal tap - add clk,ena signal as inputs -> add to the process "if (key...and rising edge(clk) and ena ='1')" -> connect clk to PIN_L1 and ena to PIN_L2

 ------------- Reg input process -------------------------------
 PROCESS (SWITCH, Key0, Key1, Key2)
    BEGIN
		-- Key0 for A
      if (Key0 ='0') then
			dinA <= SWITCH;
      end if;
		-- Key1 for OP
      if (Key1 ='0') then
			dinOP <= SWITCH(m-1 downto 0);
      end if;
		-- Key2 for B
      if (Key2 ='0') then
			dinB <= SWITCH;
      end if;
  END PROCESS;
  ---------------------------------------------------------------
  
  ------------- ALU ---------------------------------------------
	r_addsub: ALUaddsub GENERIC MAP(n,m,k) port map (cin=>'0', A=>dinA, B=>dinB, op=>dinOP, status=>status_addsub, result=>res_addsub);
	  
	r_others: ALUothers GENERIC MAP(n,m,k) port map (A=>dinA, B=>dinB, op=>dinOP, clk=>Key3, status=>status_others, result=>res_others);
	  
	r_ArithLog: ArithLogSel GENERIC MAP(n,m,k) port map (addsub_res=>res_addsub, others_res=>res_others, op=>dinOP, 
	                         addsub_status=>status_addsub, others_status=>status_others, status=>status_ArithLog , result=>res_ArithLog);
	                         
	r_shifter: Barrel GENERIC MAP(n,m,k) port map (A=>dinA, B=>dinB, op=>dinOP, cin=>'0', status=>status_shifter, result=>res_shifter);  
	                      
	r_OutSel: OutputSelector GENERIC MAP(n,m,k) port map (ArithLog_res => res_ArithLog, Shifter_res => res_shifter, clk => Key3, opc => dinOP, 
	                         ArithLog_status => status_ArithLog, Shifter_status => status_shifter, status => STATUS , result => RES);   
	----------------------------------------------------------------                 
  
   bits2hex1:  LCD  port map (
					bits => RES (3 downto 0),
					hex=>hex0
	);	
	bits2hex2: LCD  port map (
					bits => RES (7 downto 4),
					hex=>hex1
	);	
	bits2hex3: LCD  port map (
					bits => RES (11 downto 8),
					hex=>hex2
	);	
	bits2hex4: LCD  port map (
					bits => RES (15 downto 12),
					hex=>hex3
	);	
  
			
end arc_sys;








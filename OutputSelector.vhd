LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.aux_package.all;
------------------------------------------------------------
ENTITY OutputSelector IS
  GENERIC (n,m,k : INTEGER);
  PORT (    ArithLog_res,Shifter_res: IN STD_LOGIC_VECTOR (2*n-1 DOWNTO 0);
            ArithLog_status,Shifter_status: IN STD_LOGIC_VECTOR (k-1 DOWNTO 0);
				clk: IN STD_LOGIC;
            opc: IN STD_LOGIC_VECTOR (m-1 DOWNTO 0);
        		status: OUT STD_LOGIC_VECTOR (k-1 DOWNTO 0);
            result: OUT STD_LOGIC_VECTOR(2*n-1 DOWNTO 0));
END OutputSelector;
--------------------------------------------------------------
ARCHITECTURE dfl OF OutputSelector IS
SIGNAL tempresult, lastresult	: std_logic_vector(2*n-1 downto 0); 
SIGNAL tempstatus, laststatus	: std_logic_vector(K-1 downto 0); 

begin
 r_dff1: DFF1 GENERIC MAP(2*n) port map (clk=>clk, D=>tempresult, Q=>lastresult);
 r_dff2: DFF1 GENERIC MAP(k) port map (clk=>clk, D=>tempstatus, Q=>laststatus);
	
  -- Save to DFF
  tempstatus <= Shifter_status when OPC(m-1 downto 2) ="011" else
					 ("10") when OPC = "00110" else
					 ArithLog_status;
  
  -- Save to DFF
  tempresult <= Shifter_res when OPC(m-1 downto 2) ="011" else
					 (others => '0') when OPC = "00110" else
					 ArithLog_res;
		
	
  result <= lastresult when( opc(m-1) = '1' or opc = "00000" or opc = "00110" or opc = "00101" )else
			   tempresult; 

	
  status <= laststatus when( opc(m-1) = '1' or opc = "00000" or opc = "00110" or opc = "00101" )else
			   tempstatus; 		

END dfl;

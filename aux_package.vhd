LIBRARY ieee;
USE ieee.std_logic_1164.all;


package aux_package is
-----------------------------------------------------------------
  component top is
	generic (
		n : positive := 8 ; -- A,B length
		m : positive := 5 ; -- OPC length
		k : positive := 2   -- STATUS length
	);
	port(
		rst,ena,clk,cin : in std_logic;
		A,B : in std_logic_vector(n-1 downto 0);
		OPC : in std_logic_vector(m-1 downto 0);
		----------------------------------------
		RES : out std_logic_vector(2*n-1 downto 0); -- RES(HI,LO)
		STATUS : out std_logic_vector(k-1 downto 0)
	);
  end component;
-----------------------------------------------------------------  
	component FA is
		PORT (xi, yi, cin: IN std_logic;
			      s, cout: OUT std_logic);
	end component;
-----------------------------------------------------------------
	component ALUothers is
  GENERIC (n,m,k : INTEGER);
  PORT (
			 A,B: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
			 op: IN STD_LOGIC_VECTOR (m-1 DOWNTO 0);
			 clk: IN STD_LOGIC;
			 status: OUT STD_LOGIC_VECTOR (k-1 DOWNTO 0); 
          result: BUFFER STD_LOGIC_VECTOR(2*n-1 downto 0));
  end component;
-----------------------------------------------------------------
	component ALUaddsub is
  GENERIC (n,m,k : INTEGER);
  PORT (  cin: IN STD_LOGIC;
			 A,B: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
			 op: IN STD_LOGIC_VECTOR (m-1 DOWNTO 0);
			 status: OUT STD_LOGIC_VECTOR (k-1 DOWNTO 0); 
          result: BUFFER STD_LOGIC_VECTOR(2*n-1 downto 0));
  end component;  
-----------------------------------------------------------------
  component DFF1 is
   GENERIC (n : INTEGER);
  	PORT ( clk: IN std_logic;
	       d: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		    q: OUT STD_LOGIC_VECTOR (n-1 DOWNTO 0));
  end component;
-----------------------------------------------------------------
 component MUX is
		PORT (a, b, s0: IN std_logic;
			   y: OUT std_logic);
	end component;
-----------------------------------------------------------------
	component Shifter is
	 GENERIC (n,redB,m : INTEGER);
	 PORT (   x,y: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
	          bit4: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	          op: IN STD_LOGIC_VECTOR (m-1 DOWNTO 0);
             out_m: OUT STD_LOGIC_VECTOR(n-1 downto 0);
             lastbit: OUT STD_LOGIC);
	end component;
-----------------------------------------------------------------	
	component Barrel is
	 GENERIC (n,m,k : INTEGER);
   PORT (    A,B: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
  			    op: IN STD_LOGIC_VECTOR (m-1 DOWNTO 0);
  			    cin: IN STD_LOGIC;
  			    status: OUT STD_LOGIC_VECTOR (k-1 DOWNTO 0); 
             result: BUFFER STD_LOGIC_VECTOR(2*n-1 downto 0));
	end component;
-----------------------------------------------------------------		
	component ArithLogSel IS
  GENERIC (n,m,k : INTEGER);
  PORT (    addsub_res,others_res: IN STD_LOGIC_VECTOR (2*n-1 DOWNTO 0);
            addsub_status,others_status: IN STD_LOGIC_VECTOR (k-1 DOWNTO 0);
            op: IN STD_LOGIC_VECTOR (m-1 DOWNTO 0);
        		status: OUT STD_LOGIC_VECTOR (k-1 DOWNTO 0);
            result: OUT STD_LOGIC_VECTOR(2*n-1 DOWNTO 0));
  END component;
-----------------------------------------------------------------
  component OutputSelector IS
  GENERIC (n,m,k : INTEGER);
  PORT (    ArithLog_res,Shifter_res: IN STD_LOGIC_VECTOR (2*n-1 DOWNTO 0);
            ArithLog_status,Shifter_status: IN STD_LOGIC_VECTOR (k-1 DOWNTO 0);
				clk: IN STD_LOGIC;
            opc: IN STD_LOGIC_VECTOR (m-1 DOWNTO 0);
        		status: OUT STD_LOGIC_VECTOR (k-1 DOWNTO 0);
            result: OUT STD_LOGIC_VECTOR(2*n-1 DOWNTO 0));
  END component;
-----------------------------------------------------------------
	component LCD IS
	PORT ( bits : in  STD_LOGIC_VECTOR (3 downto 0);
          hex : out  STD_LOGIC_VECTOR (6 downto 0));
	END component;
  
end aux_package;



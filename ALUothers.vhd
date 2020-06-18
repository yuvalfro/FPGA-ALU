LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.all;
USE work.aux_package.all;
--------------------------------------------------------------
ENTITY ALUothers IS
  GENERIC (n,m,k : INTEGER);
  PORT (
			 A,B: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
			 op: IN STD_LOGIC_VECTOR (m-1 DOWNTO 0);
			 clk: IN STD_LOGIC;
			 status: OUT STD_LOGIC_VECTOR (k-1 DOWNTO 0);
       result: BUFFER STD_LOGIC_VECTOR(2*n-1 downto 0));
END ALUothers;
--------------------------------------------------------------
ARCHITECTURE dfl OF ALUothers IS
  SIGNAL max,min : STD_LOGIC_VECTOR (n-1 DOWNTO 0);
  SIGNAL mult : STD_LOGIC_VECTOR(2*n-1 DOWNTO 0);
  SIGNAL acc : STD_LOGIC_VECTOR(2*n-1 DOWNTO 0) := (others => '0');
  SIGNAL d,d1 : STD_LOGIC_VECTOR(4*n-1 DOWNTO 0);
  SIGNAL d2 : STD_LOGIC_VECTOR(2*n-1 DOWNTO 0);
  SIGNAL high,low : STD_LOGIC_VECTOR(n-1 DOWNTO 0) := (others => '0');
  SIGNAL carry : STD_LOGIC;
  SIGNAL zero : STD_LOGIC;
  SIGNAL statusforMAC1,statusforMAC2 : STD_LOGIC_VECTOR (k-1 DOWNTO 0);
  SIGNAL zeros : std_logic_vector (n-1 DOWNTO 0) := (others => '0');
  BEGIN
  -- Mult (op = 4)
  mult <= A * B; 
  -- Max (op = 7)
  max <= A when A > B else B;
  -- Min (op = 8) 
  min <= B when A > B else A;
  
  low <= max when op = "00111" else         -- These operations have a result of n bits
         min when op = "01000" else
         A and B when op = "01001" else
         A or B when op = "01010" else
         A xor B when op = "01011";
  
  -- d = Mult + acc
  r1_add: ALUaddsub GENERIC MAP(2*n,m,k) port map(cin=>'0', A=>mult, B=>acc, op=>"00001", status => statusforMAC1, result=>d);
  r2_add: ALUaddsub GENERIC MAP(2*n,m,k) port map(cin=>'0', A=>(others=>'0'), B=>acc, op=>"00001", status => statusforMAC2, result=>d1);
  -- The module addsub receive 2 vectors with size 2*n,and return vector with size 2n+1, so we ignore the last bit
  -- Or MAC_RST (op = 6) Or acc + 0 
  d2 <= (others => '0') when op = "00110" else
        d(2*n-1 downto 0) when op = "00101" else 
        d1(2*n-1 downto 0);       
  -- Insert d1 into DFF and receive q = acc
  r_dff: DFF1 GENERIC MAP(2*n) port map (clk=>clk, D=>d2, Q=>acc);
  
	result <= mult when op = "00100" else
	          acc when op = "00101" or op = "00110" else 
	          high & low; 

  carry <= '0' when result(2*n-1 downto n) = zeros else
           '1';
  
  zero <= '1' when result(n-1 downto 0) = zeros else
          '0';
          
  status <= zero & carry;
  
END dfl;  
  
    
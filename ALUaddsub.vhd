LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.aux_package.all;
-------------------------------------
ENTITY ALUaddsub IS
  GENERIC (n,m,k : INTEGER);
  PORT (     cin: IN STD_LOGIC;
			 A,B: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
			 op: IN STD_LOGIC_VECTOR (m-1 DOWNTO 0);
			 status: OUT STD_LOGIC_VECTOR (k-1 DOWNTO 0); 
       result: BUFFER STD_LOGIC_VECTOR(2*n-1 downto 0));
END ALUaddsub;
--------------------------------------------------------------
ARCHITECTURE dfl OF ALUaddsub IS
	SIGNAL reg : std_logic_vector(n-1 DOWNTO 0);
	SIGNAL new_b : std_logic_vector (n-1 DOWNTO 0);
	SIGNAL c0 : std_logic;
	SIGNAL cout : std_logic;
	SIGNAL s : std_logic_vector (n-1 DOWNTO 0);
	SIGNAL carry : STD_LOGIC;
  SIGNAL zero : STD_LOGIC;
  SIGNAL zeros : std_logic_vector (n-1 DOWNTO 0) := (others => '0');
	BEGIN
	

	new_b(0) <= B(0) xor '1' when op = "00010" else   --op = 2 -> Res = A-B
	            B(0) xor '0';                         --op = 1/3 -> Res = A+B/A+B+Cin
	            
	-- C0 suppouesed to be Cin, but if it don't match to the operation we want to do (and we know it from
	-- the value of sel), so we will change it.           
	c0 <= '0' when op= "00001" and cin= '1' else      --op = 1 -> Res = A+B so if cin = 1 change him
	      '1' when op= "00010" and cin= '0' else      --op = 2 -> Res = A-B so if cin = 0 change him
	      cin;
	first : FA port map(
			xi => A(0),
			yi => new_b(0),
			cin => c0,
			s => s(0),
			cout => reg(0)
	);
	
	rest : for i in 1 to n-1 generate
	 new_b(i) <= B(i) xor '1' when op = "00010" else
	            B(i) xor '0';
		chain : FA port map(
			xi => A(i),
			yi => new_b(i),
			cin => reg(i-1),
			s => s(i),
			cout => reg(i)
		);
	end generate;
	
	cout <= reg(n-1);
	
	result(2*n-1 downto n+1) <= (others => s(n-1)) when op = "00010" else
	                            (others => '0');
	result(n downto 0) <= cout & s when op = "00001" or op = "00011" else
                       	s(n-1) & s;
	
  
  carry <= s(n-1) when op = "00010" else
           cout;
  
  zero <= '1' when result(n-1 downto 0) = zeros else
          '0';
          
  status <= zero & carry;
  
  
END dfl;

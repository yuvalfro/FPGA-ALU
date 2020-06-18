LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
USE work.aux_package.all;
-------------------------------------------------------------
ENTITY Barrel IS
  GENERIC (n,m,k : INTEGER);
  PORT (    A,B: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
            op: IN STD_LOGIC_VECTOR (m-1 DOWNTO 0);
            cin: IN STD_LOGIC;
            status: OUT STD_LOGIC_VECTOR (k-1 DOWNTO 0);
            result: BUFFER STD_LOGIC_VECTOR(2*n-1 DOWNTO 0)); 
END Barrel;
--------------------------------------------------------------
ARCHITECTURE dfl OF Barrel IS
SIGNAL out_shifter,reverse_out_shifter : STD_LOGIC_VECTOR(n-1 DOWNTO 0); 
SIGNAL out_shifter9,reverse_out_shifter9 : STD_LOGIC_VECTOR(n DOWNTO 0);  
SIGNAL temp_out0,temp_out1,temp_out2 : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
SIGNAL temp_out09,temp_out19,temp_out29 : STD_LOGIC_VECTOR(n DOWNTO 0);
SIGNAL bit41,bit42,bit43 : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL newA,reverseA : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
SIGNAL A9,newA9,reverseA9,newB9 : STD_LOGIC_VECTOR(n DOWNTO 0);
SIGNAL lastb,lastb0,lastb1,lastb2 : STD_LOGIC;
SIGNAL lastb09,lastb19,lastb29 : STD_LOGIC;
SIGNAL carry : STD_LOGIC;
SIGNAL zero : STD_LOGIC;  
SIGNAL zeros : std_logic_vector (n-1 DOWNTO 0) := (others => '0');
BEGIN

  A9 <= cin & A;
  
  -- Reverse A for RRA
  genA: for i in 0 to n-1 generate
    reverseA(i) <= A(n-1-i);
  end generate;
  
  -- Reverse A for RRC
  genA9: for i in 0 to n generate
    reverseA9(i) <= A9(n-i);
  end generate;
  
  newA9 <= reverseA9 when op = "01111" else  -- Reverse A9 for RRC
          A9;                        	     	 -- A9 for RLC
  newA <= reverseA when op = "01110" else  -- Reverse A for RRA
          A;                        	      -- A for RLA
          
  newB9 <= B(0) & B;
  bit41<= newA9(n downto n-3) when op="01111" or op="01101" else
         newA(n-1 downto n-4);
  
  --A 
  B0:Shifter GENERIC MAP(n,0,m) port map (x=>newA,y=>B,bit4=>bit41,op=>op,out_m=>temp_out0,lastbit=>lastb0);  
  --C
  B01:Shifter GENERIC MAP(n+1,0,m) port map (x=>newA9,y=>newB9,bit4=>bit41,op=>op,out_m=>temp_out09,lastbit=>lastb09);

    
  -- if n<2 can then b signal of the mux can't get x(i-2)  
  checkn2: if n>2 generate
    bit42 <= temp_out09(n downto n-3) when op="01111" or op="01101" else
            temp_out0(n-1 downto n-4);
  -- A
       B1:Shifter GENERIC MAP(n,1,m) port map (x=>temp_out0,y=>B,bit4=>bit42,op=>op,out_m=>temp_out1,lastbit=>lastb1); 
  -- C
       B11:Shifter GENERIC MAP(n+1,1,m) port map (x=>temp_out09,y=>newB9,bit4=>bit42,op=>op,out_m=>temp_out19,lastbit=>lastb19);
  end generate;
  
  -- if n<4 can then b signal of the mux can't get x(i-4)
  checkn4: if n>4 generate 
      bit43 <= temp_out19(n downto n-3) when op="01111" or op="01101" else
               temp_out1(n-1 downto n-4);   
  -- A 
       B2:Shifter GENERIC MAP(n,2,m) port map (x=>temp_out1,y=>B,bit4=>bit43,op=>op,out_m=>temp_out2,lastbit=>lastb2);  
  -- C
       B21:Shifter GENERIC MAP(n+1,2,m) port map (x=>temp_out19,y=>newB9,bit4=>bit43,op=>op,out_m=>temp_out29,lastbit=>lastb29);
  end generate;
  
  --A
  out_shifter <= temp_out2 when n>4 else
                 temp_out1 when n>2 else
                 temp_out0;

  --C
  out_shifter9 <= temp_out29 when n>4 else
                  temp_out19 when n>2 else
                  temp_out09;
                                  
  lastb <= lastb2 when n>4 and B(2)='1' else
           lastb1 when n>4 and B(1)='1' else
           lastb0 when n>4 else
           lastb1 when n>2 and B(1)='1' else
           lastb0;  
  
  -- Rotation result high n bits are always '0'
  result(2*n-1 downto n) <= (others =>'0'); 
  
  -- Copy the last B2to0 (the integer value of B(2 downto 0)) bits of A to the begining of RLCout
  -- Reverse out_shifter for RRA/RRC
  genO: for i in 0 to n-1 generate
    reverse_out_shifter(i) <= out_shifter(n-1-i);
  end generate;
  
  genO9: for i in 0 to n generate
    reverse_out_shifter9(i) <= out_shifter9(n-i);
  end generate;
         
  result(n-1 downto 0) <= out_shifter when op = "01100" else  -- RLA
             out_shifter9(n-1 downto 0) when op="01101" else --RLC
             reverse_out_shifter9(n-1 downto 0) when op="01111" else --RRC
             reverse_out_shifter;    --RRA
  
  
  carry <= out_shifter9(n) when op="01101" else --RLC
           reverse_out_shifter9(n) when op="01111" else --RRC
           lastb; 
           
  zero <= '1' when result(n-1 downto 0) = zeros else
          '0';
          
  status <= zero & carry;
                 	       
END dfl;





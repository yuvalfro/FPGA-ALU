LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.aux_package.all;
-------------------------------------------------------------
ENTITY Shifter IS
  GENERIC (n,redB,m : INTEGER );
  PORT (    x,y: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
            bit4: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
            op: IN STD_LOGIC_VECTOR (m-1 DOWNTO 0);
            out_m: OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0);
            lastbit: OUT STD_LOGIC );
END Shifter;
--------------------------------------------------------------
ARCHITECTURE dfl OF Shifter IS
SIGNAL sm : STD_LOGIC;
SIGNAL temp,temp1,temp2,temp3 : STD_LOGIC;
BEGIN	
       
  --redB in the number of the red block in the diagram

	b0: if redB=0 generate
	temp<= '0' when op="01100" else --RLA
         bit4(3) when op="01101" or op="01111" else   --RLC RRC
         x(0); --RRA 
	sm <= y(redB);      
	first : MUX port map( 
  	a => x(0),	
	 b => temp,	
	 s0 => sm, 
	 y => out_m(0)	
	);
	lastbit<=x(n-1);-- when y(0)='1';                            
  	rest : for i in 1 to n-1 generate
		  chain : MUX port map(
		  	a => x(i),
		  	b => x(i-1),
		  	s0 => sm,
		  	y => out_m(i)
		  );
	 end generate;
	end generate;
	
	b1: if redB=1 generate
		temp<= '0' when op="01100" else --RLA
         bit4(3)when op="01101" or op="01111" else   --RLC RRC
         x(0); --RRA 
		temp1<= '0' when op="01100" else --RLA
         bit4(2) when op="01101" or op="01111" else  --RLC RRC  
         x(0);  --RRA        
	sm <= y(redB);      
	first : MUX port map( 
  	a => x(0),	
	 b => temp1,	
	 s0 => sm, 
	 y => out_m(0)	
	);
	 lastbit<=x(n-2);-- when y(1)='1';
	--Second block - 2 first mux has b=0, insert manually so there be no warning is the for loop  
	 b11 : MUX port map( a => x(1),	b => temp, s0 => sm,	y => out_m(1) ); 
  	rest : for i in 2 to n-1 generate                                
		  chain : MUX port map(
		  	a => x(i),
		  	b => x(i-2),
		  	s0 => sm,
		  	y => out_m(i)
		  );
	 end generate;
	end generate;
	
	b2: if redB=2 generate 
		temp<= '0' when op="01100" else --RLA
         bit4(3)when op="01101" or op="01111" else   --RLC RRC
         x(0); --RRA 
		temp1<= '0' when op="01100" else --RLA
         bit4(2) when op="01101" or op="01111" else   --RLC RRC  
         x(0); --RRA
 	  temp2<= '0' when op="01100" else --RLA
         bit4(1) when op="01101" or op="01111" else   --RLC RRC 
         x(0); --RRA
   	temp3<= '0' when op="01100" else --RLA
         bit4(0) when op="01101" or op="01111" else   --RLC RRC  
         x(0); --RRA
	sm <= y(redB);
	 lastbit<=x(n-4);-- when y(2)='1'; 
   	first : MUX port map( 
  	a => x(0),	
	 b => temp3,	
	 s0 => sm, 
	 y => out_m(0)	
	);
	--Third block - 4 first mux has b=0, insert manually so there be no warning is the for loop  
	 b21 : MUX port map( a => x(1),	b => temp2, s0 => sm,	y => out_m(1) );
	 b22 : MUX port map( a => x(2),	b => temp1, s0 => sm,	y => out_m(2) );
	 b23 : MUX port map( a => x(3),	b => temp, s0 => sm,	y => out_m(3) );  
  	rest : for i in 4 to n-1 generate
		  chain : MUX port map(
		  	a => x(i),
		  	b => x(i-4),
		  	s0 => sm,
		  	y => out_m(i)
		  );
	 end generate;
	end generate;

END dfl;




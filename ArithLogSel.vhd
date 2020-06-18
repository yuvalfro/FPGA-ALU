LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.aux_package.all;
------------------------------------------------------------
ENTITY ArithLogSel IS
  GENERIC (n,m,k : INTEGER);
  PORT (    addsub_res,others_res: IN STD_LOGIC_VECTOR (2*n-1 DOWNTO 0);
            addsub_status,others_status: IN STD_LOGIC_VECTOR (k-1 DOWNTO 0);
            op: IN STD_LOGIC_VECTOR (m-1 DOWNTO 0);
        			 status: OUT STD_LOGIC_VECTOR (k-1 DOWNTO 0);
            result: OUT STD_LOGIC_VECTOR(2*n-1 DOWNTO 0));
END ArithLogSel;
--------------------------------------------------------------
ARCHITECTURE dfl OF ArithLogSel IS
begin
  result <= addsub_res when op(m-1 downto 2) ="000" else
            others_res;
  
  status <= addsub_status when op(m-1 downto 2) ="000" else
            others_status;

END dfl;

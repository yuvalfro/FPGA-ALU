LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.aux_package.all;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.all;

entity LCD is
    Port ( bits : in  STD_LOGIC_VECTOR (3 downto 0);
          hex : out  STD_LOGIC_VECTOR (6 downto 0)
             );
end LCD;

architecture LCD_arch of LCD is

begin


process (bits)
BEGIN
    case bits is
        when "0000"=> hex <="0000001";  -- '0'
        when "0001"=> hex <="1001111";  -- '1'
        when "0010"=> hex <="0010010";  -- '2'
        when "0011"=> hex <="0000110";  -- '3'
        when "0100"=> hex <="1001100";  -- '4' 
        when "0101"=> hex <="0100100";  -- '5'
        when "0110"=> hex <="0100000";  -- '6'
        when "0111"=> hex <="0001111";  -- '7'
        when "1000"=> hex <="0000000";  -- '8'
        when "1001"=> hex <="0000100";  -- '9'
        when "1010"=> hex <="0001000";  -- 'A'
        when "1011"=> hex <="1100000";  -- 'b'
        when "1100"=> hex <="0110001";  -- 'C'
        when "1101"=> hex <="1000010";  -- 'd'
        when "1110"=> hex <="0110000";  -- 'E'
        when "1111"=> hex <="0111000";  -- 'F'
        when others =>  NULL;
    end case;
end process;

end LCD_arch;
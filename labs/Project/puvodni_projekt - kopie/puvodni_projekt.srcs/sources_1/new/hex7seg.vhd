LIBRARY ieee;
use ieee.std_logic_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity seven_segment is
    Port ( 
       num		    : IN std_logic_vector(3 downto 0);
	   segment_A	: OUT std_logic;
	   segment_B	: OUT std_logic;
	   segment_C	: OUT std_logic;
	   segment_D	: OUT std_logic;
	   segment_E	: OUT std_logic;
	   segment_F	: OUT std_logic;
	   segment_G	: OUT std_logic
    );
end seven_segment;

architecture Behavioral of seven_segment is
begin
process(num)
    
    variable Decode_Data : std_logic_vector(6 downto 0);
    
    begin
        case num is
            when "0000" => Decode_Data := "0000001"; -- 0
            when "0001" => Decode_Data := "1001111"; -- 1
            when "0010" => Decode_Data := "0010010"; -- 2
            when "0011" => Decode_Data := "0000110"; -- 3
            when "0100" => Decode_Data := "1001100"; -- 4
            when "0101" => Decode_Data := "0100100"; -- 5
            when "0110" => Decode_Data := "1100000"; -- 6
            when "0111" => Decode_Data := "0001111"; -- 7
            when "1000" => Decode_Data := "0000000"; -- 8
            when "1001" => Decode_Data := "0001100"; -- 9
            when others => Decode_Data := "1111111";
        end case;
            
            segment_A <= Decode_Data(6);
            segment_B <= Decode_Data(5);
            segment_C <= Decode_Data(4);
            segment_D <= Decode_Data(3);
            segment_E <= Decode_Data(2);
            segment_F <= Decode_Data(1);
            segment_G <= Decode_Data(0);
            
end process;
end Behavioral;
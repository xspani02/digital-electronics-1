library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity btn_debouncer is
    Port (
        clk : in std_logic; 
        btn_in : in std_logic;
        btn_out : out std_logic
    );
end btn_debouncer;

architecture Behavioral of btn_debouncer is

signal FF1, FF2 : std_logic;
signal reset : std_logic;
signal count : integer := 0;

begin

   reset <= FF1 xor FF2;
    
    process(clk)
    begin
        if(rising_edge(clk)) then
        
            FF1 <= btn_in;
            FF2 <= FF1;
            
            if(reset = '1') then
                count <= 0;
            elsif(count < 1000000) then -- 100 MHz * .01 (Takes ~ 10 ms for signal to debounce)
                count <= count + 1;
            else
                btn_out <= FF2;
            end if;
            
        end if;
    end process;

end Behavioral;
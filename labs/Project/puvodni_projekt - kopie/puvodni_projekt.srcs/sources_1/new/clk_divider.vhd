library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity clock_divider is
    Port ( 
        clk, reset	: IN std_logic;
        CLKout		: OUT std_logic
    );
end clock_divider;

architecture Behavioral of clock_divider is

signal count: integer := 0;          -- initialize count to 0
signal temp : std_logic := '1';   -- initialize clock out to 1 for toggle

begin
    process(clk, reset)
        begin
            if(reset = '0') then    -- check for (active low) reset

                  count <= 0;     -- clear count         
                  temp <= '1';      -- set temp to high

             elsif (clk'EVENT and clk = '1') then    -- check for rising edge of CLKin
                      count <= count + 1;   -- update count

                  if (count= 50000000) then  -- check for halfway to 100 MHz
                  --if (count= 10000000) then -- Faster clock for testing
                          temp <= NOT TEMP;    -- toggle temp
                          count <= 0;    -- clear count
    
                  end if;
             end if;
            
            CLKout <= temp;  -- connect temp to CLKout

    end process;

end Behavioral;
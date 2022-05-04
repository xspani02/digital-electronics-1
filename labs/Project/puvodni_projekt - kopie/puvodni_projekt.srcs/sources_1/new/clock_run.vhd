LIBRARY ieee;
use ieee.std_logic_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity run_clock is
    Port ( 
        clk         : in std_logic;
        clk_divided : in std_logic;
        
        enable      : in std_logic;
         
        in_clock_hours_msb  : in std_logic_vector(3 downto 0);
        in_clock_hours_lsb  : in std_logic_vector(3 downto 0);
        in_clock_mins_msb   : in std_logic_vector(3 downto 0);
        in_clock_mins_lsb   : in std_logic_vector(3 downto 0);
        in_clock_sec_msb    : in std_logic_vector(3 downto 0);
        in_clock_sec_lsb    : in std_logic_vector(3 downto 0);
        
        out_clock_hours_msb : out std_logic_vector(3 downto 0);
        out_clock_hours_lsb : out std_logic_vector(3 downto 0); 
        out_clock_mins_msb  : out std_logic_vector(3 downto 0); 
        out_clock_mins_lsb  : out std_logic_vector(3 downto 0); 
        out_clock_sec_msb   : out std_logic_vector(3 downto 0);
        out_clock_sec_lsb   : out std_logic_vector(3 downto 0);

        clock_time : out std_logic_vector(23 downto 0)   
    );
end run_clock;

architecture Behavioral of run_clock is

signal clock_hours_msb  : std_logic_vector(3 downto 0);
signal clock_hours_lsb  : std_logic_vector(3 downto 0);
signal clock_mins_msb   : std_logic_vector(3 downto 0);
signal clock_mins_lsb   : std_logic_vector(3 downto 0);
signal clock_sec_msb    : std_logic_vector(3 downto 0);
signal clock_sec_lsb    : std_logic_vector(3 downto 0);

begin
    process(clk, clk_divided, enable)
    begin
            
            if(enable = '1') then
                clock_hours_msb <= in_clock_hours_msb;
                clock_hours_lsb <= in_clock_hours_lsb;
                clock_mins_msb  <= in_clock_mins_msb;
                clock_mins_lsb  <= in_clock_mins_lsb;
                clock_sec_msb   <= in_clock_sec_msb;
                clock_sec_lsb   <= in_clock_sec_lsb;
           
            -- Update Time
            elsif(rising_edge(clk_divided)) then
                clock_sec_lsb <= clock_sec_lsb + "0001";
                if(clock_sec_lsb = "1001") then -- at 9, set to zero and increment msb
                    clock_sec_lsb <= "0000";
                    clock_sec_msb <= clock_sec_msb + "0001";
                    if(clock_sec_msb = "0101") then -- if = 5
                        clock_sec_msb <= "0000";
                        clock_mins_lsb <= clock_mins_lsb + "0001";
                        if(clock_mins_lsb = "1001") then -- if = 9
                            clock_mins_lsb <= "0000";
                            clock_mins_msb <= clock_mins_msb + "0001";
                            if(clock_mins_msb = "0101") then -- if = 5
                                clock_mins_msb <= "0000";
                                clock_hours_lsb <= clock_hours_lsb + "0001";
                                if(not (clock_hours_msb = "0010")) then --  MSB != 2
                                    if(clock_hours_lsb = "1001") then -- lsb = 9
                                        clock_hours_lsb <= "0000";
                                        clock_hours_msb <= clock_hours_msb + "0001";
                                    end if;
                                elsif(clock_hours_msb = "0010") then
                                    if(clock_hours_lsb = "0011") then -- lsb = 3
                                        clock_hours_lsb <= "0000";
                                        clock_hours_msb <= "0000";
                                    end if;
                                end if;
                            end if;
                        end if;
                    end if;
                end if;
            end if;
              
    end process;
    
    clock_time(23 downto 20) <= clock_hours_msb;
    clock_time(19 downto 16) <= clock_hours_lsb;
    clock_time(15 downto 12) <= clock_mins_msb;
    clock_time(11 downto 8) <= clock_mins_lsb;
    clock_time(7 downto 4) <= clock_sec_msb;
    clock_time(3 downto 0) <= clock_sec_lsb;
    
    -- Output updated time
    out_clock_hours_msb <= clock_hours_msb;
    out_clock_hours_lsb <= clock_hours_lsb;
    out_clock_mins_msb  <= clock_mins_msb;
    out_clock_mins_lsb  <= clock_mins_lsb;
    out_clock_sec_msb   <= clock_sec_msb;
    out_clock_sec_lsb   <= clock_sec_lsb;

end Behavioral;
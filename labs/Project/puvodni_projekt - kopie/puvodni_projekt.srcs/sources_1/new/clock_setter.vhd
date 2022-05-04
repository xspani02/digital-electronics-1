LIBRARY ieee;
use ieee.std_logic_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity set_clock is
    Port (
        clk         : in std_logic;
        clk_divided : in std_logic;
        
        enable      : in std_logic;
        hrs_up      : in std_logic;
        hrs_dwn     : in std_logic;
        mins_up     : in std_logic;
        mins_dwn    : in std_logic;
        sec_reset   : in std_logic;
         
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
        out_clock_sec_lsb   : out std_logic_vector(3 downto 0)
    );
end set_clock;

architecture Behavioral of set_clock is

signal clock_hours_msb  : std_logic_vector(3 downto 0);
signal clock_hours_lsb  : std_logic_vector(3 downto 0);
signal clock_mins_msb   : std_logic_vector(3 downto 0);
signal clock_mins_lsb   : std_logic_vector(3 downto 0);
signal clock_sec_msb    : std_logic_vector(3 downto 0);
signal clock_sec_lsb    : std_logic_vector(3 downto 0);

signal h_up     : std_logic;
signal h_dwn    : std_logic;
signal m_up     : std_logic;
signal m_dwn    : std_logic;
signal s_reset  : std_logic;


signal h_up_mem : std_logic;
signal h_dwn_mem: std_logic;
signal m_up_mem : std_logic;
signal m_dwn_mem: std_logic;
signal s_reset_mem: std_logic;

begin
    process(clk, clk_divided, enable)
    begin
        ------------------------------------------------
        --                 SET CLOCK                  --
        ------------------------------------------------
        if(enable = '0') then
            clock_hours_msb <= in_clock_hours_msb;
            clock_hours_lsb <= in_clock_hours_lsb;
            clock_mins_msb  <= in_clock_mins_msb;
            clock_mins_lsb  <= in_clock_mins_lsb;
            clock_sec_msb   <= in_clock_sec_msb;
            clock_sec_lsb   <= in_clock_sec_lsb;
                
                
        --Change current time
        elsif(rising_edge(clk)) then
        
            if(enable = '1') then

                -- Hours toggle
                if(h_up = '1') then
                    if(clock_hours_msb = "0010" and clock_hours_lsb = "0011") then --  MSB = 2 and lsb = 3
                        clock_hours_lsb <= "0000";
                        clock_hours_msb <= "0000";
                    elsif((clock_hours_msb = "0000" or clock_hours_msb = "0001") and clock_hours_lsb = "1001") then -- MSB = 0 or 1 and lsb = 9
                            clock_hours_lsb <= "0000";
                            clock_hours_msb <= clock_hours_msb + "0001";
                    else
                        clock_hours_lsb <= clock_hours_lsb + "0001";
                    end if;
                elsif(h_dwn = '1') then
                    if(clock_hours_msb = "0000" and clock_hours_lsb = "0000") then
                        clock_hours_msb <= "0010";
                        clock_hours_lsb <= "0011";  
                    elsif((clock_hours_msb = "0010" or clock_hours_msb = "0001") and clock_hours_lsb = "0000") then -- if msb = 2 or 1 and lsb = 0
                        clock_hours_msb <= clock_hours_msb - "0001";
                        clock_hours_lsb <= "1001";
                    else
                        clock_hours_lsb <= clock_hours_lsb - "0001";
                    end if;
                end if;
                    
                -- Minutes toggle
                if(m_up = '1') then
                    if(clock_mins_msb = "0101" and clock_mins_lsb = "1001") then
                        clock_mins_msb <= "0000";
                        clock_mins_lsb <= "0000";  
                    elsif(clock_mins_lsb = "1001") then
                        clock_mins_lsb <= "0000";
                        clock_mins_msb <= clock_mins_msb + "0001";
                    else
                        clock_mins_lsb <= clock_mins_lsb + "0001";
                    end if;
                elsif(m_dwn = '1') then
                    if(clock_mins_msb = "0000" and clock_mins_lsb = "0000") then
                        clock_mins_msb <= "0101";
                        clock_mins_lsb <= "1001";  
                    elsif(clock_mins_lsb = "0000") then
                        clock_mins_lsb <= "1001";
                        clock_mins_msb <= clock_mins_msb - "0001";
                    else
                        clock_mins_lsb <= clock_mins_lsb - "0001";
                    end if;
                end if;
                
                -- Seconds Reset
                if(s_reset = '1') then
                    clock_sec_msb <= "0000";
                    clock_sec_lsb <= "0000";
                end if;
            
            end if;    
        end if;

             
    end process;
    
    out_clock_hours_msb <= clock_hours_msb;
    out_clock_hours_lsb <= clock_hours_lsb;
    out_clock_mins_msb  <= clock_mins_msb;
    out_clock_mins_lsb  <= clock_mins_lsb;
    out_clock_sec_msb   <= clock_sec_msb;
    out_clock_sec_lsb   <= clock_sec_lsb;
    
    btn_press_detect:
    process(clk)
    begin
        
        if(rising_edge(clk)) then
        
            if(hrs_up = '1' and h_up_mem = '0') then
                h_up_mem <= '1';
            elsif(hrs_up = '0' and h_up_mem = '1') then
                h_up_mem <= '0';
            end if;
            -------------------
            if(hrs_dwn = '1' and h_dwn_mem = '0') then
                h_dwn_mem <= '1';
            elsif(hrs_dwn = '0' and h_dwn_mem = '1') then
                h_dwn_mem <= '0';
            end if;
            -------------------
            -------------------
            if(mins_up = '1' and m_up_mem = '0') then
                m_up_mem <= '1';
            elsif(mins_up = '0' and m_up_mem = '1') then
                m_up_mem <= '0';
            end if;
            -------------------
            if(mins_dwn = '1' and m_dwn_mem = '0') then
                m_dwn_mem <= '1';
            elsif(mins_dwn = '0' and m_dwn_mem = '1') then
                m_dwn_mem <= '0';
            end if;
            
            -------------------
            -------------------
            if(sec_reset = '1' and s_reset_mem = '0') then
                s_reset_mem <= '1';
            elsif(sec_reset = '0' and s_reset_mem = '1') then
                s_reset_mem <= '0';
            end if;
        end if;
    end process;
    
    h_up <= hrs_up and not h_up_mem;
    h_dwn <= hrs_dwn and not h_dwn_mem;
    m_up <= mins_up and not m_up_mem;
    m_dwn <= mins_dwn and not m_dwn_mem;
    s_reset <= sec_reset and not s_reset_mem;

end Behavioral;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity set_alarm is
    Port (
        clk         : in std_logic;
        clk_divided : in std_logic;
        
        enable      : in std_logic;
        hrs_up      : in std_logic;
        hrs_dwn     : in std_logic;
        mins_up     : in std_logic;
        mins_dwn    : in std_logic;
     
        alarm_hours_msb : buffer std_logic_vector(3 downto 0);
        alarm_hours_lsb : buffer std_logic_vector(3 downto 0); 
        alarm_mins_msb  : buffer std_logic_vector(3 downto 0); 
        alarm_mins_lsb  : buffer std_logic_vector(3 downto 0); 
        alarm_sec_msb   : buffer std_logic_vector(3 downto 0);
        alarm_sec_lsb   : buffer std_logic_vector(3 downto 0);
        
        alarm_time  : out std_logic_vector(23 downto 0)  
    );
end set_alarm;

architecture Behavioral of set_alarm is

signal h_up     : std_logic;
signal h_dwn    : std_logic;
signal m_up     : std_logic;
signal m_dwn    : std_logic;
signal slow_clk : std_logic;

signal h_up_mem : std_logic;
signal h_dwn_mem: std_logic;
signal m_up_mem : std_logic;
signal m_dwn_mem: std_logic;

begin
   
    process(clk)
    begin
        
        if(rising_edge(clk)) then

            if(enable = '1') then       
                -- Hours toggle
                if(h_up = '1') then
                    if(alarm_hours_msb = "0010" and alarm_hours_lsb = "0011") then --  MSB = 2 and lsb = 3
                        alarm_hours_lsb <= "0000";
                        alarm_hours_msb <= "0000";
                    elsif((alarm_hours_msb = "0000" or alarm_hours_msb = "0001") and alarm_hours_lsb = "1001") then -- MSB = 0 or 1 and lsb = 9
                            alarm_hours_lsb <= "0000";
                            alarm_hours_msb <= alarm_hours_msb + "0001";
                    else
                        alarm_hours_lsb <= alarm_hours_lsb + "0001";
                    end if;
                elsif(h_dwn = '1') then
                    if(alarm_hours_msb = "0000" and alarm_hours_lsb = "0000") then
                        alarm_hours_msb <= "0010";
                        alarm_hours_lsb <= "0011";  
                    elsif((alarm_hours_msb = "0010" or alarm_hours_msb = "0001") and alarm_hours_lsb = "0000") then -- if msb = 2 or 1 and lsb = 0
                        alarm_hours_msb <= alarm_hours_msb - "0001";
                        alarm_hours_lsb <= "1001";
                    else
                        alarm_hours_lsb <= alarm_hours_lsb - "0001";
                    end if;
                end if;
                    
                -- Minutes toggle
                if(m_up = '1') then
                    if(alarm_mins_msb = "0101" and alarm_mins_lsb = "1001") then
                        alarm_mins_msb <= "0000";
                        alarm_mins_lsb <= "0000";  
                    elsif(alarm_mins_lsb = "1001") then
                        alarm_mins_lsb <= "0000";
                        alarm_mins_msb <= alarm_mins_msb + "0001";
                    else
                        alarm_mins_lsb <= alarm_mins_lsb + "0001";
                    end if;
                elsif(m_dwn = '1') then
                    if(alarm_mins_msb = "0000" and alarm_mins_lsb = "0000") then
                        alarm_mins_msb <= "0101";
                        alarm_mins_lsb <= "1001";  
                    elsif(alarm_mins_lsb = "0000") then
                        alarm_mins_lsb <= "1001";
                        alarm_mins_msb <= alarm_mins_msb - "0001";
                    else
                        alarm_mins_lsb <= alarm_mins_lsb - "0001";
                    end if;
                end if;
                    
            end if;
        end if;
    
    end process;
    
    alarm_time(23 downto 20) <= alarm_hours_msb;
    alarm_time(19 downto 16) <= alarm_hours_lsb;
    alarm_time(15 downto 12) <= alarm_mins_msb;
    alarm_time(11 downto 8) <= alarm_mins_lsb;
    alarm_time(7 downto 4) <= alarm_sec_msb;
    alarm_time(3 downto 0) <= alarm_sec_lsb;
    
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
        end if;
    end process;
    
    h_up <= hrs_up and not h_up_mem;
    h_dwn <= hrs_dwn and not h_dwn_mem;
    m_up <= mins_up and not m_up_mem;
    m_dwn <= mins_dwn and not m_dwn_mem;

end Behavioral;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity segment_driver is
    Port ( hours_msb : in STD_LOGIC_VECTOR (3 downto 0);
           hours_lsb : in STD_LOGIC_VECTOR (3 downto 0);
           mins_msb : in STD_LOGIC_VECTOR (3 downto 0);
           mins_lsb : in STD_LOGIC_VECTOR (3 downto 0);
           sec_msb : in STD_LOGIC_VECTOR (3 downto 0);
           sec_lsb : in STD_LOGIC_VECTOR (3 downto 0);
           segA : out STD_LOGIC;
           segB : out STD_LOGIC;
           segC : out STD_LOGIC;
           segD : out STD_LOGIC;
           segE : out STD_LOGIC;
           segF : out STD_LOGIC;
           segG : out STD_LOGIC;
           sel_hours_msb : out STD_LOGIC;
           sel_hours_lsb : out STD_LOGIC;
           sel_mins_msb : out STD_LOGIC;
           sel_mins_lsb : out STD_LOGIC;
           sel_sec_msb : out STD_LOGIC;
           sel_sec_lsb : out STD_LOGIC;
           clk : in STD_LOGIC
           --temp : buffer std_logic_vector(3 downto 0)
           );
end segment_driver;

architecture Behavioral of segment_driver is
    component seven_segment
    PORT(
       num		    : IN std_logic_vector(3 downto 0);
	   segment_A	: OUT std_logic;
	   segment_B	: OUT std_logic;
	   segment_C	: OUT std_logic;
	   segment_D	: OUT std_logic;
	   segment_E	: OUT std_logic;
	   segment_F	: OUT std_logic;
	   segment_G	: OUT std_logic
    );
    end component;
    
    component segment_clk_divider
    PORT(
        clk : in STD_LOGIC;
        enable : in STD_LOGIC;
        reset : in STD_LOGIC;
        data_clk : out STD_LOGIC_VECTOR (15 downto 0)
    );
    end component;
    
signal temp : std_logic_vector(3 downto 0);
signal clock_word : std_logic_vector(15 downto 0);
signal slow_clock : std_logic;

begin
    uut1: seven_segment PORT MAP(
        num => temp,
        segment_A => segA,
	    segment_B => segB,
	    segment_C => segC,
        segment_D => segD,
	    segment_E => segE,
	    segment_F => segF,
	    segment_G => segG
	    );
	    
	uut2: segment_clk_divider PORT MAP(
	   clk => clk,
       enable => '1',
       reset => '0',
       data_clk => clock_word
	);
	
	slow_clock <= clock_word(15);
	
    process(slow_clock)
    variable display_selection : STD_LOGIC_VECTOR(2 downto 0);
    begin
    
        if(rising_edge(slow_clock)) then
        
            case display_selection is
               
                when "000" => temp <= hours_msb;
                    sel_hours_msb   <= '0';
                    sel_hours_lsb   <= '1';
                    sel_mins_msb    <= '1';
                    sel_mins_lsb    <= '1';
                    sel_sec_msb     <= '1';
                    sel_sec_lsb     <= '1';
                    display_selection := display_selection + '1';
                    
                when "001" => temp <= hours_lsb;
                    sel_hours_msb   <= '1';
                    sel_hours_lsb   <= '0';
                    sel_mins_msb    <= '1';
                    sel_mins_lsb    <= '1';
                    sel_sec_msb     <= '1';
                    sel_sec_lsb     <= '1';
                    display_selection := display_selection + '1';
                    
                    when "010" => temp <= mins_msb;
                    sel_hours_msb   <= '1';
                    sel_hours_lsb   <= '1';
                    sel_mins_msb    <= '0';
                    sel_mins_lsb    <= '1';
                    sel_sec_msb     <= '1';
                    sel_sec_lsb     <= '1';
                    display_selection := display_selection + '1';
                    
                    when "011" => temp <= mins_lsb;
                    sel_hours_msb   <= '1';
                    sel_hours_lsb   <= '1';
                    sel_mins_msb    <= '1';
                    sel_mins_lsb    <= '0';
                    sel_sec_msb     <= '1';
                    sel_sec_lsb     <= '1';
                    display_selection := display_selection + '1';
                    
                    when "100" => temp <= sec_msb;
                    sel_hours_msb   <= '1';
                    sel_hours_lsb   <= '1';
                    sel_mins_msb    <= '1';
                    sel_mins_lsb    <= '1';
                    sel_sec_msb     <= '0';
                    sel_sec_lsb     <= '1';
                    display_selection := display_selection + '1';
                    
                    --when "101" => temp <= sec_lsb;
                    when others => temp <= sec_lsb;
                    sel_hours_msb   <= '1';
                    sel_hours_lsb   <= '1';
                    sel_mins_msb    <= '1';
                    sel_mins_lsb    <= '1';
                    sel_sec_msb     <= '1';
                    sel_sec_lsb     <= '0';
                    display_selection := "000";
                    
--                    when others =>
--                        display_selection := "000";
                    
                end case;
            end if;
        end process;
end Behavioral;
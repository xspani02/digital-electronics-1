LIBRARY ieee;
use ieee.std_logic_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity Alarm is
    Port (
        ledr : out std_logic;
        ledg: out std_logic;
        clk: in STD_LOGIC;
        set_time : in std_logic;
        set_alarm : in std_logic;
        toggle_alarm : in std_logic;

        -- Time setting
        hrs_up_btn      : in std_logic;
        hrs_dwn_btn     : in std_logic;
        mins_up_btn     : in std_logic;
        mins_dwn_btn    : in std_logic;
        sec_reset_btn   : in std_logic;   
        LED : out STD_LOGIC_VECTOR (2 downto 0);
        a : out std_logic_vector(7 downto 0);
        off : out std_logic_vector(1 downto 0);
        -- ports for display output
            -- Which 7 Segment display
        alarm_sel_hours_msb : out STD_LOGIC;
        alarm_sel_hours_lsb : out STD_LOGIC;
        alarm_sel_mins_msb : out STD_LOGIC;
        alarm_sel_mins_lsb : out STD_LOGIC;
        alarm_sel_sec_msb : out STD_LOGIC;
        alarm_sel_sec_lsb : out STD_LOGIC;
            -- Segments
        alarm_segA : out STD_LOGIC;
        alarm_segB : out STD_LOGIC;
        alarm_segC : out STD_LOGIC;
        alarm_segD : out STD_LOGIC;
        alarm_segE : out STD_LOGIC;
        alarm_segF : out STD_LOGIC;
        alarm_segG : out STD_LOGIC
    );
end Alarm;

architecture Behavioral of Alarm is

-- 1s clock
signal clk_divided : std_logic;
-- To hold alarm time
signal alarm_hours_msb : STD_LOGIC_VECTOR(3 downto 0);
signal alarm_hours_lsb : STD_LOGIC_VECTOR(3 downto 0); 
signal alarm_mins_msb : STD_LOGIC_VECTOR(3 downto 0);
signal alarm_mins_lsb : STD_LOGIC_VECTOR(3 downto 0); 
signal alarm_sec_msb : STD_LOGIC_VECTOR(3 downto 0);
signal alarm_sec_lsb : STD_LOGIC_VECTOR(3 downto 0); 
-- To hold clock time
signal clock_hours_msb : STD_LOGIC_VECTOR(3 downto 0);
signal clock_hours_lsb : STD_LOGIC_VECTOR(3 downto 0); 
signal clock_mins_msb : STD_LOGIC_VECTOR(3 downto 0);
signal clock_mins_lsb : STD_LOGIC_VECTOR(3 downto 0); 
signal clock_sec_msb : STD_LOGIC_VECTOR(3 downto 0);
signal clock_sec_lsb : STD_LOGIC_VECTOR(3 downto 0);
-- To hold running clock time
signal run_clock_hours_msb : STD_LOGIC_VECTOR(3 downto 0);
signal run_clock_hours_lsb : STD_LOGIC_VECTOR(3 downto 0); 
signal run_clock_mins_msb : STD_LOGIC_VECTOR(3 downto 0);
signal run_clock_mins_lsb : STD_LOGIC_VECTOR(3 downto 0); 
signal run_clock_sec_msb : STD_LOGIC_VECTOR(3 downto 0);
signal run_clock_sec_lsb : STD_LOGIC_VECTOR(3 downto 0);
-- To hold time change
signal set_clock_hours_msb : STD_LOGIC_VECTOR(3 downto 0);
signal set_clock_hours_lsb : STD_LOGIC_VECTOR(3 downto 0); 
signal set_clock_mins_msb : STD_LOGIC_VECTOR(3 downto 0);
signal set_clock_mins_lsb : STD_LOGIC_VECTOR(3 downto 0); 
signal set_clock_sec_msb : STD_LOGIC_VECTOR(3 downto 0);
signal set_clock_sec_lsb : STD_LOGIC_VECTOR(3 downto 0);
-- Numbers to be displayed
signal disp_hours_msb : STD_LOGIC_VECTOR(3 downto 0);
signal disp_hours_lsb : STD_LOGIC_VECTOR(3 downto 0);
signal disp_mins_msb : STD_LOGIC_VECTOR(3 downto 0);
signal disp_mins_lsb : STD_LOGIC_VECTOR(3 downto 0);
signal disp_sec_msb : STD_LOGIC_VECTOR(3 downto 0);
signal disp_sec_lsb : STD_LOGIC_VECTOR(3 downto 0);

-- Used in comparison for sounding alarm
signal clock_time : std_logic_vector(23 downto 0);
signal alarm_time : std_logic_vector(23 downto 0);

-- Link button inputs to debounced output
signal hrs_up : STD_LOGIC;
signal hrs_dwn : STD_LOGIC;
signal mins_up : STD_LOGIC;
signal mins_dwn : STD_LOGIC;
signal sec_reset : STD_LOGIC;

begin

    off <= "11"; -- Turn off the 2 right-most 7-segment displays
    
    -- 1 second clock divider
    divider: entity work.clock_divider(Behavioral)
		port map(clk => clk, reset => '1', CLKout => clk_divided);
	
	-- Running clock component	
	clock: entity work.run_clock(Behavioral)
	   port map(clk => clk, clk_divided => clk_divided, enable => set_time,
	       in_clock_hours_msb => clock_hours_msb, in_clock_hours_lsb => clock_hours_lsb,
	       in_clock_mins_msb => clock_mins_msb, in_clock_mins_lsb => clock_mins_lsb,
	       in_clock_sec_msb => clock_sec_msb, in_clock_sec_lsb => clock_sec_lsb,
	       out_clock_hours_msb => run_clock_hours_msb, out_clock_hours_lsb => run_clock_hours_lsb,
	       out_clock_mins_msb => run_clock_mins_msb, out_clock_mins_lsb => run_clock_mins_lsb,
	       out_clock_sec_msb => run_clock_sec_msb, out_clock_sec_lsb => run_clock_sec_lsb,
	       clock_time => clock_time);
	
	-- Set Clock component	
	clock_setter: entity work.set_clock(Behavioral)
	   port map(clk => clk, clk_divided => clk_divided, enable => set_time,
	       hrs_up => hrs_up, hrs_dwn => hrs_dwn, mins_up => mins_up, mins_dwn => mins_dwn, sec_reset => sec_reset,
	       in_clock_hours_msb => clock_hours_msb, in_clock_hours_lsb => clock_hours_lsb,
	       in_clock_mins_msb => clock_mins_msb, in_clock_mins_lsb => clock_mins_lsb,
	       in_clock_sec_msb => clock_sec_msb, in_clock_sec_lsb => clock_sec_lsb,
	       out_clock_hours_msb => set_clock_hours_msb, out_clock_hours_lsb => set_clock_hours_lsb,
	       out_clock_mins_msb => set_clock_mins_msb, out_clock_mins_lsb => set_clock_mins_lsb,
	       out_clock_sec_msb => set_clock_sec_msb, out_clock_sec_lsb => set_clock_sec_lsb);
	
	-- Set alarm component       
	alarm_setter: entity work.set_alarm(Behavioral)
	   port map(clk => clk, clk_divided => clk_divided, enable => set_alarm,
	       hrs_up => hrs_up, hrs_dwn => hrs_dwn, mins_up => mins_up, mins_dwn => mins_dwn,
	       alarm_hours_msb => alarm_hours_msb, alarm_hours_lsb => alarm_hours_lsb,
	       alarm_mins_msb => alarm_mins_msb, alarm_mins_lsb => alarm_mins_lsb,
	      alarm_sec_msb => alarm_sec_msb, alarm_sec_lsb => alarm_sec_lsb,
	      alarm_time => alarm_time
	   );

    -- Seven Segment Displays        
    segDriver: entity work.segment_driver(Behavioral)
        port map(clk => clk,
            -- Values
            hours_msb => disp_hours_msb, hours_lsb => disp_hours_lsb, 
            mins_msb => disp_mins_msb, mins_lsb => disp_mins_lsb, 
            sec_msb => disp_sec_msb,  sec_lsb => disp_sec_lsb,
            -- Segments
            segA => alarm_segA, segB => alarm_segB, segC => alarm_segC, segD => alarm_segD,
            segE => alarm_segE, segF => alarm_segF, segG => alarm_segG,
            -- Displays
            sel_hours_msb => alarm_sel_hours_msb, sel_hours_lsb => alarm_sel_hours_lsb,
            sel_mins_msb => alarm_sel_mins_msb, sel_mins_lsb => alarm_sel_mins_lsb,
            sel_sec_msb => alarm_sel_sec_msb, sel_sec_lsb => alarm_sel_sec_lsb
            );
         
    BTNU_debouncer: entity work.btn_debouncer(Behavioral)
        port map(clk => clk, btn_in => hrs_up_btn, btn_out => hrs_up);
        
    BTND_debouncer: entity work.btn_debouncer(Behavioral)
        port map(clk => clk, btn_in => hrs_dwn_btn, btn_out => hrs_dwn);
        
    BTNR_debouncer: entity work.btn_debouncer(Behavioral)
        port map(clk => clk, btn_in => mins_up_btn, btn_out => mins_up);
        
    BTNL_debouncer: entity work.btn_debouncer(Behavioral)
        port map(clk => clk, btn_in => mins_dwn_btn, btn_out => mins_dwn);
        
    BTNC_debouncer: entity work.btn_debouncer(Behavioral)
        port map(clk => clk, btn_in => sec_reset_btn, btn_out => sec_reset);
        

    ------------------------------------------------
    ------------------------------------------------
                    CLOCK_PROCESS:
    ------------------------------------------------
    ------------------------------------------------          
    process(clk, set_time)
    begin
        
        --if(rising_edge(clk)) then
        if(set_time = '0') then
            clock_hours_msb <= run_clock_hours_msb;
            clock_hours_lsb <= run_clock_hours_lsb;
            clock_mins_msb  <= run_clock_mins_msb;
            clock_mins_lsb  <= run_clock_mins_lsb;
            clock_sec_msb   <= run_clock_sec_msb;
            clock_sec_lsb   <= run_clock_sec_lsb;
            
        elsif(set_time = '1') then
            clock_hours_msb <= set_clock_hours_msb;
            clock_hours_lsb <= set_clock_hours_lsb;
            clock_mins_msb  <= set_clock_mins_msb;
            clock_mins_lsb  <= set_clock_mins_lsb;
            clock_sec_msb   <= set_clock_sec_msb;
            clock_sec_lsb   <= set_clock_sec_lsb;
        end if;

            

    end process;
    
    ------------------------------------------------
    ------------------------------------------------
                    OUTPUT_PROCESS:               
    ------------------------------------------------
    ------------------------------------------------
    process(clk, set_time, set_alarm)
    begin
        
        -- Link LEDs to switches
        led(2) <= toggle_alarm;
        led(1) <= set_alarm;
        led(0) <= set_time;
        
        if(rising_edge(clk)) then
        -- Display the alarm time if set alarm is toggled
            if(set_alarm = '1' and set_time = '0') then
                disp_hours_msb <= alarm_hours_msb;
                disp_hours_lsb <= alarm_hours_lsb;
                disp_mins_msb <= alarm_mins_msb;
                disp_mins_lsb <= alarm_mins_lsb;
                disp_sec_msb <= alarm_sec_msb;
                disp_sec_lsb <= alarm_sec_lsb;
            
            -- Display clock time otherwise    
            else
                disp_hours_msb <= clock_hours_msb;
                disp_hours_lsb <= clock_hours_lsb;
                disp_mins_msb <= clock_mins_msb;
                disp_mins_lsb <= clock_mins_lsb;
                disp_sec_msb <= clock_sec_msb;
                disp_sec_lsb <= clock_sec_lsb;
            end if;
        end if;
            
            
            
        end process;
        
    
    ------------------------------------------------
    ------------------------------------------------
                ALARM_SOUNDING_PROCESS:               
    ------------------------------------------------
    ------------------------------------------------
 process(clk, clk_divided)
 variable flash: boolean := false;
 variable light: std_logic_vector(7 downto 0) := "11111111";
 variable red: std_logic := '1';
 variable green: std_logic :='1';
 variable temp : std_logic := '0';
 begin          
 if(toggle_alarm = '0') then
            flash := false;
        elsif(toggle_alarm = '1') then
            if(rising_edge(clk)) then
                if(alarm_time = clock_time) then
                    flash := true;
                end if;
            end if;
        end if;
        
        if(flash = true) then
            a <= light;
            ledr <= red;
            ledg <= green;
            if(rising_edge(clk_divided)) then
                red := not red;
                green := not green;
                light := not light;
            end if;
        else
            a <= "00000000";
            ledg <= '0';
            ledr <= '0';
        end if;
        
        
    end process;  

end Behavioral;
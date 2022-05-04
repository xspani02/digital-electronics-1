----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/30/2022 02:01:36 PM
-- Design Name: 
-- Module Name: top - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
    Port ( CLK100MHZ : in STD_LOGIC;
           BTNC : in STD_LOGIC;
           BTNU : in STD_LOGIC;
           BTNL : in STD_LOGIC;
           BTNR : in STD_LOGIC;
           BTND : in STD_LOGIC;
           SW : in STD_LOGIC_VECTOR (2 downto 0);
           CA : out STD_LOGIC;
           CB : out STD_LOGIC;
           CC : out STD_LOGIC;
           CD : out STD_LOGIC;
           CE : out STD_LOGIC;
           CF : out STD_LOGIC;
           CG : out STD_LOGIC;
           LED16_G:out STD_LOGIC ;
           LED17_R:out STD_LOGIC ;
           LED:out STD_LOGIC_VECTOR (2 downto 0);
           LEDs:out STD_LOGIC_VECTOR (13 downto 6);
           AN : out STD_LOGIC_VECTOR (7 downto 2);
           AB : out STD_LOGIC_VECTOR(1 downto 0)
           );
           
end top;

-- Architecture body for top level
------------------------------------------------------------
architecture Behavioral of top is
  -- No internal signals
begin

  --------------------------------------------------------
  -- Instance (copy) of driver_7seg_4digits entity
  driver_seg_4 : entity work.Alarm
      port map(
      clk => CLK100MHZ,
      set_time => SW(0),
      set_alarm => SW(1),
      toggle_alarm => SW(2),
      LED => LED,
      a => LEDs,
      ledr =>LED17_R,
      ledg =>LED16_G,
      alarm_segA => CA,
      alarm_segB => CB,
      alarm_segC => CC,
      alarm_segD => CD,
      alarm_segE => CE,
      alarm_segF => CF,
      alarm_segG => CG,
      off => AB,
      alarm_sel_sec_lsb => AN(2),
      alarm_sel_sec_msb=> AN(3),
      alarm_sel_mins_lsb=> AN(4),
      alarm_sel_mins_msb=> AN(5),
      alarm_sel_hours_lsb=> AN(6),
      alarm_sel_hours_msb=> AN(7),
      sec_reset_btn => BTNC,
      hrs_up_btn => BTNU,
      mins_dwn_btn => BTNL,
      mins_up_btn => BTNR,
      hrs_dwn_btn => BTND
      
      );

  -- Disconnect the top four digits of the 7-segment display

end architecture Behavioral;
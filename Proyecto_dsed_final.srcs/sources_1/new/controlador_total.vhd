----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.12.2019 13:58:18
-- Design Name: 
-- Module Name: controlador_total - Behavioral
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
use work.DSED.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity controlador_total is
    Port ( clk100Mhz : in STD_LOGIC;
       reset : in STD_LOGIC;
       record_enable: in STD_LOGIC;
       pausa: in STD_LOGIC;
       play_enable: in STD_LOGIC;
       micro_clk : out STD_LOGIC;
       micro_data : in STD_LOGIC;
       micro_LR : out STD_LOGIC;
       jack_sd : out STD_LOGIC;
       jack_pwm : out STD_LOGIC;
       filter_select: in STD_LOGIC;
       rebobinar: in STD_LOGIC;
       segmentos:out std_logic_vector(6 downto 0);
       display_7s:out std_logic_vector(7 downto 0)
       );
end controlador_total;

architecture Behavioral of controlador_total is

signal ena,clk_12megas,sample_out_ready,sample_request,sample_out_filtered_ready:std_logic;
signal sample_out,sample_in,sample_out_filtered,sample_out_a2,sample_out_filtered_a2:std_logic_vector(sample_size-1 downto 0);

signal local_rst,rebobinar_larger,record_enable_larger,play_enable_larger,pause_larger:std_logic;

signal addr_write,addr_read,addr : std_logic_vector(18 downto 0);
signal wea : std_logic_vector(0 downto 0);
component enlarger_pulse 
    Port ( input : in STD_LOGIC;
           clk : in STD_LOGIC;
           reset: in std_logic;
           output : out STD_LOGIC);
end component;
component clk_wiz_0
port
 (-- Clock in ports
  -- Clock out ports
  clk_out1          : out    std_logic;
  clk_in1           : in     std_logic
 );
end component;
component fir_filter is
    Port(
       clk : in STD_LOGIC;
       reset : in STD_LOGIC;
       sample_in : in STD_LOGIC_VECTOR (7 downto 0);
       sample_in_enable : in STD_LOGIC;
       filter_select : in STD_LOGIC;
       sample_out : out STD_LOGIC_VECTOR (7 downto 0);
       sample_out_ready : out STD_LOGIC
    );
end component;
component audio_interface is
    Port ( clk_12megas : in STD_LOGIC;
           reset : in STD_LOGIC;
           record_enable : in STD_LOGIC;
           sample_out : out STD_LOGIC_VECTOR (sample_size-1 downto 0);
           sample_out_ready : out STD_LOGIC;
           micro_clk : out STD_LOGIC;
           micro_data : in STD_LOGIC;
           micro_LR : out STD_LOGIC;
           play_enable : in STD_LOGIC;
           sample_in : in STD_LOGIC_VECTOR (sample_size-1 downto 0);
           sample_request : out STD_LOGIC;
           jack_sd : out STD_LOGIC;
           jack_pwm : out STD_LOGIC);
end component;

COMPONENT blk_mem_gen_0
  PORT (
    clka : IN STD_LOGIC;
    rsta : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(18 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END COMPONENT;
component display is
    Port ( clk: in std_logic;
           rec : in STD_LOGIC;
           play : in STD_LOGIC;
           pause : in STD_logic;
           segmentos : out STD_LOGIC_VECTOR (6 downto 0);
           display : out STD_LOGIC_VECTOR (7 downto 0));

end component;
component control_escritura is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           signal_ready : in STD_LOGIC;
           enable : in STD_LOGIC;
           addr : out STD_LOGIC_vector(18 downto 0);
           rebobinar:in STD_LOGIC;
           pause:in STD_LOGIC;
           local_rst:in STD_LOGIC
           );
end component;


begin
memory : blk_mem_gen_0
  PORT MAP (
    clka => clk_12megas,
    rsta=>reset,
    ena => ena,
    wea => wea,
    addra => addr,
    dina => sample_out_filtered,
    douta => sample_in
  );
reloj : clk_wiz_0
   port map ( 
  -- Clock out ports  
   clk_out1 => clk_12megas,
   -- Clock in ports
   clk_in1 => clk100Mhz
 );
 
audio: audio_interface Port map(
    clk_12megas=>clk_12megas,
    reset=> reset,
    record_enable=>record_enable_larger,
    sample_out=> sample_out,
    sample_out_ready => sample_out_ready,
    micro_clk => micro_clk,
    micro_data=> micro_data,
    micro_LR =>micro_LR,
    play_enable=>play_enable_larger,
    sample_in =>sample_in,
    sample_request=>sample_request,
    jack_sd =>jack_sd,
    jack_pwm =>jack_pwm
);
fir:fir_filter Port map(
       clk =>clk_12megas,
       reset =>reset,
       sample_in =>sample_out_a2,
       sample_in_enable =>sample_out_ready,
       filter_select =>filter_select,
       sample_out =>sample_out_filtered_a2,
       sample_out_ready =>sample_out_filtered_ready
);
control1_escritura:control_escritura Port map(
     clk =>clk_12megas,
          rst =>reset,
          signal_ready => sample_out_filtered_ready,
          enable => record_enable_larger,
          addr =>addr_write,
          pause=>pause_larger,
           rebobinar=>rebobinar_larger,
           local_rst=>local_rst
          );

control2_lectura:control_escritura Port map(
     clk =>clk_12megas,
          rst =>reset,
          signal_ready => sample_request,
          enable => play_enable_larger,
          addr =>addr_read,
          pause=>pause_larger,
          rebobinar=>rebobinar_larger,
          local_rst=>local_rst
          );
record_enalarger:enlarger_pulse Port Map(
    input=>record_enable,
    clk=>clk_12megas,
    reset=>reset,
    output=>record_enable_larger
);
play_enalarger:enlarger_pulse Port Map(
    input=>play_enable,
    clk=>clk_12megas,
    reset=>reset,
    output=>play_enable_larger
);
pausa_enalrger:enlarger_pulse Port Map(
    input=>pausa,
    clk=>clk_12megas,
    reset=>reset,
    output=>pause_larger
);
rebob:enlarger_pulse Port Map(
    input=>rebobinar,
    clk=>clk_12megas,
    reset=>reset,
    output=>rebobinar_larger
);
dis_7s:display Port Map(
    clk=>clk_12megas,
    rec=>record_enable_larger,
    play=>play_enable_larger,
    pause=>pause_larger,
    display=>display_7s,
    segmentos=>segmentos
);
sample_out_a2<=(not(sample_out(sample_size-1)) & sample_out((sample_size-2)downto 0));
sample_out_filtered<=(not(sample_out_filtered_a2(sample_size-1)) & sample_out_filtered_a2((sample_size-2)downto 0));

wea(0)<=record_enable_larger;
ena <= play_enable_larger or record_enable_larger;
local_rst<=play_enable_larger and record_enable_larger;

with record_enable_larger select addr<=
    addr_write when '1',
    addr_read when others;
    

end Behavioral;

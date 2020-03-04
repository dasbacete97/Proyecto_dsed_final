----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.01.2020 19:31:34
-- Design Name: 
-- Module Name: general_tb2 - Behavioral
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

entity general_tb2 is
--  Port ( );
end general_tb2;

architecture Behavioral of general_tb2 is
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
    ena : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(18 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END COMPONENT;

component control_escritura is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           signal_ready : in STD_LOGIC;
           enable : in STD_LOGIC;
           addr : out STD_LOGIC_vector(18 downto 0)
           );
end component;
signal a,b,c,nor_aux:std_logic:='0';
signal filter_select,sample_out_ready,sample_out_filtered_ready,sample_request,clk_12megas,record_enable,play_enable,pausa,ena,reset,jack_pwm,jack_sd,micro_clk,micro_data,micro_LR:std_logic;
constant clk_period:time:=10 ns;
signal addr,addr_read,addr_write:std_logic_vector(18 downto 0);
signal wea:std_logic_vector(0 downto 0);
signal sample_out_a2,sample_out_filtered,sample_out_filtered_a2,sample_in,sample_out:std_logic_vector(7 downto 0);

begin
memory : blk_mem_gen_0
  PORT MAP (
    clka => clk_12megas,
    ena => ena,
    wea => wea,
    addra => addr,
    dina => sample_out_filtered,
    douta => sample_in
  );
 
UUT: audio_interface Port map(
    clk_12megas=>clk_12megas,
    reset=> reset,
    record_enable=>record_enable,
    sample_out=> sample_out,
    sample_out_ready => sample_out_ready,
    micro_clk => micro_clk,
    micro_data=> micro_data,
    micro_LR =>micro_LR,
    play_enable=>play_enable,
    sample_in =>sample_in,
    sample_request=>sample_request,
    jack_sd =>jack_sd,
    jack_pwm =>jack_pwm
);
UUT1:fir_filter Port map(
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
          enable => record_enable,
          addr =>addr_write
          );

control2_lectura:control_escritura Port map(
     clk =>clk_12megas,
          rst =>reset,
          signal_ready => sample_request,
          enable => play_enable,
          addr =>addr_read
          );

sample_out_a2<=(not(sample_out(sample_size-1)) & sample_out((sample_size-2)downto 0));
sample_out_filtered<=(not(sample_out_filtered_a2(sample_size-1)) & sample_out_filtered_a2((sample_size-2)downto 0));

wea(0)<=record_enable;
ena <= play_enable or record_enable;

with record_enable select addr<=
    addr_write when '1',
    addr_read when others;
filter_select<='1';
clk:process
    begin
    clk_12megas <= '0';
    wait for clk_period/2;
    clk_12megas<= '1';
    wait for clk_period/2;
end process;
semi_random:process
begin
a <= not a after 2560 ns;
b <= not b after 1710 ns;
c <= not c after 1840 ns;
nor_aux<= a xor b xor c;
micro_data<=nor_aux;
wait for 1 ns;
end process;
logic:process
    begin
    reset<='1';
    wait for 25 ns;
    reset<='0';
    wait for 200 ns;
    play_enable<='1';
    record_enable<='1';
    wait for 500 us;
    play_enable<='0';
    wait for 500 us;
    record_enable<='0';
    play_enable<='1';
    wait;
end process;
end Behavioral;

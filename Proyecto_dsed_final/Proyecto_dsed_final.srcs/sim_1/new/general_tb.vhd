----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.01.2020 17:55:41
-- Design Name: 
-- Module Name: general_tb - Behavioral
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

entity general_tb is
--  Port ( );
end general_tb;

architecture Behavioral of general_tb is
component controlador_total
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
       filter_select: in STD_LOGIC);
end component;
constant clk_period:time:=10 ns;
signal filter_select,record_enable,play_enable:std_logic;
signal reset,micro_LR,jack_sd,jack_pwm,micro_clk,micro_data,clk:std_logic;
signal a,b,pausa,c,nor_aux:std_logic:='0';
begin
UUT:controlador_total Port Map(
       clk100Mhz=>clk,
       reset =>reset,
       record_enable=>record_enable,
       pausa=>pausa,
       play_enable=>play_enable,
       micro_clk=>micro_clk,
       micro_data=>micro_data,
       micro_LR=>micro_LR,
       jack_sd=>jack_sd,
       jack_pwm=>jack_pwm,
       filter_select=>filter_select
);
process
begin
clk <= '0';
wait for clk_period/2;
clk<= '1';
wait for clk_period/2;
end process;

process
begin
reset<='1';
record_enable<='0';
pausa<='0';
filter_select<='0';
play_enable<='0';
wait for 23 ns;
reset<='0';
wait for 1 ns;
play_enable<='1';
wait for 300 us;
play_enable<='0';
wait for 1 ns;
record_enable<='1';
wait for 300 us;
record_enable<='0';
wait for 1 ns;
play_enable<='1';
wait for 200 us;
play_enable<='0';
wait for 1 ns;
record_enable<='1';
wait for 200 us;
record_enable<='0';
play_enable<='1';
wait for 200 us;
pausa<='1';
wait for 100 ns;
pausa<='0';
wait for 200 ns;
play_enable<='0';
wait;
end process;

process
begin
a <= not a after 2560 ns;
b <= not b after 1710 ns;
c <= not c after 1840 ns;
nor_aux<= a xor b xor c;
micro_data<=nor_aux;
wait for 10 ns;
end process;
end Behavioral;

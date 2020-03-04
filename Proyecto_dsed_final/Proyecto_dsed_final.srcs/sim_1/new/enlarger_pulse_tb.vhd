----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.01.2020 20:45:14
-- Design Name: 
-- Module Name: enlarger_pulse_tb - Behavioral
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

entity enlarger_pulse_tb is
--  Port ( );
end enlarger_pulse_tb;

architecture Behavioral of enlarger_pulse_tb is
component enlarger_pulse
    Port ( input : in STD_LOGIC;
           clk : in STD_LOGIC;
           reset: in std_logic;
           output : out STD_LOGIC);
end component enlarger_pulse;

signal clk, input,reset,output:std_logic;
constant clk_period:time:=10 ns;
begin

UUT:enlarger_pulse Port Map(
input=>input,
clk=>clk,
reset=>reset,
output=>output
);

process 
begin
clk<='1';
wait for clk_period/2;
clk<='0';
wait for clk_period/2;
end process;

process
begin
input<='0';
reset<='1';
wait for clk_period*3;
reset<='0';
wait for clk_period*3;
input<='1';
wait for clk_period;
input<='0';
wait for clk_period*5;
input<='1';
wait for clk_period;
input<='0';
wait for clk_period*5;
input<='1';
wait for clk_period;
reset<='1';
wait for clk_period;
input<='0';
wait for clk_period*2;
reset<='0';
wait for clk_period;
input<='1';
wait;
end process;
end Behavioral;

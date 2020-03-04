----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.11.2019 11:34:42
-- Design Name: 
-- Module Name: audio_interface_tb - Behavioral
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

entity audio_interface_tb is
--  Port ( );
end audio_interface_tb;

architecture Behavioral of audio_interface_tb is
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

signal clk_12megas, reset,sample_out_ready,jack_pwm,sample_request,micro_clk,micro_data:std_logic;
signal a,b,c,nor_aux:std_logic:='0';
signal jack_sd,micro_LR,record_enable,play_enable:std_logic;
signal sample_out:std_logic_vector(sample_size-1 downto 0);
constant clk_period : time := 10 ns; 
begin

clk_process :process 
begin
    clk_12megas <= '0';
    wait for clk_period/2;
    clk_12megas <= '1';
    wait for clk_period/2;
end process;

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
    sample_in =>sample_out,
    sample_request=>sample_request,
    jack_sd =>jack_sd,
    jack_pwm =>jack_pwm
);

process
begin

    record_enable<='1';
    play_enable<='1';
    reset<='1';
    wait for 100 ns;
    reset<='0';
    wait;
wait;
end process;
process
begin
a <= not a after 2560 ns;
b <= not b after 1710 ns;
c <= not c after 1840 ns;
nor_aux<= a xor b xor c;
micro_data<=nor_aux;
wait for 1 ns;
end process;
end Behavioral;

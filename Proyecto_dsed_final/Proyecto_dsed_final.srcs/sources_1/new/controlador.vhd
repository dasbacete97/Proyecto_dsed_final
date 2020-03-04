----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.11.2019 12:10:19
-- Design Name: 
-- Module Name: controlador - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity controlador is
    Port ( clk100Mhz : in STD_LOGIC;
           reset : in STD_LOGIC;
           micro_clk : out STD_LOGIC;
           micro_data : in STD_LOGIC;
           micro_LR : out STD_LOGIC;
           jack_sd : out STD_LOGIC;
           jack_pwm : out STD_LOGIC);
end controlador;

architecture Behavioral of controlador is

signal clk_12megas,record_enable,sample_out_ready,play_enable,sample_request:std_logic;
signal sample_out,sample_in:std_logic_vector(sample_size-1 downto 0);

signal sample_in_s:signed(sample_size downto 0);
signal sample_in_s2: signed(sample_size+2 downto 0);


component clk_wiz_0
port
 (-- Clock in ports
  -- Clock out ports
  clk_out1          : out    std_logic;
  clk_in1           : in     std_logic
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

begin
reloj : clk_wiz_0
   port map ( 
  -- Clock out ports  
   clk_out1 => clk_12megas,
   -- Clock in ports
   clk_in1 => clk100Mhz
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
sample_in_s<=signed('0' & sample_out)-128;
sample_in_s2<=(sample_in_s & "00")+128;
sample_in<=std_logic_vector(sample_in_s2(sample_size+1 downto 2));

record_enable<='1';
sample_out_ready<='1';
play_enable<='1';
sample_request<='1';
end Behavioral;

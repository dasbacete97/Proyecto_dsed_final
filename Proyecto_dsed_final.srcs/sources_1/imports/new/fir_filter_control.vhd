----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.11.2019 12:55:17
-- Design Name: 
-- Module Name: fir_filter_control - Behavioral
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

entity fir_filter_control is
    Port ( clk_12megas : in STD_LOGIC;
           reset : in STD_LOGIC;
           sample_in_ready : in STD_LOGIC;
           control : out STD_LOGIC_VECTOR(2 downto 0);
           fir_enable:out STD_LOGIC);
end fir_filter_control;

architecture Behavioral of fir_filter_control is
type state_type is (idle, s1, s2);
signal state_reg,state_next:state_type;
signal cuenta_reg,cuenta_next: std_logic_vector(2 downto 0);
begin
--next_state_register
process(clk_12megas,reset)
begin
if(reset='1')then
    state_reg<=idle;
    cuenta_reg<=(others=>'0');
elsif(rising_edge(clk_12megas))then
    state_reg<=state_next;
    cuenta_reg<=cuenta_next;
end if;
end process;

--next_state_logic
process(state_register,reset)
end Behavioral;

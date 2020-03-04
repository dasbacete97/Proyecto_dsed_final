----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.01.2020 20:34:00
-- Design Name: 
-- Module Name: enlarger_pulse - Behavioral
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

entity enlarger_pulse is
    Port ( input : in STD_LOGIC;
           clk : in STD_LOGIC;
           reset: in std_logic;
           output : out STD_LOGIC);
end enlarger_pulse;

architecture Behavioral of enlarger_pulse is
type state_type is (s0,s1,s2,s3);
signal state,n_state:state_type;
begin

state_logic:process(reset,clk)
begin
if(reset='1')then
state<=s0;
elsif(rising_edge(clk))then
state<=n_state;
end if;
end process;

next_state_logic:process(state,input)
begin
case state is
when s0 =>
    n_state<=s0;
    if(input='1')then
        n_state<=s1;
    else
        n_state<=s0;
    end if;
when s1 =>
    n_state<=s1;
    if(input='0')then
        n_state<=s2;
    else
        n_state<=s1;
    end if;
when s2 =>
    n_state<=s2;
    if(input='1')then
        n_state<=s3;
    else
        n_state<=s2;
    end if;
when others=>
n_state<=s3;
if(input='0')then
    n_state<=s0;
else
    n_state<=s3;
end if;
end case;
end process;

output_state_logic:process(state)
begin
case state is
when s0 =>
    output<='0';
when s1 =>
   output<='0';
when others =>
    output<='1';
end case;
end process;

end Behavioral;

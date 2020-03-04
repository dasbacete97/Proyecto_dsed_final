----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.12.2019 17:47:39
-- Design Name: 
-- Module Name: control_escritura - Behavioral
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
use work.dsed.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity control_escritura is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           signal_ready : in STD_LOGIC;
           enable : in STD_LOGIC;
           addr : out STD_LOGIC_vector(18 downto 0)
           );
end control_escritura;

architecture Behavioral of control_escritura is

signal addr_reg, addr_next : STD_LOGIC_vector(18 downto 0);

begin
process (clk,rst)
begin
if(rst='1') then 
    addr_reg<= (others=>'0');
elsif(rising_edge(clk))then
    addr_reg<= addr_next;
end if;
end process;

process (addr_reg,enable,signal_ready)
begin
if(signal_ready = '1' and enable='1')then
    addr_next<=std_logic_vector(unsigned(addr_reg)+1);
else
    addr_next<=addr_reg;
end if;
end process;

addr<=addr_reg;
end Behavioral;

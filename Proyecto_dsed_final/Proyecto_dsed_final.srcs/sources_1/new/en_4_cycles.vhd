----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.11.2019 12:23:53
-- Design Name: 
-- Module Name: en_4_cycles - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity en_4_cycles is
    Port ( clk_12megas : in STD_LOGIC;
           reset : in STD_LOGIC;
           clk_3megas : out STD_LOGIC;
           en_2_cycles : out STD_LOGIC;
           en_4_cycles : out STD_LOGIC);
end en_4_cycles;

architecture Behavioral of en_4_cycles is
signal aux_clk3,aux_en2,aux_en4:std_logic:='0';
signal cuenta4: unsigned(1 downto 0):= "00";
begin

process(clk_12megas,reset)
begin 
if(reset='1')then
    cuenta4<="00";
    aux_en2<='0';
    aux_clk3<='0';
elsif(rising_edge(clk_12megas))then
    --contador de enable_4_cycles
    if(cuenta4(1)='0')then
         aux_en4<= not aux_en4;
    else 
        aux_en4<= aux_en4;
    end if;
    --contador de clk_3_megas
    if(aux_en2='0')then
         aux_clk3<= not aux_clk3;
    else 
        aux_clk3<= aux_clk3;
    end if;
    --señal en_2_cycles
    aux_en2<= not aux_en2;
    --aumento de contadores
    cuenta4<=cuenta4+1;
end if;
end process;

en_4_cycles<=aux_en4;
en_2_cycles<=aux_en2;
clk_3megas<=aux_clk3;
end Behavioral;

----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.12.2019 17:47:39
-- Design Name: 
-- Module Name: contol_lectura - Behavioral
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

entity contol_lectura is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           sample_request : in STD_LOGIC;
           play_enable : out STD_LOGIC;
           addr : out STD_LOGIC);
end contol_lectura;

architecture Behavioral of contol_lectura is

begin



end Behavioral;

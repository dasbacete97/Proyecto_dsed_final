----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.01.2020 20:33:28
-- Design Name: 
-- Module Name: display - Behavioral
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

entity display is
    Port ( clk: in std_logic;
           rec : in STD_LOGIC;
           play : in STD_LOGIC;
           pause : in std_logic;
           segmentos : out STD_LOGIC_VECTOR (6 downto 0);
           display : out STD_LOGIC_VECTOR (7 downto 0));
end display;

architecture Behavioral of display is

type state_type is (S0,S1,S2,S3,S4);
signal state, next_state : state_type;

signal codigo_rec,codigo_play,codigo_pause: STD_LOGIC_VECTOR (6 downto 0);
begin
codigo_rec<="0001000";--R
codigo_play<="0001100";--P
codigo_pause<="0010010";--S
display<="01111111";
         
segmentos<=codigo_play when (play='1' and rec='0' and pause='0') else
           codigo_rec when (play='0' and rec='1' and pause='0') else
           codigo_pause when pause='1' else
           "1111111";
end Behavioral;
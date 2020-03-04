----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.12.2019 10:19:46
-- Design Name: 
-- Module Name: Ram_tb - Behavioral
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
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Ram_tb is
--  Port ( );
end Ram_tb;

architecture Behavioral of Ram_tb is
constant clk_period:time:= 84 ns;
signal clka,ena:std_logic;
signal wea: std_logic_vector(0 downto 0);
signal addra:std_logic_vector(18 downto 0):=(others=>'0');
signal dina:std_logic_vector(7 downto 0):=(others=>'0');
signal douta:std_logic_vector(7 downto 0);

signal auxa,auxb,auxc:std_logic_vector(7 downto 0);
COMPONENT blk_mem_gen_0
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(18 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END COMPONENT;
begin



--dina<=auxa or auxb or auxc;
--process
--begin
--    wea <= "1";
--    wait for 1000 ns;
--    wea <= "0";
--    wait for 1000 ns;
--end process;
--ena<='1';
--process
--begin
--    ena <= '1';
--    wait for 600 ns;
--    ena <= '0';
--    wait for 600 ns;
--end process;

--CLK_process:process
--begin
--    clka <= '0';
--    wait for clk_period/2;
--    clka <= '1';
--    wait for clk_period/2;
--end process;

--aux:process
--begin 
--    dina<=std_logic_vector(unsigned(dina)+1);
--    wait for 200 ns;
--end process;
UUT : blk_mem_gen_0
  PORT MAP (
    clka => clka,
    ena => ena,
    wea => wea,
    addra => addra,
    dina => dina,
    douta => douta
  );
--data_process: process
--begin
--addra<=(others=>'0') after 1000 ns;

--addra<=std_logic_vector(unsigned(addra)+1);
--addra<=(others=>'0') after 1000 ns;

--wait for 200 ns;

--end process;
process
begin
    wait for clk_period/2;
    --Writing to all the memory locations of the BRAM.Set wea "1" for this.
    for i in 0 to 255 loop
        ena <= '1';  --Enable RAM always.
        wea <= "1";
        wait for clk_period;
        addra <= addra + "1";
        dina <= dina + "1";
    end loop;  
    addra <= (others=>'0');  --reset the address value for reading from memory location "0"
    --reading all the 256 memory locations in the BRAM.
    for i in 0 to 255 loop
        ena <= '1';  --Enable RAM always.
        wea <= "0";
        wait for clk_period;
        addra <= addra + "1";
    end loop;
    wait;
end process;   

--Clock generation - Generates 500 MHz clock with 50% duty cycle.
process
begin
    clka <= '1';
    wait for clk_period/2;  --"ON" time.
    clka <= '0';
    wait for clk_period/2;  --"OFF" time.
end process;   
   
end Behavioral;

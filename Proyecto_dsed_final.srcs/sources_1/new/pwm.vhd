----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.11.2019 11:58:58
-- Design Name: 
-- Module Name: pwm - Behavioral
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

entity pwm is
    Port ( clk_12megas : in STD_LOGIC;
           reset : in STD_LOGIC;
           en_2_cycles: in STD_LOGIC;
           sample_in : in STD_LOGIC_VECTOR (sample_size-1 downto 0);
           sample_request : out STD_LOGIC;
           pwm_pulse : out STD_LOGIC);
end pwm;

architecture Behavioral of pwm is

signal cuenta_reg,cuenta_next :unsigned(8 downto 0);
signal clk_en:std_logic:='0';
signal bit_aux:std_logic;

begin

-- actualizacion de registros
process(clk_12megas,reset)
begin
if(reset='1')then
    cuenta_reg<=to_unsigned(0,cuenta_reg'length);
elsif(rising_edge(clk_12megas) and en_2_cycles='1') then
    cuenta_reg<=cuenta_next;
end if;
end process;

--logica de next_register
process(sample_in, cuenta_reg)
begin

    if(cuenta_reg=299)then--sino se pone a 0 en el la cuenta 
        cuenta_next<=to_unsigned(0,cuenta_next'length);
    else
        cuenta_next<=cuenta_reg + 1;
    end if;

end process;


pwm_pulse<= '1' when (cuenta_reg>(unsigned(sample_in)-1)) else
'0';

with cuenta_reg select sample_request<=
    en_2_cycles  when to_unsigned(299,cuenta_reg'length), -- cuando sea 0 o 299, o sale tarde o se alarga un pulso
    '0' when others;
    

end Behavioral;

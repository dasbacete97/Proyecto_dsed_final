----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.11.2019 11:35:38
-- Design Name: 
-- Module Name: fir_filter - Behavioral
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

entity fir_filter is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           sample_in : in STD_LOGIC_VECTOR (7 downto 0);
           sample_in_enable : in STD_LOGIC;
           filter_select : in STD_LOGIC;
           sample_out : out STD_LOGIC_VECTOR (7 downto 0);
           sample_out_ready : out STD_LOGIC);
end fir_filter;

architecture Behavioral of fir_filter is
--costantes paso bajo
constant cb0,cb4:signed:="00000101";
constant cb1,cb3:signed:="00011111";
constant cb2:signed:="00111001";
--costantes paso alto 
constant ca0,ca4:signed:="11111111";
constant ca1,ca3:signed:="11100110";
constant ca2:signed:="01001101";

signal fir_enable:std_logic;
signal control: std_logic_vector(3 downto 0);
signal c0,c1,c2,c3,c4:signed(7 downto 0):=(others=>'0');

--signal r1_next, r1_reg:signed(15 downto 0):=(others=>'0');
--signal r2_next,r2_reg,r3_next,r3_reg:signed(sample_size-1 downto 0);
signal r1_next, r1_reg,r2_next,r2_reg:signed(15 downto 0):=(others=>'0');
signal r3_next,r3_reg:signed(14 downto 0):=(others=>'0');

signal x0, x1, x2, x3, x4:std_logic_vector(7 downto 0):=(others=>'0');
signal multA, multB:signed(7 downto 0):=(others=>'0');
signal en_5:std_logic;--podria no valer pr nada
component fir_filter_control 
Port ( clk_12megas : in STD_LOGIC;
           reset : in STD_LOGIC;
           sample_in_ready : in STD_LOGIC;
           control : out STD_LOGIC_VECTOR(3 downto 0);
           fir_enable:out STD_LOGIC);
end component;
begin
fir_control:fir_filter_control 
Port map(
clk_12megas=>clk,
reset=>reset,
sample_in_ready=>sample_in_enable,
control=> control,
fir_enable=>fir_enable
);
--input register
process(clk)
begin
    if(reset = '1')then
        x0<= (others=>'0');
        x1<= (others=>'0');
        x2<= (others=>'0');
        x3<= (others=>'0');
        x4 <= (others=>'0');
    elsif(rising_edge(clk) and sample_in_enable='1')then
        x4<=x3;
        x3<=x2;
        x2<=x1;
        x1<=x0;
        x0<=sample_in;
    end if;
end process;
-- state register logic
process(clk,reset)
begin
    if((reset='1'))then--debe haber una señal que lo reinicie cuando pasen 4 iteraciones
        r1_reg<=(others=>'0');
        r2_reg<=(others=>'0');
        r3_reg<=(others=>'0');
    elsif(rising_edge(clk))then
        r1_reg<=r1_next;
        r2_reg<=r2_next;
        r3_reg<=r3_next;
    end if;
end process;

--next state logic
process(fir_enable,filter_select,control,sample_in,r1_reg,r2_reg,r3_reg,x0,x1,x2,x3,x4,multA,multB)
begin
    if(filter_select='1')then
        c0<=ca0;
        c1<=ca1;
        c2<=ca2;
        c3<=ca3;
        c4<=ca4;
    else
        c0<=cb0;
        c1<=cb1;
        c2<=cb2;
        c3<=cb3;
        c4<=cb4;
    end if;
    case control is 
        when "0000" => multA<= signed(x0);
        when "0001" => multA<= signed(x1);
        when "0010" => multA<= signed(x2); 
        when "0011" => multA<= signed(x3);
        when "0100"=> multA<= signed(x4);
        when others=> multA<=(others=>'0') ;   
    end case;
    case control is 
        when "0000" => multB<= c0;
        when "0001" => multB<= c1;
        when "0010" => multB<= c2; 
        when "0011" => multB<= c3;        
        when "0100" => multB<= c4; 
        when others => multB<=(others=>'0');
    end case;
    if(fir_enable='1')then
        r3_next<=(others=>'0');
        r1_next<=r1_reg;
        r2_next<=r2_reg;
    else
        r1_next<=multA*multB;
        --r2_next<=r1_reg(15 downto 8);
        r2_next<=r1_reg;
        
        r3_next<=(r2_reg(15) & r2_reg(13 downto 0))  + r3_reg;
    end if;

end process;
--sample_out<= std_logic_vector(r3_reg);
sample_out<= std_logic_vector(r3_reg(14 downto 7));

sample_out_ready<=fir_enable;
end Behavioral;
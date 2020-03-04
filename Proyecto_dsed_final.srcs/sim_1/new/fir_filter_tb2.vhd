library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.DSED.all;
use IEEE.NUMERIC_STD.ALL;


entity fir_filter_tb2 is
end fir_filter_tb2;
architecture Behavioral of fir_filter_tb2 is

component fir_filter 
  Port ( clk : in STD_LOGIC;
         reset : in STD_LOGIC;
         sample_in : in STD_LOGIC_VECTOR (sample_size-1 downto 0);
         sample_in_enable : in STD_LOGIC;
         filter_select : in STD_LOGIC;
         sample_out : out STD_LOGIC_VECTOR (sample_size-1 downto 0);
         sample_out_ready : out STD_LOGIC);
end component;
signal clk,reset,sample_in_enable,filter_select,sample_out_ready:std_logic;
--signal a,b,c:std_logic:='0';
signal sample_in,sample_out:std_logic_vector(sample_size-1 downto 0);
constant clk_period : time := 84 ns; 
begin
UUT: fir_filter port map(
    clk=>clk,
    reset=>reset,
    sample_in=>sample_in,
    sample_in_enable=>sample_in_enable,
    filter_select=>filter_select,--filtro paso bajo 
    sample_out=>sample_out,
    sample_out_ready=>sample_out_ready
);

CLK_process:process
begin
    clk <= '0';
    wait for clk_period/2;
    clk<= '1';
    wait for clk_period/2;
end process;


--señal aleatoria de sample_in
process
begin

    sample_in<="00000000";--0.5
    wait for 4000 ns;
    sample_in<="01111111";--0.5
    wait for 4000 ns;
    sample_in<="00000000";--0.5
wait;
end process;            

process
begin
    reset <='1';
    wait for 10 ns;
    reset<='0';
    wait;

end process;
--señal sample in cada 1000 ns durnte un periodo
process
begin

    sample_in_enable<='1';
    wait for clk_period;
    sample_in_enable<='0';
    wait for 4000 ns;
end process;

--paso bajo(0) a paso alto(1)
process
begin
filter_select<='0';
--wait for 40000 ns;
--filter_select<='1';
wait;
end process;
end Behavioral;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
use std.textio.all;
use work.DSED.all;

ENTITY fir_filter_advance_tb IS
END fir_filter_advance_tb;
ARCHITECTURE behavioral OF fir_filter_advance_tb IS

component fir_filter 
  Port ( clk : in STD_LOGIC;
         reset : in STD_LOGIC;
         sample_in : in STD_LOGIC_VECTOR (sample_size-1 downto 0);
         sample_in_enable : in STD_LOGIC;
         filter_select : in STD_LOGIC;
         sample_out : out STD_LOGIC_VECTOR (sample_size-1 downto 0);
         sample_out_ready : out STD_LOGIC);
end component;

-- Clock signal declaration
signal clk : std_logic := '1';
-- Declaration of the reading signal
signal Sample_In : std_logic_vector(sample_size -1 downto 0) := (others => '0');
-- Clock period definitions
signal sample_out : std_logic_vector(sample_size -1 downto 0) := (others => '0');

signal reset: std_logic;
signal sample_in_enable:std_logic:='0';
signal filter_select:std_logic:='1';
signal sample_out_ready:std_logic;
constant clk_period : time := 10 ns;
constant sample_in_enable_period:time:= 200 ns;
BEGIN
-- Clock statement
clk <= not clk after clk_period/2;


UUT: fir_filter port map(
    clk=>clk,
    reset=>reset,
    sample_in=>sample_in,
    sample_in_enable=>sample_in_enable,
    filter_select=>filter_select,--filtro paso bajo 
    sample_out=>sample_out,
    sample_out_ready=>sample_out_ready
);

process
begin
reset<='0';
wait for 1 ns;
reset<='1';
wait for 10 ns;
reset<='0';
wait;
end process;
read_process : PROCESS (sample_in_enable)
FILE in_file : text OPEN read_mode IS "sample_in.dat";

VARIABLE in_line : line;
VARIABLE in_int : integer;
VARIABLE out_int : integer;
VARIABLE in_read_ok : BOOLEAN;

BEGIN


if (sample_in_enable'event and sample_in_enable = '1') then
    if NOT endfile(in_file) then
        ReadLine(in_file,in_line);
        Read(in_line, in_int, in_read_ok);
        sample_in <=std_logic_vector( to_signed(in_int, 8)); -- 8 = the bit width
    else
        assert false report "Simulation Finished" severity failure;
    end if;
end if;
end process;

WRITE_PROCESS:PROCESS(sample_out_ready)
FILE out_file : text OPEN write_mode IS "sample_outPA.dat";
VARIABLE out_line : line;
variable sample_out_matlab: integer;

begin
if(sample_out_ready'event and sample_out_ready='1')then

    sample_out_matlab := to_integer(signed(sample_out));
    Write(out_line, sample_out_matlab);
    WriteLine(out_file,out_line);

end if;
end process;

sample_in_en_process:process
begin
    sample_in_enable <= '1';
    wait for sample_in_enable_period/20;
    sample_in_enable<= '0';
    wait for sample_in_enable_period*19/20;
end process;
 
end Behavioral;












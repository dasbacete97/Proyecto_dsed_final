----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.11.2019 19:10:32
-- Design Name: 
-- Module Name: FSMD_microphone - Behavioral
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

entity FSMD_microphone is
    Port ( clk_12megas : in STD_LOGIC;
           reset : in STD_LOGIC;
           enable_4_cycles : in STD_LOGIC;
           micro_data : in STD_LOGIC;
           sample_out : out STD_LOGIC_VECTOR (sample_size-1 downto 0);
           sample_out_ready : out STD_LOGIC);
end FSMD_microphone;

architecture Behavioral of FSMD_microphone is

type state_type is (idle, muestreo);
signal state, next_state : state_type;
signal dato1_reg,dato1_next, dato2_reg,dato2_next:unsigned (sample_size-1 downto 0):=(others=>'0');
signal cuenta_reg,cuenta_next : unsigned(8 downto 0):=(others=>'0');
signal sample_out_reg,sample_out_next:std_logic_vector(sample_size-1 downto 0);
signal primer_ciclo_reg,primer_ciclo_next : std_logic;

begin

SYNC_PROC : process (clk_12megas,reset,enable_4_cycles)
begin
    if (reset = '1') then
        state <= idle;
        dato1_reg<=(others=>'0');
        dato2_reg<=(others=>'0');
        cuenta_reg<=(others=>'0');
        primer_ciclo_reg<='0';
    elsif (rising_edge(clk_12megas)and enable_4_cycles='1') then
        
            state<=next_state;
            
            dato1_reg<=dato1_next;
            dato2_reg<=dato2_next;
            cuenta_reg<=cuenta_next;
            primer_ciclo_reg<=primer_ciclo_next;
            sample_out_reg<=sample_out_next;
            
    end if;
    
end process;

OUTPUT_DECODE : process (reset,state,micro_data,cuenta_reg,dato1_reg,dato2_reg,primer_ciclo_reg)
begin
--valores por defecto
dato1_next<=dato1_reg;
dato2_next<=dato2_reg;
cuenta_next<=cuenta_reg;
primer_ciclo_next<=primer_ciclo_reg;
sample_out_next<=sample_out_reg;

case state is
when idle=>
    sample_out_next<=(others=>'0');

when others=>
        if((cuenta_reg <=105)or
                ((cuenta_reg >=150)and
                (cuenta_reg <=255))) then
                
                 cuenta_next<=cuenta_reg + 1;
                 
                    if(micro_data='1')then
                        if (dato1_reg/=255)then
                            dato1_next<=dato1_reg + 1;
                            dato2_next<=dato2_reg + 1;
                        end if;
                    end if;
           
        
        elsif((cuenta_reg >=106) and
              (cuenta_reg <= 149))then
              
                   cuenta_next<=cuenta_reg + 1;
                   
                   if(micro_data='1')then
                        if (dato1_reg/=255)then
                            dato1_next<=dato1_reg + 1;
                        end if;
                   end if;
                   
                   if (cuenta_reg =106)then
                   
                        dato2_next<=(others=>'0');
                        
                        if(primer_ciclo_reg = '1')then
                   
                            sample_out_next <= std_logic_vector(dato2_reg);
                        end if;
                   end if;
   
        else
            
            if(cuenta_reg=299)then
            
                 cuenta_next<=(others=>'0');
                 primer_ciclo_next<='1';
            else
            
                cuenta_next<=cuenta_reg +1;    
            end if;
            
            if(micro_data='1')then
                if (dato2_reg/=255)then
                    dato2_next<=dato2_reg +1;
                end if;
            end if;
            
            if(cuenta_reg = 256)then
                sample_out_next <= std_logic_vector(dato1_reg);
                dato1_next<=(others=>'0');
            end if;
        end if;

end case;
end process;

STATE_DECODE: process(reset,state,micro_data)
begin
case state is 
when idle =>
    if(reset='0')then
        next_state <= muestreo;
    else
        next_state <= idle;
    end if;
when others=>
    if(reset='1')then
        next_state <= idle;
    else
        next_state <= muestreo;
    end if;
end case;
end process;
--Combinational logic
with (cuenta_reg) select sample_out_ready<=
(enable_4_cycles ) when to_unsigned(256,cuenta_reg'length),--cambio aqui quitando el and con el reloj
(enable_4_cycles and primer_ciclo_reg)when to_unsigned(106,cuenta_reg'length),
'0' when others;

sample_out<=sample_out_reg;


end Behavioral;
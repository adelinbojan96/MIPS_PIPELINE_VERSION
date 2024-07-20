library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
entity mpg is
port (
 clk : in std_logic;
 btn: in std_logic;
 enable: out std_logic
 );
end mpg;

architecture mpg of mpg is
    signal initial_counterValue : std_logic_vector(15 downto 0) := x"0000";
    signal d1,d2,d3,Q1, Q2, Q3: std_logic := '0';
begin
    d1 <= btn;
    d2 <= q1;
    d3 <= q2;
    process(clk) is 
        begin 
            if(rising_edge(clk)) then
                initial_counterValue <= initial_counterValue + 1;
            end if;
            if(initial_counterValue = x"FFFF") then
                if(rising_edge(clk)) then
                        Q1 <= d1;
                end if;
            end if;
    end process;
    process(clk) is
        begin
            if(rising_edge(clk)) then
                    q2 <= d2;
                 end if;       
    end process;
    process(clk) is
        begin
            if(rising_edge(clk)) then
                    q3 <= d3;
                end if; 
     end process;
     
    enable <= q2 and not(q3);
end mpg;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
entity SSD is
port
(
clk : in std_logic;
digit0: in std_logic_vector(3 downto 0);
digit1: in std_logic_vector(3 downto 0);
digit2: in std_logic_vector(3 downto 0);
digit3: in std_logic_vector(3 downto 0);
digit4: in std_logic_vector(3 downto 0);
digit5: in std_logic_vector(3 downto 0);
digit6: in std_logic_vector(3 downto 0);
digit7: in std_logic_vector(3 downto 0);
cat: out std_logic_vector(6 downto 0);
an: out std_logic_vector(7 downto 0)
);
end SSD;

architecture SSD of SSD is
signal sel: std_logic_vector(2 downto 0);
signal outCounter: std_logic_vector(16 downto 0);
signal outMux1: std_logic_vector(3 downto 0) := "0000";
begin
    sel <= outCounter(16 downto 14);
    process(clk) is 
        begin 
            if(rising_edge(clk)) then 
                outCounter <= outCounter + 1;
            end if;
    end process;
    process(sel) is
        begin   
            case sel is 
                when "000" => outMux1 <= digit0; an <= x"FE";
                when "001" => outMux1 <= digit1; an <= "11111101";
                when "010" => outMux1 <= digit2; an <= "11111011";
                when "011" => outMux1 <= digit3; an <= "11110111";
                when "100" => outMux1 <= digit4; an <= "11101111";
                when "101" => outMux1 <= digit5; an <= "11011111";
                when "110" => outMux1 <= digit6; an <= "10111111";
                when "111" => outMux1 <= digit7; an <= "01111111";
                when others => outMux1 <= "0000"; an <= "11111111";
            end case;
    end process;
    process(outMux1) is
        begin
            case outMux1 is
                when "0000" => cat <= "1000000"; --0
                when "0001" => cat <= "1111001"; --1
                when "0010" => cat <= "0100100"; --2
                when "0011" => cat <= "0110000"; --3
                when "0100" => cat <= "0011001"; --4
                when "0101" => cat <= "0010010"; --5
                when "0110" => cat <= "0000010"; --6
                when "0111" => cat <= "1111000"; --7
                when "1000" => cat <= "0000000"; --8
                when "1001" => cat <= "1001111"; --9
                when "1010" => cat <= "0001000"; --A
                when x"B" => cat <= "0000011"; --B
                when x"C" => cat <= "1000110"; --C
                when x"D" => cat <= "0100001"; --D
                when x"E" => cat <= "0000110"; --E
                when x"F" => cat <= "0001110"; --F
                when others => cat <="1111111"; --nothing
            end case;
    end process;
end SSD;

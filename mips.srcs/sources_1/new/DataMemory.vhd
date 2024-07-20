library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
entity DataMemory is
Port 
(   
    clk: in std_logic;
    enable: in std_logic;
    mem_write: in std_logic;
    alu_res: in std_logic_vector(31 downto 0);
    rd2: in std_logic_vector(31 downto 0);
    mem_data: out std_logic_vector(31 downto 0);
    alu_res_out: out std_logic_vector(31 downto 0)
    );
end DataMemory;

architecture DataMemory of DataMemory is
type ram_array is array (0 to 63) of std_logic_vector(31 downto 0);
signal ram: ram_array :=(
    --preinitialised ram with values from 1 to 10
    "00000000000000000000000000000001",
    "00000000000000000000000000000010",
    "00000000000000000000000000000011",
    "00000000000000000000000000000100",
    "00000000000000000000000000000101",
    "00000000000000000000000000000110",
    "00000000000000000000000000000111",
    "00000000000000000000000000001000",
    "00000000000000000000000000001001",
    "00000000000000000000000000001010", 
    others => (others => '0'));
begin
    process(clk)
    begin
        if(rising_edge(clk)) then
            if (enable = '1') then
                --synchronous write operation 
                if mem_write = '1' then
                    ram(conv_integer(unsigned(alu_res(5 downto 0)))) <= rd2;
                end if;
            end if;
        end if;
    end process;
    --asynchronous read operation
    mem_data <= ram(conv_integer(unsigned(alu_res(5 downto 0))));
    alu_res_out <= alu_res;
    
end DataMemory;

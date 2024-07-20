library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity IF_FD is
Port ( 
clk: in std_logic;
pc_4IN: in std_logic_vector (31 downto 0);
instructionIN: IN std_logic_vector ( 31 downto 0);
pc_4OUT: out std_logic_vector(31 downto 0);
instructionOUT: out std_logic_vector(31 downto 0)
);
end IF_FD;

architecture IF_FD of IF_FD is
signal memory: std_logic_vector(63 downto 0) := (others => '0');
begin
    process(clk) is 
        begin
            if(rising_edge(clk)) then
                memory <= instructionIN & pc_4IN;
            end if; 
    end process;
    instructionOUT <= memory(63 downto 32);
    pc_4OUT <= memory(31 downto 0);
end IF_FD;

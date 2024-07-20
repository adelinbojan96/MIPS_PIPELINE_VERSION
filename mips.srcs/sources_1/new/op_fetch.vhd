library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity op_fetch is
port
(   
    clk: in std_logic;
    enable: in std_logic;
    regWrite: in std_logic;
    instr: in std_logic_vector(25 downto 0);
    wa: in std_logic_vector(4 downto 0);
    extOp: in std_logic;
    wd: in std_logic_vector(31 downto 0);
    ext_Imm: out std_logic_vector(31 downto 0);
    funct: out std_logic_vector(5 downto 0);
    sa: out std_logic_vector(4 downto 0);
    rd1: out std_logic_vector(31 downto 0);
    rd2: out std_logic_vector(31 downto 0)
);
end op_fetch;

architecture op_fetch of op_fetch is
type reg_array is array (0 to 31) of std_logic_vector(31 downto 0);
signal reg: reg_array := (others => (others => '0'));
signal ra1, ra2: std_logic_vector(4 downto 0);
signal zeroExtender, signExtender: std_logic_vector(31 downto 0);
begin
    ra1 <= instr(25 downto 21);
    ra2 <= instr(20 downto 16);
	process(clk) is
		begin
			if (falling_edge(clk)) then
				if(enable = '1' and regWrite = '1') then
					reg(conv_integer(wa)) <= wd;
				end if;
			end if;
	end process;
	rd1 <= reg(conv_integer(ra1));
	rd2 <= reg(conv_integer(ra2));    
	
    signExtender <= (31 downto 16 => instr(15)) & instr(15 downto 0);
    zeroExtender <= (31 downto 16 => '0') & instr(15 downto 0);
    ext_Imm <= zeroExtender when extOp = '0' else signExtender;
    sa <= instr(10 downto 6);
    funct <= instr(5 downto 0);
end op_fetch;
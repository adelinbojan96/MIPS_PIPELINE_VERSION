library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MainControlUnit is
port
(
    instruction: in std_logic_vector(5 downto 0);
    reg_dst: out std_logic;
    ext_op: out std_logic;
    alu_src: out std_logic;
    branch: out std_logic;
    jump: out std_logic;
    alu_op: out std_logic_vector(2 downto 0);
    mem_write: out std_logic;
    mem_to_reg: out std_logic;
    reg_write: out std_logic
);
end MainControlUnit;

architecture MainControlUnit of MainControlUnit is
begin
    
    process(instruction) is
        begin
            case instruction is
                when "000000" => reg_dst <= '1'; ext_op <= '0'; alu_src <= '0'; branch <= '0'; jump<='0'; mem_write <= '0'; mem_to_reg <= '0'; reg_write <= '1'; alu_op <= "001"; --all R
                when "001000" => reg_dst <= '0'; ext_op <= '1'; alu_src <= '1'; branch <= '0'; jump<='0'; mem_write <= '0'; mem_to_reg <= '0'; reg_write <= '1'; alu_op <= "010"; --addi
                when "100011" => reg_dst <= '0'; ext_op <= '1'; alu_src <= '1'; branch <= '0'; jump<='0'; mem_write <= '0'; mem_to_reg <= '1'; reg_write <= '1'; alu_op <= "010"; --lw
                when "101011" => reg_dst <= '0'; ext_op <= '1'; alu_src <= '1'; branch <= '0'; jump<='0'; mem_write <= '1'; mem_to_reg <= '1'; reg_write <= '0'; alu_op <= "010"; --sw
                when "000100" => reg_dst <= '1'; ext_op <= '1'; alu_src <= '0'; branch <= '1'; jump<='0'; mem_write <= '0'; mem_to_reg <= '0'; reg_write <= '0'; alu_op <= "011"; --beq
                when "001100" => reg_dst <= '0'; ext_op <= '0'; alu_src <= '1'; branch <= '0'; jump<='0'; mem_write <= '0'; mem_to_reg <= '0'; reg_write <= '1'; alu_op <= "000"; --andi
                when "001101" => reg_dst <= '0'; ext_op <= '0'; alu_src <= '1'; branch <= '0'; jump<='0'; mem_write <= '0'; mem_to_reg <= '0'; reg_write <= '1'; alu_op <= "100"; --ori
                when "000010" => reg_dst <= '0'; ext_op <= '0'; alu_src <= '1'; branch <= '0'; jump<='1'; mem_write <= '0'; mem_to_reg <= '0'; reg_write <= '0'; alu_op <= "000"; -- jump
                when others =>   reg_dst <= '0'; ext_op <= '0'; alu_src <= '0'; branch <= '0'; jump<='0'; mem_write <= '0'; mem_to_reg <= '0'; reg_write <= '0'; alu_op <= "000";
            end case;
    end process;

end MainControlUnit;

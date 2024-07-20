library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
entity execution_unit is
Port (
pc_4: in std_logic_vector(31 downto 0);
rd_1: in std_Logic_vector(31 downto 0);
ALU_src: in std_logic;
rd_2: in std_Logic_vector(31 downto 0);
ext_imm: in std_Logic_vector(31 downto 0);
sa: in std_logic_vector(4 downto 0);
func: in std_Logic_vector(5 downto 0);
alu_op: in std_Logic_vector(2 downto 0);
regDst: in std_logic;
instr1: in std_logic_vector(4 downto 0);
instr2: in std_logic_vector(4 downto 0);
zero: out std_Logic;
ALU_res: out std_logic_vector(31 downto 0);
Branch_Address: out std_Logic_vector(31 downto 0);
ex_rd_2: out std_logic_vector(31 downto 0);  
out_instr: out std_logic_vector(4 downto 0) 
);
end execution_unit;

architecture execution_unit of execution_unit is
signal outMux1: std_logic_vector(31 downto 0);
--signal outMux2: std_logic_Vector(31 downto 0);
signal ext_imm_shifted: std_logic_vector(31 downto 0);
signal alu_ctrl: std_logic_vector(2 downto 0);
signal alu_res_before: std_logic_vector(31 downto 0) := x"00000000";
begin   
        out_instr <= instr1 when regDst = '0' else instr2;
        outMux1 <= Rd_2 when alu_src = '0' else Ext_imm; --mux
        ext_imm_shifted <= ext_imm(29 downto 0) & "00"; --shifter
        branch_address <= ext_imm_shifted + pc_4; --adder
        process(alu_op, func) is --alu control 
            begin
                case alu_op is
                   when "001" =>   case func is 
                                        when "100000" =>  alu_ctrl <= "000";-- +
                                        when "100010" =>  alu_ctrl <= "001";-- -
                                        when "000000" =>  alu_ctrl <= "010";-- <<1
                                        when "000010" =>  alu_ctrl <= "011";-- >>1
                                        when "100100" =>  alu_ctrl <= "100";-- &
                                        when "100101" =>  alu_ctrl <= "101";-- |
                                        when "100110" =>  alu_ctrl <= "110";-- ^
                                        when "000100" =>  alu_ctrl <= "111";-- <<1
                                        when others => alu_ctrl <= "000";
                                    end case; 
                   when "010" => alu_ctrl <= "000"; -- +;
                   when "011" => alu_ctrl <= "001"; -- -;
                   when "000" => alu_ctrl <= "100"; -- &;
                   when "100" => alu_ctrl <= "101"; -- |;
                   when others => alu_ctrl <= "000"; -- +;
               end case;
        end process;
        process(alu_ctrl, sa) is
            begin
                case alu_ctrl is
                        when "000" => alu_res_before <= rd_1 + outmux1;
                        when "001" => alu_res_before <= rd_1 - outmux1;
                        when "010" => case sa(2 downto 0) is
                                          when "000" => alu_res_before <= rd_1;
                                          when "001" => alu_res_before <= rd_1(30 downto 0) & '0';
                                          when "010" => alu_res_before <= rd_1(29 downto 0) & "00";
                                          when "011" => alu_res_before <= rd_1(28 downto 0) & "000";
                                          when "100" => alu_res_before <= rd_1(27 downto 0) & "0000";
                                          when "101" => alu_res_before <= rd_1(26 downto 0) & "00000";
                                          when "110" => alu_res_before <= rd_1(25 downto 0) & "000000";
                                          when "111" => alu_res_before <= rd_1(24 downto 0) & "0000000";
                                          when others => alu_res_before <= rd_1;
                                      end case;
                        when "011" => case sa(2 downto 0) is
                                          when "000" => alu_res_before <= rd_1;
                                          when "001" => alu_res_before <= '0' & rd_1(31 downto 1);
                                          when "010" => alu_res_before <= "00" & rd_1(31 downto 2);
                                          when "011" => alu_res_before <= "000" & rd_1(31 downto 3) ;
                                          when "100" => alu_res_before <= "0000" & rd_1(31 downto 4);
                                          when "101" => alu_res_before <= "00000" & rd_1(31 downto 5);
                                          when "110" => alu_res_before <= "000000" & rd_1(31 downto 6);
                                          when "111" => alu_res_before <= "0000000" & rd_1(31 downto 7);
                                          when others => alu_res_before <= rd_1;
                                      end case;
                        when "100" => alu_res_before <= rd_1 and rd_2;
                        when "101" => alu_res_before <= rd_1 or rd_2;
                        when "110" => alu_res_before <= rd_1 xor rd_2;
                        when "111" => case sa(2 downto 0) is
                                          when "000" => alu_res_before <= rd_1;
                                          when "001" => alu_res_before <= rd_1(30 downto 0) & '0';
                                          when "010" => alu_res_before <= rd_1(29 downto 0) & "00";
                                          when "011" => alu_res_before <= rd_1(28 downto 0) & "000";
                                          when "100" => alu_res_before <= rd_1(27 downto 0) & "0000";
                                          when "101" => alu_res_before <= rd_1(26 downto 0) & "00000";
                                          when "110" => alu_res_before <= rd_1(25 downto 0) & "000000";
                                          when "111" => alu_res_before <= rd_1(24 downto 0) & "0000000";
                                          when others => alu_res_before <= rd_1;
                                      end case;
                    when others => alu_res_before <= x"00000000";                                              
                end case;
        end process;
        zero <= '1' when alu_res_before = x"00000000" else '0';
        alu_res <= alu_res_before;
     
end execution_unit;

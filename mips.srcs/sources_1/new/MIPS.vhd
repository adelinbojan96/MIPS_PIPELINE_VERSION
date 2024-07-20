library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity MIPS is
    port
    (
         clk : in std_logic;
         btn : in std_logic_vector(4 downto 0);
         sw : in std_logic_vector(15 downto 0);
         led : out std_logic_vector(15 downto 0);
         an : out std_logic_vector(7 downto 0);
         cat : out std_logic_vector(6 downto 0)
    );
end MIPS;

architecture MIPS of MIPS is
    component mpg is 
    port
    (
         clk : in std_logic;
         btn: in std_logic;
         enable: out std_logic
    );
    end component;

    component inst_fetch is
    port(
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        enable : in STD_LOGIC;
        branchAddress : in STD_LOGIC_VECTOR(31 downto 0);
        jumpAddress : in STD_LOGIC_VECTOR(31 downto 0);
        jump : in STD_LOGIC;
        PCsrc : in STD_LOGIC;
        instruction : out STD_LOGIC_VECTOR(31 downto 0);
        PC4 : out STD_LOGIC_VECTOR(31 downto 0)
    );
    end component;

    component op_fetch is
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
    end component;

    component execution_unit is
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
    end component;

    component DataMemory is
    port
    (
        clk: in std_logic;
        enable: in std_logic;
        mem_write: in std_logic;
        alu_res: in std_logic_vector(31 downto 0);
        rd2: in std_logic_vector(31 downto 0);
        mem_data: out std_logic_vector(31 downto 0);
        alu_res_out: out std_logic_vector(31 downto 0)
    );
    end component;

    component MainControlUnit is
    port
    (
        instruction: in std_logic_vector(5 downto 0);
        reg_dst: out std_logic;
        ext_op: out std_logic;
        alu_src: out std_logic;
        branch: out std_logic;
        jump: out std_logic;
        alu_op: out std_Logic_vector(2 downto 0);
        mem_write: out std_logic;
        mem_to_reg: out std_logic;
        reg_write: out std_logic
    );
    end component;

    component ssd is 
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
    end component;

    signal wb_mem_data, read_data, jump_address, mem_branch_address, branch_address, instruction, of_instruction, wd, rd1, rd2, ex_rd1, ex_rd2, mem_rd2, rd_1, rd_2, pc_4, of_pc4, ext_imm, ex_ext_imm, mem_alu_res,ALU_res, alu_res_out, wb_alu_res_out, result: std_logic_vector(31 downto 0) := x"00000000";  
    signal instr, of_instr: std_logic_vector(25 downto 0);
    signal jump, pcsrc, regWrite, mem_reg_write, ex_reg_write, ex_reg_dst, regDst, extOp, ex_alu_src, ALU_src, mem_zero, zero, wb_mem_to_reg, wb_reg_write : std_logic; 
    signal funct, ex_funct, func, mc_in: std_logic_vector(5 downto 0);
    signal sa, ex_sa, of_instr1, of_instr2, ex_instr1, ex_instr2, wb_out_instr, out_instr, mem_out_instr: std_logic_vector(4 downto 0);
    signal alu_op, ex_alu_op: std_logic_vector(2 downto 0);
    signal mem_to_reg, ex_mem_to_reg, mem_mem_to_reg, mem_write, ex_mem_write, mem_mem_write: std_logic;
    signal outMuxDataMemory: std_logic_vector(31 downto 0);
    signal branch, ex_branch, mem_branch, enable, reset: std_logic := '0';
    signal switch: std_logic_vector(2 downto 0);

begin
    jump_address <= of_pc4 (31 downto 28) & of_instr(25 downto 0) & "00";
    instr <= instruction(25 downto 0);
    outMuxDataMemory <= wb_alu_res_out when wb_mem_to_reg = '0' else wb_mem_data;
    wd <= outMuxDataMemory;
    pcsrc <= mem_branch and mem_zero;

    MPG_component: mpg port map
    (
        clk => clk,
        btn => btn(0),
        enable => enable
    );

    MPG_component2: mpg port map --not necessary
    (   
        clk => clk,
        btn => btn(1),
        enable => reset
    );

    INS_FETCH: inst_fetch port map
    (
        clk => clk,
        reset => btn(1),
        enable => enable,
        BranchAddress => mem_branch_address,
        jumpAddress => jump_address,
        jump => jump,
        pcsrc => pcsrc,
        instruction => instruction,
        pc4 => pc_4
    );

    -- IF_OF register
    process(clk) is
    begin
        if(rising_edge(clk)) then
            if enable = '1' then
                of_instruction <= instruction;
                of_pc4 <= pc_4;
            end if;
        end if;
    end process;

    of_instr <= of_instruction (25 downto 0);
    mc_in <= of_instruction (31 downto 26);

    OP_FETCHING: op_fetch port map
    (
        clk => clk,
        enable => enable,
        regWrite => wb_reg_write,
        instr => of_instr,
        wa => wb_out_instr, --input here
        extOp => extOp,
        wd => wd,
        ext_Imm => ext_Imm, 
        funct => funct,
        sa => sa, 
        rd1 => rd1,
        rd2 => rd2
    ); 

    of_instr1 <= of_instr(20 downto 16);
    of_instr2 <= of_instr(15 downto 11);

    -- OF_EX register
    process(clk) is
    begin 
        if(rising_edge(clk)) then
            if enable = '1' then
                --WB GROUP
                ex_mem_to_reg <= mem_to_reg;
                ex_reg_write <= regWrite;
                --M GROUP 
                ex_mem_write <= mem_write;
                ex_branch <= branch;
                --EX GROUP
                ex_alu_op <= alu_op;
                ex_alu_src <= alu_src;
                ex_reg_dst <= regDst;
                --Register part
                ex_rd1 <= rd1;
                ex_rd2 <= rd2;
                ex_funct <= funct;
                ex_sa <= sa;
                ex_instr1 <= of_instr1; 
                ex_instr2 <= of_instr2;
            end if;
        end if;
    end process;

    EX_UNIT: execution_unit port map
    (
        pc_4 => pc_4,
        rd_1 => ex_rd1,
        ALU_src => ALU_src,
        rd_2 => ex_rd2,
        ext_imm => ex_ext_imm,
        sa => ex_sa, 
        func => ex_funct, --input
        alu_op => ex_alu_op,
        regDst => ex_reg_dst,
        instr1 => ex_instr1,
        instr2 => ex_instr2,
        zero => zero, 
        ALU_res => ALU_res,
        Branch_Address => Branch_Address,
        out_instr => out_instr
    );

    -- EX_MEM register
    process(clk) is
    begin
        if(rising_edge(clk)) then 
            if enable = '1' then
                --WB GROUP
                mem_mem_to_reg <= ex_mem_to_reg;
                mem_reg_write <= ex_reg_write;
                --M GROUP
                mem_branch <= ex_branch;
                mem_mem_write <= ex_mem_write; 
                --register part
                mem_zero <= zero;
                mem_alu_res <= alu_res;
                mem_branch_address <= branch_address;
                mem_rd2 <= ex_rd2;
                mem_out_instr <= out_instr;
            end if;
        end if;
    end process;

    DATA_MEM: DataMemory port map
    (
        clk => clk,
        enable => enable,
        mem_write => mem_write, 
        alu_res => alu_res, 
        rd2 => rd2, 
        mem_data => read_data,
        alu_res_out => alu_res_out
    );

    -- MEM_WB register
    process(clk) is 
    begin
        if(rising_edge(clk)) then
            if enable = '1' then
                --WB GROUP
                wb_mem_to_reg <= mem_mem_to_reg;
                wb_reg_write <= mem_reg_write;
                --register part
                wb_mem_data <= read_data;   
                wb_alu_res_out <= alu_res_out;
                wb_out_instr <= mem_out_instr;
            end if;
        end if;
    end process;

    MAIN_UNIT: MainControlUnit port map
    (
        instruction => mc_in,
        reg_dst => regDst,
        ext_op => extOp,
        alu_src => ALU_src,
        branch => branch, 
        jump => jump,
        alu_op => alu_op, 
        mem_write => mem_write,
        mem_to_reg => mem_to_reg,
        reg_write => regWrite
    );

    switch <= sw(15 downto 13);

    process(switch)
    begin
        case switch is 
            when "000" => result <= instruction;
            when "001" => result <= pc_4;
            when "010" => result <= rd1; --check
            when "011" => result <= rd2; --check
            when "100" => result <= ext_imm;
            when "101" => result <= alu_res;
            when "110" => result <= read_data; --mem_data
            when "111" => result <= wd;
            when others => result <= x"00000000";
        end case;
    end process;

    SSD_MAPPING: ssd port map
    (
        clk => clk,
        digit0 => result(3 downto 0),
        digit1 => result(7 downto 4),
        digit2 => result(11 downto 8),
        digit3 => result(15 downto 12),
        digit4 => result(19 downto 16),
        digit5 => result(23 downto 20),
        digit6 => result(27 downto 24),
        digit7 => result(31 downto 28),
        cat => cat,
        an => an    
    );

    led <= result(15 downto 0);
end MIPS;

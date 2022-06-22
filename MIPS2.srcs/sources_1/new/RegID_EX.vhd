library ieee;
use ieee.STD_LOGIC_1164.all;
use ieee.STD_LOGIC_unsigned.all;

entity RegID_EX is
    Port ( MemtoReg_in : in STD_LOGIC;
           RegWrite_in : in STD_LOGIC;
           MemWrite_in : in STD_LOGIC;
           Branch_in : in STD_LOGIC;
           ALUop_in : in STD_LOGIC_VECTOR (2 downto 0);
           ALUsrc_in : in STD_LOGIC;
           RegDst_in : in STD_LOGIC;
           NextInstr_in : in STD_LOGIC_VECTOR (15 downto 0);
           RD1_in : in STD_LOGIC_VECTOR (15 downto 0);
           RD2_in : in STD_LOGIC_VECTOR (15 downto 0);
           ExtImm_in : in STD_LOGIC_VECTOR (15 downto 0);
           Instr_in : in STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           MemtoReg_out : out STD_LOGIC;
           RegWrite_out : out STD_LOGIC;
           MemWrite_out : out STD_LOGIC;
           Branch_out : out STD_LOGIC;
           ALUop_out : out STD_LOGIC_VECTOR (2 downto 0);
           ALUsrc_out : out STD_LOGIC;
           RegDst_out : out STD_LOGIC;
           NextInstr_out : out STD_LOGIC_VECTOR (15 downto 0);
           RD1_out : out STD_LOGIC_VECTOR (15 downto 0);
           RD2_out : out STD_LOGIC_VECTOR (15 downto 0);
           ExtImm_out : out STD_LOGIC_VECTOR (15 downto 0);
           Instr_out : out STD_LOGIC_VECTOR (15 downto 0));
end RegID_EX;

architecture Behavioral of RegID_EX is

begin
    process(clk)
    begin
        if rising_edge(clk) then
            MemtoReg_out <= MemtoReg_in;
            RegWrite_out <= RegWrite_in;
            MemWrite_out <= MemWrite_in;
            Branch_out <= Branch_in;
            ALUop_out <= ALUop_in;
            ALUsrc_out <= ALUsrc_in;
            RegDst_out <= RegDst_in;
            NextInstr_out <= NextInstr_in;
            RD1_out <= RD1_in;
            RD2_out <= RD2_in;
            ExtImm_out <= ExtImm_in;
            Instr_out <= Instr_in;
        end if;
    end process;

end Behavioral;

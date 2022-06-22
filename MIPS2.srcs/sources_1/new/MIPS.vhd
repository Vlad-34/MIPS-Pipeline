library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MIPS is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC;
           sw : in STD_LOGIC_VECTOR(2 downto 0);
           cat : out STD_LOGIC_VECTOR(6 downto 0);
           an : out STD_LOGIC_VECTOR(3 downto 0);
           led : out STD_LOGIC_VECTOR(15 downto 0));
end MIPS;

architecture Behavioral of MIPS is

component MPG is -- button
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC;
           enable : out STD_LOGIC);
end component;

component SSD is -- display
	port( input : in STD_LOGIC_VECTOR(15 downto 0);
		  clk : in STD_LOGIC;
		  cat : out STD_LOGIC_VECTOR(6 downto 0);
	  	  an : out STD_LOGIC_VECTOR(3 downto 0));
end component;

component IFetch is -- Instruction Fetch
port ( clk : in STD_LOGIC;
       btn : in STD_LOGIC;
       JumpAddress : in STD_LOGIC_VECTOR(15 downto 0);
       BranchAddress : in STD_LOGIC_VECTOR(15 downto 0);
       Jump : in STD_LOGIC;
       PCsrc : in STD_LOGIC;
       Instr : out STD_LOGIC_VECTOR(15 downto 0);
       NextInstr : out STD_LOGIC_VECTOR(15 downto 0));
end component;

component ID is -- Instruction Decode
    Port ( RegWrite : in STD_LOGIC;
           Instr : in STD_LOGIC_VECTOR (15 downto 0);
           ExtOp : in STD_LOGIC;
           WA : in STD_LOGIC_VECTOR(2 downto 0);
           WD : in STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           RD1 : out STD_LOGIC_VECTOR (15 downto 0);
           RD2 : out STD_LOGIC_VECTOR (15 downto 0);
           ExtImm : out STD_LOGIC_VECTOR (15 downto 0)
           -- Func : out STD_LOGIC_VECTOR (2 downto 0);
           -- Sa : out STD_LOGIC);
           );
end component;

component ALU is -- Execute
    Port ( A : in STD_LOGIC_VECTOR (15 downto 0);
           RD2 : in STD_LOGIC_VECTOR (15 downto 0);
           ExtImm : in STD_LOGIC_VECTOR(15 downto 0);
           ALUop : in STD_LOGIC_VECTOR(2 downto 0);
           ALUsrc : in STD_LOGIC;
           C : out STD_LOGIC_VECTOR (15 downto 0);
           Zero : out STD_LOGIC;
           GrZero : out STD_LOGIC);
end component;

component RAM is -- Memory
    Port ( clk : in STD_LOGIC;
           we : in STD_LOGIC;
           addr : in STD_LOGIC_VECTOR(15 downto 0);
           di : in STD_LOGIC_VECTOR(15 downto 0);
           do : out STD_LOGIC_VECTOR(15 downto 0));
end component;

component MainControl is
    Port ( Instr : in STD_LOGIC_VECTOR (15 downto 0);
           Zero : in STD_LOGIC; -- flag for beq operation
           GrZero : in STD_LOGIC; -- flag for bgtz operation
           RegDst : out STD_LOGIC;
           ExtOp : out STD_LOGIC;
           ALUsrc : out STD_LOGIC;
           Branch : out STD_LOGIC;
           Jump : out STD_LOGIC;
           ALUop : out STD_LOGIC_VECTOR (2 downto 0);
           MemWrite : out STD_LOGIC;
           MemtoReg : out STD_LOGIC;
           RegWrite : out STD_LOGIC);
end component;

-- Registers
component RegIF_ID is
    Port ( Instr_in : in STD_LOGIC_VECTOR (15 downto 0);
           NextInstr_in : in STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           Instr_out : out STD_LOGIC_VECTOR (15 downto 0);
           NextInstr_out : out STD_LOGIC_VECTOR (15 downto 0));
end component;

component RegID_EX is
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
end component;

component RegEX_MEM is
    Port ( MemtoReg_in : in STD_LOGIC;
           RegWrite_in : in STD_LOGIC;
           MemWrite_in : in STD_LOGIC;
           Branch_in : in STD_LOGIC;
           BranchAddress_in : in STD_LOGIC_VECTOR (15 downto 0);
           Zero_in : in STD_LOGIC;
           grZero_in : in STD_LOGIC;
           C_in : in STD_LOGIC_VECTOR (15 downto 0);
           RD2_in : in STD_LOGIC_VECTOR (15 downto 0);
           WriteAddress_in : in STD_LOGIC_VECTOR (2 downto 0);
           clk : in STD_LOGIC;
           MemtoReg_out : out STD_LOGIC;
           RegWrite_out : out STD_LOGIC;
           MemWrite_out : out STD_LOGIC;
           Branch_out : out STD_LOGIC;
           BranchAddress_out : out STD_LOGIC_VECTOR (15 downto 0);
           Zero_out : out STD_LOGIC;
           grZero_out : out STD_LOGIC;
           C_out : out STD_LOGIC_VECTOR (15 downto 0);
           RD2_out : out STD_LOGIC_VECTOR (15 downto 0);
           WriteAddress_out : out STD_LOGIC_VECTOR (2 downto 0));
end component;

component RegMEM_WB is
    Port ( MemtoReg_in : in STD_LOGIC;
           RegWrite_in : in STD_LOGIC;
           do_in : in STD_LOGIC_VECTOR (15 downto 0);
           C_in : in STD_LOGIC_VECTOR (15 downto 0);
           WriteAddress_in : in STD_LOGIC_VECTOR (2 downto 0);
           clk : in STD_LOGIC;
           MemtoReg_out : out STD_LOGIC;
           RegWrite_out : out STD_LOGIC;
           do_out : out STD_LOGIC_VECTOR (15 downto 0);
           C_out : out STD_LOGIC_VECTOR (15 downto 0);
           WriteAddress_out : out STD_LOGIC_VECTOR (2 downto 0));
end component;

signal enable : STD_LOGIC; -- button

signal RegDst_signal : STD_LOGIC; -- Main Controller
signal ExtOp_signal : STD_LOGIC;
signal ALUsrc_signal : STD_LOGIC;
signal Branch_signal : STD_LOGIC;
signal PCSrc_signal : STD_LOGIC;
signal Jump_signal : STD_LOGIC;
signal ALUop_signal : STD_LOGIC_VECTOR (2 downto 0);
signal MemWrite_signal : STD_LOGIC;
signal MemtoReg_signal : STD_LOGIC;
signal RegWrite_signal : STD_LOGIC;

signal Instr_signal : STD_LOGIC_VECTOR(15 downto 0); -- IF
signal NextInstr_signal : STD_LOGIC_VECTOR(15 downto 0);
signal JumpAddress_signal : STD_LOGIC_VECTOR(15 downto 0);
signal BranchAddress_signal : STD_LOGIC_VECTOR(15 downto 0);
signal ExtImm_signal : STD_LOGIC_VECTOR(15 downto 0);
signal WD_signal : STD_LOGIC_VECTOR(15 downto 0);

signal RD1_signal : STD_LOGIC_VECTOR (15 downto 0); -- ID
signal RD2_signal : STD_LOGIC_VECTOR (15 downto 0);

signal C_signal : STD_LOGIC_VECTOR(15 downto 0); -- EXE
signal Zero_signal : STD_LOGIC;
signal GrZero_signal : STD_LOGIC;

signal do_signal : STD_LOGIC_VECTOR(15 downto 0); -- MEM

signal input_signal : STD_LOGIC_VECTOR(15 downto 0); -- display

signal Instr_IF_ID_in : STD_LOGIC_VECTOR (15 downto 0); -- IF/ID Register
signal NextInstr_IF_ID_in : STD_LOGIC_VECTOR (15 downto 0);
signal Instr_IF_ID_out : STD_LOGIC_VECTOR (15 downto 0);
signal NextInstr_IF_ID_out : STD_LOGIC_VECTOR (15 downto 0);

signal MemtoReg_ID_EX_in : STD_LOGIC; -- ID/EX Register
signal RegWrite_ID_EX_in : STD_LOGIC;
signal MemWrite_ID_EX_in : STD_LOGIC;
signal Branch_ID_EX_in : STD_LOGIC;
signal ALUop_ID_EX_in : STD_LOGIC_VECTOR (2 downto 0);
signal ALUsrc_ID_EX_in : STD_LOGIC;
signal RegDst_ID_EX_in : STD_LOGIC;
signal NextInstr_ID_EX_in : STD_LOGIC_VECTOR (15 downto 0);
signal RD1_ID_EX_in : STD_LOGIC_VECTOR (15 downto 0);
signal RD2_ID_EX_in : STD_LOGIC_VECTOR (15 downto 0);
signal ExtImm_ID_EX_in : STD_LOGIC_VECTOR (15 downto 0);
signal Instr_ID_EX_in : STD_LOGIC_VECTOR (15 downto 0);
signal MemtoReg_ID_EX_out : STD_LOGIC;
signal RegWrite_ID_EX_out : STD_LOGIC;
signal MemWrite_ID_EX_out : STD_LOGIC;
signal Branch_ID_EX_out : STD_LOGIC;
signal ALUop_ID_EX_out : STD_LOGIC_VECTOR (2 downto 0);
signal ALUsrc_ID_EX_out : STD_LOGIC;
signal RegDst_ID_EX_out : STD_LOGIC;
signal NextInstr_ID_EX_out : STD_LOGIC_VECTOR (15 downto 0);
signal RD1_ID_EX_out : STD_LOGIC_VECTOR (15 downto 0);
signal RD2_ID_EX_out : STD_LOGIC_VECTOR (15 downto 0);
signal ExtImm_ID_EX_out : STD_LOGIC_VECTOR (15 downto 0);
signal Instr_ID_EX_out : STD_LOGIC_VECTOR (15 downto 0);

signal MemtoReg_EX_MEM_in : STD_LOGIC; -- EX/MEM Register
signal RegWrite_EX_MEM_in : STD_LOGIC;
signal MemWrite_EX_MEM_in : STD_LOGIC;
signal Branch_EX_MEM_in : STD_LOGIC;
signal BranchAddress_EX_MEM_in : STD_LOGIC_VECTOR (15 downto 0);
signal Zero_EX_MEM_in : STD_LOGIC;
signal grZero_EX_MEM_in : STD_LOGIC;
signal C_EX_MEM_in : STD_LOGIC_VECTOR (15 downto 0);
signal RD2_EX_MEM_in : STD_LOGIC_VECTOR (15 downto 0);
signal WriteAddress_EX_MEM_in : STD_LOGIC_VECTOR (2 downto 0);
signal MemtoReg_EX_MEM_out : STD_LOGIC;
signal RegWrite_EX_MEM_out : STD_LOGIC;
signal MemWrite_EX_MEM_out : STD_LOGIC;
signal Branch_EX_MEM_out : STD_LOGIC;
signal BranchAddress_EX_MEM_out : STD_LOGIC_VECTOR (15 downto 0);
signal Zero_EX_MEM_out : STD_LOGIC;
signal grZero_EX_MEM_out : STD_LOGIC;
signal C_EX_MEM_out : STD_LOGIC_VECTOR (15 downto 0);
signal RD2_EX_MEM_out : STD_LOGIC_VECTOR (15 downto 0);
signal WriteAddress_EX_MEM_out : STD_LOGIC_VECTOR (2 downto 0);

signal MemtoReg_MEM_WB_in : STD_LOGIC; -- MEM/WB Register
signal RegWrite_MEM_WB_in : STD_LOGIC;
signal do_MEM_WB_in : STD_LOGIC_VECTOR (15 downto 0);
signal C_MEM_WB_in : STD_LOGIC_VECTOR (15 downto 0);
signal WriteAddress_MEM_WB_in : STD_LOGIC_VECTOR (2 downto 0);
signal MemtoReg_MEM_WB_out : STD_LOGIC;
signal RegWrite_MEM_WB_out : STD_LOGIC;
signal do_MEM_WB_out : STD_LOGIC_VECTOR (15 downto 0);
signal C_MEM_WB_out : STD_LOGIC_VECTOR (15 downto 0);
signal WriteAddress_MEM_WB_out : STD_LOGIC_VECTOR (2 downto 0);

begin
button: MPG port map(clk => clk, btn => btn, enable => enable);
MainController: MainControl port map(Instr => Instr_IF_ID_out, Zero => Zero_EX_MEM_out, GrZero => grZero_EX_MEM_out, RegDst => RegWrite_ID_EX_in, ExtOp => ExtOp_signal, ALUsrc => ALUsrc_ID_EX_in, Branch => Branch_ID_EX_in, Jump => Jump_signal, ALUop => ALUop_ID_EX_in, MemWrite => MemWrite_ID_EX_in, MemtoReg => MemtoReg_ID_EX_in, RegWrite => RegWrite_ID_EX_in);

JumpAddress_signal <= "000" & Instr_IF_ID_in(12 downto 0);
BranchAddress_EX_MEM_in <= NextInstr_ID_EX_out + ExtImm_ID_EX_out;
PCSrc_signal <= (Branch_EX_MEM_out and Zero_EX_MEM_out) or (Branch_EX_MEM_out and grZero_EX_MEM_out);
InstructionFetch: IFetch port map(clk => clk, btn => enable, JumpAddress => JumpAddress_signal, BranchAddress => BranchAddress_EX_MEM_out, Jump => Jump_signal, PCSrc => PCSrc_signal, Instr => Instr_IF_ID_in, NextInstr => NextInstr_IF_ID_in);

RegisterIF_ID: RegIF_ID port map(Instr_in => Instr_IF_ID_in, NextInstr_in => NextInstr_IF_ID_in, clk => enable, Instr_out => Instr_IF_ID_out, NextInstr_out => NextInstr_IF_ID_out);

InstructionDecode: ID port map(RegWrite => RegWrite_MEM_WB_out, Instr => Instr_IF_ID_out, ExtOp => ExtOp_signal, WA => WriteAddress_MEM_WB_out, WD => WD_signal, clk => clk, RD1 => RD1_ID_EX_in, RD2 => RD2_ID_EX_in, ExtImm => ExtImm_ID_EX_in);

RegisterID_EX: RegID_EX port map(MemtoReg_in => MemtoReg_ID_EX_in, RegWrite_in => RegWrite_ID_EX_in, MemWrite_in => MemWrite_ID_EX_in, Branch_in => Branch_ID_EX_in, ALUop_in => ALUop_ID_EX_in, ALUsrc_in => ALUsrc_ID_EX_in, RegDst_in => RegDst_ID_EX_in, NextInstr_in => NextInstr_IF_ID_out, RD1_in => RD1_ID_EX_in, RD2_in => RD2_ID_EX_in, ExtImm_in => ExtImm_ID_EX_in, Instr_in => Instr_ID_EX_in, clk => enable, MemtoReg_out => MemtoReg_ID_EX_out, RegWrite_out => RegWrite_ID_EX_out, MemWrite_out => MemWrite_ID_EX_out, Branch_out => Branch_ID_EX_out, ALUop_out => ALUop_ID_EX_out, ALUsrc_out => ALUsrc_ID_EX_out, RegDst_out => RegDst_ID_EX_out, NextInstr_out => NextInstr_ID_EX_out, RD1_out => RD1_ID_EX_out, RD2_out => RD2_ID_EX_out, ExtImm_out => ExtImm_ID_EX_out, Instr_out => Instr_ID_EX_out);

Execute: ALU port map(ALUsrc => ALUsrc_ID_EX_out, A => RD1_ID_EX_out, RD2 => RD2_ID_EX_out, ExtImm => ExtImm_ID_EX_out, ALUop => ALUop_ID_EX_out, C => C_EX_MEM_in, Zero => Zero_EX_MEM_in, GrZero => grZero_EX_MEM_in);

RegisterEX_MEM: RegEX_MEM port map(MemtoReg_in => MemtoReg_EX_MEM_in, RegWrite_in => RegWrite_EX_MEM_in, MemWrite_in => MemWrite_EX_MEM_in, Branch_in => Branch_EX_MEM_in, BranchAddress_in => BranchAddress_EX_MEM_in, Zero_in => Zero_EX_MEM_in, grZero_in => grZero_EX_MEM_in, C_in => C_EX_MEM_in, RD2_in => RD2_EX_MEM_in, WriteAddress_in => WriteAddress_EX_MEM_in, clk => enable, MemtoReg_out => MemtoReg_EX_MEM_out, RegWrite_out => RegWrite_EX_MEM_out, MemWrite_out => MemWrite_EX_MEM_out, Branch_out => Branch_EX_MEM_out, BranchAddress_out => BranchAddress_EX_MEM_out, Zero_out => Zero_EX_MEM_out, grZero_out => grZero_EX_MEM_out, C_out => C_EX_MEM_out, RD2_out => RD2_EX_MEM_out, WriteAddress_out => WriteAddress_EX_MEM_out);

Memory: RAM port map(clk => clk, we => MemWrite_EX_MEM_out, addr => C_EX_MEM_out, di => RD2_EX_MEM_out, do => do_MEM_WB_in); -- good?

RegisterMEM_WB: RegMEM_WB port map(MemtoReg_in => MemtoReg_MEM_WB_in, RegWrite_in => RegWrite_MEM_WB_in, do_in => do_MEM_WB_in, C_in => C_MEM_WB_in, WriteAddress_in => WriteAddress_MEM_WB_in, clk => enable, MemtoReg_out => MemtoReg_MEM_WB_out, RegWrite_out => RegWrite_MEM_WB_out, do_out => do_MEM_WB_out, C_out => C_MEM_WB_out, WriteAddress_out => WriteAddress_MEM_WB_out);

process(RegDst_ID_EX_out)
begin
    case RegDst_ID_EX_out is
        when '1' => WriteAddress_EX_MEM_in <= Instr_ID_EX_out(6 downto 4);
        when '0' => WriteAddress_EX_MEM_in <= Instr_ID_EX_out(9 downto 7);
    end case;
end process;
process(MemtoReg_MEM_WB_out) -- WB
begin
    if(MemtoReg_MEM_WB_out = '0') then
        WD_signal <= C_MEM_WB_out;
    else
        WD_signal <= do_MEM_WB_out;
    end if;
end process;

process(sw)
begin
    case(sw) is
        when "000" => input_signal <= Instr_IF_ID_in;
        when "001" => input_signal <= NextInstr_IF_ID_in;
        when "010" => input_signal <= RD1_ID_EX_in;
        when "011" => input_signal <= RD2_ID_EX_in;
        when "100" => input_signal <= ExtImm_ID_EX_in;
        when "101" => input_signal <= C_EX_MEM_in;
        when "110" => input_signal <= do_MEM_WB_in;
        when "111" => input_signal <= WD_signal;
    end case;
end process;

Display: SSD port map(input => input_signal, clk => clk, cat => cat, an => an);

led(0) <= RegDst_ID_EX_out;
led(1) <= ExtOp_signal;
led(2) <= Branch_EX_MEM_out;
led(3) <= Jump_signal;
led(6 downto 4) <= ALUop_ID_EX_in;
led(7) <= MemWrite_ID_EX_in;
led(8) <= MemtoReg_ID_EX_in;
led(9) <= Zero_EX_MEM_out;
led(10) <= grZero_EX_MEM_out; 
led(11) <= ALUsrc_ID_EX_in;
led(12) <= RegWrite_ID_EX_in;

end Behavioral;

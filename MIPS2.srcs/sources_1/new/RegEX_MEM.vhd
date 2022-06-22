library ieee;
use ieee.STD_LOGIC_1164.all;
use ieee.STD_LOGIC_unsigned.all;

entity RegEX_MEM is
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
end RegEX_MEM;

architecture Behavioral of RegEX_MEM is

begin
    process(clk)
    begin
        if rising_edge(clk) then
            MemtoReg_out <= MemtoReg_in;
            RegWrite_out <= RegWrite_in;
            MemWrite_out <= MemWrite_in;
            Branch_out <= Branch_in;
            BranchAddress_out <= BranchAddress_in;
            Zero_out <= Zero_in;
            grZero_out <= grZero_in;
            C_out <= C_in;
            RD2_out <= RD2_in;
            WriteAddress_out <= WriteAddress_in;
        end if;
    end process;

end Behavioral;

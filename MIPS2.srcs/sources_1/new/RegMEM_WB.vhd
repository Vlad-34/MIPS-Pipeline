library ieee;
use ieee.STD_LOGIC_1164.all;
use ieee.STD_LOGIC_unsigned.all;

entity RegMEM_WB is
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
end RegMEM_WB;

architecture Behavioral of RegMEM_WB is

begin
    process(clk)
    begin
        if rising_edge(clk) then
            MemtoReg_out <= MemtoReg_in;
            RegWrite_out <= RegWrite_in;
            do_out <= do_in;
            C_out <= C_in;
            WriteAddress_out <= WriteAddress_in;
        end if;
    end process;

end Behavioral;

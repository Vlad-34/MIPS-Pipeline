library ieee;
use ieee.STD_LOGIC_1164.all;
use ieee.STD_LOGIC_unsigned.all;

entity RegIF_ID is
    Port ( Instr_in : in STD_LOGIC_VECTOR (15 downto 0);
           NextInstr_in : in STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           Instr_out : out STD_LOGIC_VECTOR (15 downto 0);
           NextInstr_out : out STD_LOGIC_VECTOR (15 downto 0));
end RegIF_ID;

architecture Behavioral of RegIF_ID is
begin
    process(clk)
    begin
        if rising_edge(clk) then
            Instr_out <= Instr_in;
            NextInstr_out <= NextInstr_in;
        end if;
    end process;
    
end Behavioral;

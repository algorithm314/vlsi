library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity full_adder_bhv_seq is
    Port ( A : in STD_LOGIC;
           B : in STD_LOGIC;
           Cin : in STD_LOGIC;
           clk : in STD_LOGIC;
           S : out STD_LOGIC;
           Cout : out STD_LOGIC);
end full_adder_bhv_seq;

architecture Behavioral of full_adder_bhv_seq is
signal tmp : std_logic_vector(1 downto 0);
begin
    
    process(clk)
    begin
        if (rising_edge(clk)) then
            tmp <= ('0'& A) + ('0'& B) +('0'& Cin);
        end if;
    end process;
    S <= tmp(0);
    Cout <= tmp(1);
end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity bcd_FA_tb is
end bcd_FA_tb;

architecture Behavioral of bcd_FA_tb is
-- inputs 
    signal A,B : std_logic_vector(3 downto 0);
    signal Cin : std_logic;
-- outputs
    signal S : std_logic_vector(3 downto 0);
    signal Cout : std_logic;
begin
    UUT: entity work.BCD_comb port map (A=>A, B=>B, Cin=>Cin, S=>S, Cout=>Cout);
    process is
    begin
    for Cval in std_logic range '0' to '1' loop
        for Aval in 0 to 9 loop
            for Bval in 0 to 9 loop
              A <= std_logic_vector(to_unsigned(Aval,4));
              B <= std_logic_vector(to_unsigned(Bval,4));
              Cin <= Cval;
              wait for 1 ns;
            end loop;
        end loop;
	end loop;
	wait;
    end process; 
end Behavioral;

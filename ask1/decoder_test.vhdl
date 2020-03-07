library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use ieee.std_logic_arith.all;
--use IEEE.std_logic_unsigned.all;


entity testbench is
end testbench;

architecture tb of testbench is
    signal sel : std_logic_vector(2 downto 0);  -- inputs 
    signal o : std_logic_vector(7 downto 0);  -- outputs
begin
    UUT : entity work.decoder8 port map (sel => sel, o => o);
    process is
    begin
    sel <= "000";
    for i in 0 to 7 loop
		sel <= std_logic_vector(to_unsigned(i,3));
		wait for 10 ns;
		--assert o = std_logic_vector(shift_left(unsigned("00000001"),i)); 
	end loop;
	wait;
    end process;     
end tb ;

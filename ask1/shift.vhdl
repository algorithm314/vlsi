library IEEE;
use IEEE.std_logic_1164.all;
entity rshift_reg3 is
	port (
	clk,rst,si,en,pl,direction: in std_logic;
	din: in std_logic_vector(3 downto 0);
	so: out std_logic);
end rshift_reg3;

architecture rtl of rshift_reg3 is
	signal dff: std_logic_vector(3 downto 0);
begin
	edge: process (clk,rst)
	begin
		if rst='0' then
			dff<=(others=>'0');
		elsif clk'event and clk='1' then
			if pl='1' then
				dff<=din;
			elsif en='1' then
				if direction='0' then
					dff <= si & dff(3 downto 1);
				else
					dff <= dff(2 downto 0) & si;
				end if;
			end if;
		end if;
	end process;

	with direction select so <= 
		dff(0) when '0',
		dff(3) when '1',
		'X' when others;
end rtl;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testbench_shift is
end testbench_shift;

architecture tb of testbench_shift is
	signal clk,rst,si,en,pl,direction,so: std_logic;
	signal din: std_logic_vector(3 downto 0);
	constant clock_period: time := 10 ns;
	constant clock_num: integer := 512;
begin
	mpampis: entity work.rshift_reg3  port map (clk => clk,rst => rst,si =>si,
	en=>en,pl => pl,direction => direction,so=>so,din=>din);

	process is
	begin
	en <= '1';
	rst <= '0';
	si <= '0';
	direction <= '0';
	pl <= '0';
	for i0 in 0 to 1 loop
		for i1 in 0 to 1 loop
			for i2 in 0 to 1 loop
				for i3 in 0 to 1 loop
					for i4 in 0 to 15 loop
						din <= std_logic_vector(to_unsigned(i4,4));
						wait for clock_period;
					end loop;
					pl <= not pl;
				end loop;
				direction <= not direction;
			end loop;
			si <= not si;
		end loop;
		rst <= not rst;
	end loop;
	wait;
	end process;

	clocking: process
	begin
		for i in 0 to clock_num loop
			clk <= '1', '0' after clock_period / 2;
			wait for clock_period;
		end loop;
	wait;
	end process;
end tb;

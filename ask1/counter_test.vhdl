library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testbench_counter is
end testbench_counter;

architecture tb of testbench_counter is
	signal clk,resetn,count_en,direction,cout: std_logic;
	signal limit: std_logic_vector(2 downto 0);
	signal sum: std_logic_vector(2 downto 0);
	constant clock_period: time := 10 ns;
	constant clock_num: integer := 2048;
begin
	UUT: entity work.count3  port map (clk => clk,resetn => resetn,count_en=>count_en,
	direction=>direction,cout => cout,limit => limit, sum => sum);

	process is
	begin
	resetn <= '0';
	count_en <= '0';
	direction <= '0';
	for i0 in 0 to 1 loop
		for i1 in 0 to 1 loop
			for i2 in 0 to 1 loop
					for i3 in 0 to 7 loop
						limit <= std_logic_vector(to_unsigned(i3,3));
						for i4 in 0 to 10 loop
							wait for clock_period;
						end loop;
					end loop;
				direction <= not direction;
			end loop;
			count_en <= not count_en;
		end loop;
		resetn <= not resetn;
	end loop;
	wait;
	end process;

	clocking: process
	begin
		for i in 0 to clock_num loop
			clk <= '0', '1' after clock_period / 2;
			wait for clock_period;
		end loop;
	wait;
	end process;
end tb;

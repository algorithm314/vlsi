-- ghdl -c mac.vhdl ram_example.vhd rom_example.vhd -r FIR_tb --fst=/tmp/out.fst && gtkwave --rcvar 'do_initial_zoom_fit yes' /tmp/out.fst
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;-- this is the only standard. std_logic_unsigned is not


entity MAC is
	generic(
		N: positive := 8;
		L: positive := 20
	);
	port (
		b_in: in unsigned (N-1 downto 0);
		c_in: in unsigned (N-1 downto 0);
		a_out: out unsigned (L-1 downto 0);
		mac_init: in std_logic;
		clock: in std_logic;
		reset: in std_logic
	);
end MAC;

architecture MAC_impl of MAC is
	signal a: unsigned (L-1 downto 0);
begin
	process (clock,reset)
		variable tmp1: unsigned(L-1 downto 0);
		variable tmp2: unsigned(L-1 downto 0);
	begin
		if reset = '1' then
			a_out <= (others => '0');
			a <= (others => '0');
		elsif rising_edge(clock) then
			if mac_init = '1' then
				tmp1 := (others => '0');
			else
				tmp1 := a;
			end if;
			tmp2 := tmp1 + b_in*c_in;
			a <= tmp2; -- avoid tristate logic (inout)
			a_out <= tmp2;
		end if;
	end process;
end MAC_impl;

library IEEE;
use ieee.std_logic_1164.all;

entity delay is
generic
	(
		stages : positive := 4
	);
	port (
		input: in std_logic;
		clock: in std_logic;
		reset: in std_logic;
		output: out std_logic
	);
end delay;

architecture D of delay is
	signal ff: std_logic_vector(stages-1 downto 0);
begin
	output <= ff(0);
	process(clock, reset)
	begin
		if reset = '1' then
			ff <= (others => '0');
		elsif rising_edge(clock) then
			ff(stages-1) <= input;
			for i in 0 to stages-2 loop
				ff(i) <= ff(i+1);
			end loop;
		end if;
	end process;
end D;

library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;-- this is the only standard
use std.textio.all;

entity FIR is
	generic(
		-- M: positive := 8;
		N: positive := 8;
		L: positive := 20
	);
	port(
		x: in unsigned(N-1 downto 0);
		y: out unsigned(L-1 downto 0);
		clock: in std_logic;
		reset: in std_logic;
		valid_in: in std_logic;
		valid_out: out std_logic
	);
end FIR;

architecture FIR_impl of FIR is
	signal stage,addr,ram_addr,rom_addr: unsigned(2 downto 0); -- ???
	signal b_mac,c_mac,coeff,ram_di,ram_do: unsigned (N-1 downto 0);
	signal mac_init,ram_en,ram_we,valid_out_delay,mac_init_delay: std_logic;
begin

	mac_unit:entity work.MAC port map(b_in => b_mac,c_in => c_mac,a_out=>y,mac_init => mac_init,clock => clock,reset => reset);

	rom_unit:entity work.mlab_rom port map(clk => clock,addr => rom_addr,rom_out => c_mac,en => '1');

	ram_unit:entity work.mlab_ram port map(clk => clock,addr => ram_addr,we => ram_we,en => '1',--ram_en;
	di => ram_di,do =>  b_mac);

	kath: entity work.delay generic map(9) port map(input => valid_out_delay,output => valid_out,clock => clock,reset => reset);

	process (clock,reset)
	begin
		if reset = '1' then
			stage <= "111";
			--valid_out <= '0';
			valid_out_delay <= '0';
			mac_init_delay <= '0';
		elsif rising_edge(clock) then
			-- first 2 cycles are ram[0],rom[1]; ram[0],rom[0]
			-- because ram has 1 cycle update latency
			--valid_out <= valid_out_delay;
			mac_init <= mac_init_delay;
			if stage = 7 then
				if valid_in = '1' then
					ram_addr <= to_unsigned(0,3);
					rom_addr <= to_unsigned(1,3);
					ram_di <= x;
					ram_we <= '1';
					stage <= "000";
					mac_init_delay <= '1';
					valid_out_delay <= '1';
				else
					-- valid_out_delay <= '0';
				end if;
			elsif stage = 0 then
				ram_we <= '0';
				ram_addr <= to_unsigned(0,3);
				rom_addr <= to_unsigned(0,3);
				stage <= stage + 1;
				mac_init_delay <= '0';
				valid_out_delay <= '0';
			elsif stage >= 1 then
				rom_addr <= stage + 1;
				ram_addr <= stage + 1;
				stage <= stage + 1;
			end if;
		end if;
	end process;
end FIR_impl;

library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;-- this is the only standard

entity FIR_tb is
generic(
		-- M: positive := 8;
		N: positive := 8;
		L: positive := 20;
		inputs_num: positive := 9
	);
end FIR_tb;

architecture test_FIR1 of FIR_tb is
	signal x: unsigned(N-1 downto 0);
	signal y: unsigned(L-1 downto 0);
	signal clock: std_logic;
	signal reset: std_logic;
	signal valid_in: std_logic;
	signal valid_out: std_logic;
	constant clock_period: time := 10 ns;
	constant clock_num: integer := 256;
	type inputs_array is array(inputs_num-1 downto 0) of integer;
	signal inputs: inputs_array := (255,255,255,255,255,255,255,255,255);
begin
	unit_to_test:entity work.FIR port map (x => x,y => y, clock => clock, reset => reset, valid_in => valid_in, valid_out => valid_out);
	process
	begin
		reset <= '1';
		wait for clock_period;
		reset <= '0';

		unit:for i in 0 to inputs_num-1 loop
			valid_in <= '1';
			x <= to_unsigned(inputs(i),8);
			wait for clock_period;
			valid_in <= '0';
			wait for clock_period;
			wait for clock_period;
			wait for clock_period;
			wait for clock_period;
			wait for clock_period;
			wait for clock_period;
			wait for clock_period;
		end loop;

		wait;
	end process;
	clocking: process
	begin
		for i in 0 to clock_num loop
			clock <= '1', '0' after clock_period / 2;
			wait for clock_period;
		end loop;
	wait;
	end process;
end test_FIR1;

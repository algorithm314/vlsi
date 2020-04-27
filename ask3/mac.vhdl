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
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;-- this is the only standard

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
	signal mac_init,ram_en,ram_we: std_logic;
begin

	mac_unit:entity work.MAC port map(b_in => b_mac,c_in => c_mac,a_out=>y,mac_init => mac_init,clock => clock,reset => reset);

	rom_unit:entity work.mlab_rom port map(clk => clock,addr => rom_addr,rom_out => c_mac,en => '1');

	ram_unit:entity work.mlab_ram port map(clk => clock,addr => ram_addr,we => ram_we,en => '1',--ram_en;
	di => ram_di,do =>  b_mac);

	process (clock,reset)
	begin
		if reset = '1' then
			y <= (others => '0');
			stage <= (others => '0');
		elsif rising_edge(clock) then
			-- in next cycle result will be valid
			if stage = "110" then
				valid_out <= '1';
			end if;
			-- first 2 cycles are ram[0],rom[1]; ram[0],rom[0]
			-- because ram has 1 cycle update latency
			if valid_in = '1' and stage = "111" then
				ram_addr <= to_unsigned(0,3);
				rom_addr <= to_unsigned(1,3);
				stage <= (others => '0');
				mac_init <= '1';
				valid_out <= '0';
			elsif stage = "000" then
				ram_addr <= to_unsigned(0,3);
				rom_addr <= to_unsigned(0,3);
				mac_init <= '0';
			elsif stage >= 2 then
				rom_addr <= stage;
				ram_addr <= stage;
			end if;
		end if;
	end process;
end FIR_impl;

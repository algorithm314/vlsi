library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mlab_ram is
	generic (
			data_width : integer := 8  				--- width of data (bits)
		);
	port (clk  : in std_logic;
	      we   : in std_logic;						--- memory write enable
	      en   : in std_logic;				--- operation enable
	      addr : in unsigned(2 downto 0);			-- memory address
	      di   : in unsigned(data_width-1 downto 0);		-- input data
	      do   : out unsigned(data_width-1 downto 0));		-- output data
end mlab_ram;

architecture Behavioral of mlab_ram is
	type ram_type is array (7 downto 0) of unsigned (data_width-1 downto 0);
	signal RAM : ram_type := (others => (others => '0'));
begin

	process (clk)
	begin
		if rising_edge(clk) then
			if en = '1' then
				if we = '1' then				-- write operation
					RAM(0) <= di;
					for i in 0 to 6 loop
						RAM(i+1) <= RAM(i);
					end loop;
				end if;
				do <= RAM(to_integer(addr));
			end if;
		end if;
	end process;

end Behavioral;



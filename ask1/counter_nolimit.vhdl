library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity count3_nolimit is
	port(clk,
	resetn,
	count_en,direction: in std_logic;
	sum: out std_logic_vector(2 downto 0);
	cout: out std_logic);
end;

architecture rtl_nolimit of count3_nolimit is
	signal count : std_logic_vector(2 downto 0);
begin
	process(clk, resetn)
	begin
		if resetn='0' then
			count <= (others=>'0');
		elsif rising_edge(clk) then
			if count_en = '1' then
				case direction is
					when '0' => 
						if count /= 7 then
							count <= count+1;
						else
							count<=(others=>'0');
						end if;
					when '1' => 
						if count = "000" then
							count <= "111";
						else
							count <= count-1;
						end if;
					when others => count <= (others => 'X');
				end case;
			end if;
		end if;
	end process;
	sum <= count;
	cout <= '1' when count=7 and count_en='1' else '0';
end;

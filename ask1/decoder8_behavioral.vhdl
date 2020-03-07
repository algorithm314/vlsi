library IEEE;
use IEEE.std_logic_1164.all;

entity decoder8 is
        port (
                sel : in  std_logic_vector(2 downto 0);
                o  : out std_logic_vector(7 downto 0)
        );
end decoder8;

architecture decoder8_behavioral of decoder8 is
begin
	process(sel)
	begin
		case sel is
			when "000" => o <= "00000001"; 
			when "001" => o <= "00000010";
			when "010" => o <= "00000100";
			when "011" => o <= "00001000";
			when "100" => o <= "00010000";
			when "101" => o <= "00100000";
			when "110" => o <= "01000000";
			when "111" => o <= "10000000";
			when others => o <= (others => 'X');
		end case;
	end process;
end decoder8_behavioral;

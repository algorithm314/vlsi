library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity parallel_fir_tb is
end parallel_fir_tb;

use work.parallel_fir_types.all;

architecture Behavioral of parallel_fir_tb is
-- inputs
    signal x : x_type;
    signal valid_in : std_logic;
    signal rst : std_logic;
    signal clk : std_logic;
-- outputs
    signal y : y_type;
    signal valid_out : std_logic;

    constant clock_period: time := 10 ns;
	constant clock_num: integer := 2048;
begin
    UUT: entity work.parallel_fir port map (x=>x, valid_in=>valid_in, rst=>rst, clk=>clk, y=>y, valid_out=>valid_out);

process begin
    rst <= '0';
    valid_in <= '1';
    x(1) <= "11111111";
    x(0) <= "11111111";
    wait for clock_period;
    x(1) <= "11111111";
    x(0) <= "11111111";
    wait for clock_period;
    x(1) <= "11111111";
    x(0) <= "11111111";
    wait for clock_period;
    x(1) <= "11111111";
    x(0) <= "11111111";
    wait for clock_period;
    x(1) <= "11111111";
    x(0) <= "11111111";
    wait for clock_period;
    x(1) <= "11111111";
    x(0) <= "11111111";
    wait for clock_period;
    x(1) <= "11111111";
    x(0) <= "11111111";
    wait for clock_period;
    x(1) <= "11111111";
    x(0) <= "11111111";

--    x(0) <= "00000001";
--    x(1) <= "00000001";
--    x(2) <= "00000000";
--    x(3) <= "00000000";
--    wait for clock_period;
--    x(0) <= "00000000";
--    x(1) <= "00000000";
--    x(2) <= "00000000";
--    x(3) <= "00000000";
--    wait for clock_period;

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
end Behavioral;
 

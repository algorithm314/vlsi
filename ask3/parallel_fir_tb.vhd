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
    -- trivial tests
    rst <= '0';
    valid_in <= '1';
    for rst_val in std_logic range '0' to '1' loop
        for valid_in_val in std_logic range '0' to '1' loop
            rst <= rst_val;
            valid_in <= valid_in_val;
            x(1) <= "00000001";
            x(0) <= "00000000";
            wait for clock_period;
            x(1) <= "00000000";
            x(0) <= "00000000";
            wait for clock_period;
            x(1) <= "00000000";
            x(0) <= "00000000";
            wait for clock_period;
            x(1) <= "00000000";
            x(0) <= "00000000";
            wait for clock_period;
            x(1) <= "00000000";
            x(0) <= "00000000";
            wait for 10*clock_period;
        end loop;
    end loop;
    -- expected 146.0,468.0,845.0,1240.0,1731.0,2452.0,3425.0,4455.0,4369.0,3868.0,4443.0,5344.0,5570.0,4606.0,3221.0,3530.0,2513,3071,2170,2141,2091,1393,1528,
--    rst <= '1';
--    wait for 1 ns;
--    rst <= '0';
--    valid_in <= '1';
--    x(1) <= to_unsigned(146, 8);
--    x(0) <= to_unsigned(176, 8);
--    wait for clock_period;
--    x(1) <= to_unsigned(55, 8);
--    x(0) <= to_unsigned(18, 8);
--    wait for clock_period;
--    x(1) <= to_unsigned(96, 8);
--    x(0) <= to_unsigned(230, 8);
--    wait for clock_period;
--    x(1) <= to_unsigned(252, 8);
--    x(0) <= to_unsigned(57, 8);
--    wait for clock_period;
--    x(1) <= to_unsigned(198, 8);
--    x(0) <= to_unsigned(1, 8);
--    wait for clock_period;
--    x(1) <= to_unsigned(163, 8);
--    x(0) <= to_unsigned(48, 8);
--    wait for clock_period;
--    x(1) <= to_unsigned(45, 8);
--    x(0) <= to_unsigned(112, 8);
--    wait for clock_period;
--    x(1) <= to_unsigned(7, 8);
--    x(0) <= to_unsigned(191, 8);
--    wait for clock_period;
--    x(1) <= to_unsigned(0, 8);
--    x(0) <= to_unsigned(0, 8);
--    wait for 20*clock_period;
    rst <= '1';
    wait for 1 ns;
    rst <= '0';
    valid_in <= '1';
    x(1) <= to_unsigned(40, 8);
    x(0) <= to_unsigned(248, 8);
    wait for clock_period;
    x(1) <= to_unsigned(245, 8);
    x(0) <= to_unsigned(124, 8);
    wait for clock_period;
    x(1) <= to_unsigned(204, 8);
    x(0) <= to_unsigned(36, 8);
    wait for clock_period;
    x(1) <= to_unsigned(107, 8);
    x(0) <= to_unsigned(234, 8);
    wait for clock_period;
    x(1) <= to_unsigned(202, 8);
    x(0) <= to_unsigned(245, 8);
    wait for clock_period;
    x(1) <= to_unsigned(0, 8);
    x(0) <= to_unsigned(0, 8);
    wait for clock_period;
    x(1) <= to_unsigned(0, 8);
    x(0) <= to_unsigned(0, 8);
    wait for clock_period;
    x(1) <= to_unsigned(0, 8);
    x(0) <= to_unsigned(0, 8);
    wait for clock_period;
    x(1) <= to_unsigned(0, 8);
    x(0) <= to_unsigned(0, 8);
    wait for 20*clock_period;
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
 

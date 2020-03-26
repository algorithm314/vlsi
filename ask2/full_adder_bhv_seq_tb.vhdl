library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity full_adder_bhv_seq_tb is
end full_adder_bhv_seq_tb;

architecture B of full_adder_bhv_seq_tb is
-- inputs 
    signal A ,B : std_logic;
    signal clk, Cin : std_logic;
-- outputs
    signal S : std_logic;
    signal Cout : std_logic;
    
    constant clock_period: time := 10 ns;
    constant clock_num: integer := 16;
begin
    UUT: entity work.full_adder_bhv_seq port map (A=>A, B=>B, Cin=>Cin, S=>S, Cout=>Cout, clk=>clk);

	process
	begin
		A <= '0';
		B <= '1';
		Cin <= '0';
		wait for clock_period;
		wait for clock_period;
		wait;
	end process;
clocking: process
	begin
		for i in 0 to clock_num loop
			clk <= '1';
			wait for clock_period/2;
			clk <= '0';
			wait for clock_period/2;
		end loop;
	wait;
	end process;
end B;

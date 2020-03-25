library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity rca_4bit_pipeline_tb is
end rca_4bit_pipeline_tb;

architecture Behavioral of rca_4bit_pipeline_tb is
-- inputs 
    signal A ,B : std_logic_vector(3 downto 0);
    signal clk, Cin, rst : std_logic;
-- outputs
    signal S : std_logic_vector(3 downto 0);
    signal Cout : std_logic;
    
    constant clock_period: time := 10 ns;
	constant clock_num: integer := 10;
begin
    UUT: entity work.rca_4bit_pipeline port map (A=>A, B=>B, Cin=>Cin, S=>S, Cout=>Cout, clk=>clk, rst=>rst);

    A <= "0001";
    B <= "0010";
    Cin <= '0';
    rst <= '0';

clocking: process
	begin
		for i in 0 to clock_num loop
			clk <= '1', '0' after clock_period / 2;
			wait for clock_period;
		end loop;
	wait;
	end process;
end Behavioral;

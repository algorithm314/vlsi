library IEEE;
LIBRARY xil_defaultlib;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
USE xil_defaultlib.types.all;

entity fir_filter_tb is
end fir_filter_tb;

architecture Behavioral of fir_filter_tb is

		signal	clk : std_logic:='1';
		signal  rst : std_logic;                                  
		signal 	data		 : std_logic_vector(data_width - 1  DOWNTO 0);    
        signal	result		 : UNSIGNED(18 DOWNTO 0);
			
		constant clock_period: time := 10 ns;
	    constant clock_num: integer := 2048;
begin
    UUT: entity work.fir_filter port map (clk=>clk, reset_n=>rst, data=>data, result=>result);

-- Process for generating the clock
    clk <= not clk after clock_period / 2;
    
process is
 begin
    rst <= '1';
    for i0 in 0 to 1 loop
        for i3 in 0 to 127 loop
            data <= std_logic_vector(to_unsigned((i3 mod 8),8));
            wait for clock_period;
            end loop;
         rst <= not rst;
        end loop;
    wait;
end process;



end Behavioral;

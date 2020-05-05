library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.math_real."ceil";
use IEEE.math_real."log2";
use work.types.all;

entity fir_filter_tb is
end fir_filter_tb;

architecture Behavioral of fir_filter_tb is

        signal  valid_in     : std_logic_vector(0 DOWNTO 0);
		signal	clk          : std_logic:='1';
		signal  rst          : std_logic;                                  
		signal 	data		 : std_logic_vector(data_width - 1  DOWNTO 0);
		signal  data_pipeline: data_array; 
        signal  result		 : STD_LOGIC_VECTOR((data_width + coeff_width + integer(ceil(log2(real(taps)))) - 1) DOWNTO 0);
        signal  ADD          : ADD_TYPE;
        signal  valid_out    : std_logic_vector(0 DOWNTO 0);
        signal  valid_reg    : valid_array;
        signal  count        : std_logic_vector(2 downto 0):="000";
			
		constant clock_period: time := 10 ns;
	    constant clock_num: integer := 2048;
begin
    UUT: entity work.fir_filter port map (valid_in=>valid_in, clk=>clk, reset_n=>rst, data=>data, data_pipeline=>data_pipeline,
     result=>result, ADD=>ADD, valid_out=>valid_out, valid_reg => valid_reg, count=>count);

-- Process for generating the clock
    clk <= not clk after clock_period / 2;
    
process is
 begin
    rst <= '0';
    valid_in <= "0";
    data <= std_logic_vector(to_unsigned(5,8));
            wait for clock_period;
            data <= std_logic_vector(to_unsigned(12,8));
            wait for clock_period;
            data <= std_logic_vector(to_unsigned(33,8));
            wait for clock_period;
            valid_in <= "1";
            data <= std_logic_vector(to_unsigned(28,8));
            wait for clock_period;
            data <= std_logic_vector(to_unsigned(6,8));
            wait for clock_period;
            data <= std_logic_vector(to_unsigned(2,8));
            wait for clock_period;
            data <= std_logic_vector(to_unsigned(17,8));
            wait for clock_period;
            data <= std_logic_vector(to_unsigned(9,8));
            wait for clock_period;
            data <= std_logic_vector(to_unsigned(1,8));
            wait for clock_period;
    for i0 in 0 to 1 loop
        for i3 in 0 to 5 loop
            data <= std_logic_vector(to_unsigned((i3 mod 8),8));
            wait for clock_period;
            end loop;
        valid_in <= "0";
        data <= std_logic_vector(to_unsigned(6,8));
        wait for clock_period;
        valid_in <= "1";
        data <= std_logic_vector(to_unsigned(7,8));
        wait for clock_period;
        for i4 in 8 to 63 loop
            data <= std_logic_vector(to_unsigned((i4 mod 8),8));
            wait for clock_period;
            end loop;
        -- rst <= not rst;
        end loop;
    wait;
end process;



end Behavioral;

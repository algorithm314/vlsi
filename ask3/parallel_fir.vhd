library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.math_real."ceil";
use IEEE.math_real."log2";

package parallel_fir_types is
    constant P : positive := 2;
    constant N : positive := 8;
    constant M : positive := 8;
    constant logM : integer := integer(ceil(log2(real(M))));
    constant Y_BITS : positive := M + N + logM;
    constant ZERO : unsigned(Y_BITS - 1  downto 0) := (others => '0');
   
    type x_type is array(P-1 downto 0) of unsigned(N-1 downto 0);
    type y_type is array(P-1 downto 0) of unsigned(Y_BITS-1 downto 0);
    type x_reg_type is array(M+P-1 downto 0) of unsigned(N-1 downto 0);
    type add_reg_type is array(M-1 downto 0) of unsigned(Y_BITS-1 downto 0);
    type twod_add_reg_type is array(P-1 downto 0) of add_reg_type;
    type product_reg_type is array(M-1 downto 0) of unsigned(N+N-1 downto 0);
    type twod_product_reg_type is array(P-1 downto 0) of product_reg_type;
    type coeff_type is array(M-1 downto 0) of unsigned(N-1 downto 0);
    
    constant COEFF : coeff_type := ("00001000", "00000111", "00000110", "00000101", "00000100", "00000011", "00000010", "00000001");
end package;

library IEEE;
use ieee.std_logic_1164.all;

entity delay is
generic
	(
		stages : positive := 4
	);
	port (
		input: in std_logic;
		clock: in std_logic;
		rst: in std_logic;
		output: out std_logic
	);
end delay;

architecture D of delay is
signal ff: std_logic_vector(stages-1 downto 0);
begin
	output <= ff(0);
	process(clock)
	begin
		if rising_edge(clock) then
			if rst = '1' then
				ff <= (others => '0');
			else
				ff(stages-1) <= input;
				for i in 0 to stages-2 loop
					ff(i) <= ff(i+1);
				end loop;
			end if;
		end if;
	end process;
end D;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

use work.parallel_fir_types.all;

entity parallel_fir is
    port (
        x : in x_type;
        valid_in : in std_logic;
        rst : in std_logic;
        clk : in std_logic;
        valid_out : out std_logic;
        y : out y_type
    );
end parallel_fir;

architecture Behavioral of parallel_fir is
    signal x_reg: x_reg_type := (others => (others => '0'));
    signal y_reg : y_type;
    signal valid_out_reg : std_logic_vector(M/P+2 downto 0) := (0 => '1', others => '0');
    signal add_reg : twod_add_reg_type := (others => (others => (others => '0')));
    signal product_reg, product_delayed : twod_product_reg_type := (others => (others => (others => '0')));
    
begin

valid_out <= valid_out_reg(M/P+2); -- todo

-- add delays (flip-flops) after the multipliers in order to synchronize the pipeline
l1: for K in 0 to P-1 generate
l2: for I in 0 to M-1 generate
l3: for J in 0 to N+N-1 generate
    l4: if I>0 generate
        p1: entity work.delay 
        generic map(I) port map(input => product_reg(K)(I)(J), output => product_delayed(K)(I)(J), clock => clk, rst => rst);
    end generate;
    l5: if I=0 generate
        product_delayed(K)(I)(J) <= product_reg(K)(I)(J);
    end generate;
end generate;
end generate;
end generate;
	
process (clk, rst, valid_in)
begin
    if rst = '1' then
        x_reg <= (others => (others => '0'));
        y <= (others => (others => '0'));
        valid_out_reg <= (0 => '1', others => '0');
    elsif clk'event and clk = '1' and valid_in = '1' then
            -- intermediate registers
            -- P parallel pipelines
            for K in P-1 downto 0 loop
                for I in M-1 downto 0 loop
                    if I = 0 then
                        add_reg(K)(I) <= zero + resize(product_delayed(K)(I), Y_BITS);
                    else 
                        add_reg(K)(I) <= resize(product_delayed(K)(I) + add_reg(K)(I-1), Y_BITS);
                    end if;
                    product_reg(K)(I) <= x_reg(I+K) * COEFF(I);
                end loop;               
            end loop;
            
           for J in M-1+P-1 downto 0 loop
                    if J < P then
                        x_reg(J) <= x(J);
                    else
                        x_reg(J) <= x_reg(J-P);
                    end if;
            end loop;
            
            for K in 0 to P-1 loop
                y(K) <= add_reg(K)(M-1);
            end loop;     

            -- valid out
            for i in 1 to M/P+2 loop
                valid_out_reg(i) <= valid_out_reg(i-1);
            end loop;
    end if;
end process;

end Behavioral;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package parallel_fir_types is
    constant P : integer := 2;
    constant N : integer := 8;
    constant M : integer := 8;
    type x_type is array(P-1 downto 0) of std_logic_vector(N-1 downto 0);
    type y_type is array(P-1 downto 0) of std_logic_vector(2*N-1+M downto 0);
end package;

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
    type coeff_type is array(M-1 downto 0) of std_logic_vector(N-1 downto 0);
    constant COEFF : coeff_type := ("00001000", "00000111", "00000110", "00000101", "00000100", "00000011", "00000010", "00000001");
    
    type x_reg_type is array(M-2 downto 0) of std_logic_vector(2*N-1+M downto 0);
    signal x_reg : x_reg_type;
begin

valid_out <= '0'; --todo

process (clk, rst)
variable res : integer;
begin
    if rst = '1' then
        x_reg <= (others => (others => '0'));
        y <= (others => (others => '0'));
    else
        -- Calculate outputs
        for I in 0 to P-1 loop
            res := 0;
            for J in 0 to I loop
                res := res + conv_integer(COEFF(J)*x(I));
            end loop;
            
            for K in 0 to M-I-2 loop
                res := res + conv_integer(COEFF(I+1 + K)*x_reg(K));
            end loop;
            y(I) <= std_logic_vector(to_unsigned(res, 2*N+M));
        end loop;
        
        if clk'event and clk = '1' then          
            -- Registers
            for I in 0 to P-1 loop
                x_reg(I) <= std_logic_vector(resize(unsigned(x(P-1-I)), 2*N+M));
            end loop;
            
            for I in P to M-P loop
                x_reg(I) <= x_reg(I-P);
            end loop;  
        end if;
    end if;
end process;


end Behavioral;

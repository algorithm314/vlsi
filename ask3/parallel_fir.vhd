library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.math_real."ceil";
use IEEE.math_real."log2";

package parallel_fir_types is
    constant P : integer := 2;
    constant N : integer := 8;
    constant M : integer := 8;
    constant Y_BITS : integer := M + N + integer(ceil(log2(real(M))));
    type x_type is array(P-1 downto 0) of std_logic_vector(N-1 downto 0);
    type y_type is array(P-1 downto 0) of std_logic_vector(Y_BITS-1 downto 0);
end package;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

use work.parallel_fir_types.all;

entity parallel_fir is
    port (
        -- x(0) is x(2k+1), x(1) is x(2k)
        x : in x_type;
        valid_in : in std_logic;
        rst : in std_logic;
        clk : in std_logic;
        -- becomes 1 when y is valid
        valid_out : out std_logic;
        y : out y_type
    );
end parallel_fir;

architecture Behavioral of parallel_fir is
    type coeff_type is array(M-1 downto 0) of std_logic_vector(N-1 downto 0);
    constant COEFF : coeff_type := ("00001000", "00000111", "00000110", "00000101", "00000100", "00000011", "00000010", "00000001");
    
    type x_reg_type is array(M-1+P-1 downto 0) of std_logic_vector(N-1 downto 0);
    signal x_reg : x_reg_type;
    
    signal y_reg : y_type;
    
    signal valid_out_reg : std_logic_vector(M/P+2 downto 0) := (0 => '1', others => '0');
begin

valid_out <= valid_out_reg(M/P+2); --todo


process (clk, rst, valid_in)
variable res : integer;
begin
    if rst = '1' then
        for I in 0 to M-1+P-1 loop
            x_reg(I) <= (others => '0');
        end loop;
        y <= (others => (others => '0'));
        valid_out_reg <= (0 => '1', others => '0');
    else
        for I in 0 to P-1 loop
            x_reg(I) <= x(I);
        end loop;
        if clk'event and clk = '1' and valid_in = '1' then
            -- calculate outputs
            for I in 0 to P-1 loop
                res := 0;
                for J in 0 to M-1 loop
                    res := res + conv_integer(COEFF(J)*x_reg(J+I));
                end loop;
                y(I) <= std_logic_vector(to_unsigned(res, Y_BITS));
            end loop;
            
            -- valid out
            for i in 1 to M/P+2 loop
                valid_out_reg(i) <= valid_out_reg(i-1);
            end loop;
            
            -- registers that store previous inputs
            for I in P to M-1+P-1 loop
                x_reg(I) <= x_reg(I-P);
            end loop;  
        end if;
    end if;
    

end process;


end Behavioral;

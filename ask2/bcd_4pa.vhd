library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package bcd_arr_pkg is
    type bcd_arr is array(3 downto 0) of std_logic_vector(3 downto 0);
end package;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.bcd_arr_pkg.all;

entity bcd_4pa is
port(
    A, B: in bcd_arr;
    Cin : in std_logic;
    S: out bcd_arr;
    Cout : out std_logic
);
end entity;

architecture structural of bcd_4pa is
signal C: std_logic_vector(4 downto 0);
begin
    C(0) <= Cin;
    gen: for I in 0 to 3 generate
        adder: entity work.BCD_comb port map(
            A=>A(I),
            B=>B(I),
            Cin=>C(I),
            S=>S(I),
            Cout=>C(I+1)
        );
    end generate;
    Cout <= C(4);
end structural;

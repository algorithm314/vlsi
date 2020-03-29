library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity bcd_4pa_tb is
end bcd_4pa_tb;
use work.bcd_arr_pkg.all;

architecture Behavioral of bcd_4pa_tb is
-- inputs 
    signal A, B : bcd_arr;
    signal Cin : std_logic;
-- outputs
    signal S : bcd_arr;
    signal Cout : std_logic;
begin
    UUT: entity work.bcd_4pa port map (A=>A, B=>B, Cin=>Cin, S=>S, Cout=>Cout);
    process is
    begin
    
    Cin <= '1';
    
    A(0) <= "1000";
    A(1) <= "1001";
    A(2) <= "0100";
    A(3) <= "0001";
    
    B(0) <= "1000";
    B(1) <= "0011";
    B(2) <= "0110";
    B(3) <= "0000";
    
    wait for 1 ns;
    
    Cin <= '0';
    
    A(0) <= "1001";
    A(1) <= "1000";
    A(2) <= "1000";
    A(3) <= "1000";
    
    B(0) <= "0101";
    B(1) <= "0101";
    B(2) <= "1001";
    B(3) <= "0101";
    
    wait for 1 ns;
    
    Cin <= '0';
    
    A(0) <= "0100";
    A(1) <= "0001";
    A(2) <= "0010";
    A(3) <= "0011";
    
    B(0) <= "0111";
    B(1) <= "1001";
    B(2) <= "1000";
    B(3) <= "0111";
    
    wait for 1 ns;
    
    Cin <= '1';
    
    A(0) <= "1001";
    A(1) <= "1001";
    A(2) <= "1001";
    A(3) <= "1001";
    
    B(0) <= "1001";
    B(1) <= "1001";
    B(2) <= "1001";
    B(3) <= "1001";
    
    
    wait;
    end process; 
end Behavioral;

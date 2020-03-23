
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity full_adder_bhv_tb is
  --  Port ( );
end full_adder_bhv_tb;

architecture Behavioral of full_adder_bhv_tb is

component full_adder_bhv
   port( 
  A, B, Cin : in std_logic;  
  S, Cout : out std_logic
  );  
 end component; 
 signal A,B,Cin: std_logic:='0';
 signal S,Cout: std_logic;

begin

bhv_full_adder: full_adder_bhv port map 
   (
    A => A,
    B => B,
    Cin => Cin,
    S => S,
    Cout => Cout 
   );
  process
  begin
   A <= '1';
   B <= '1';
   Cin <= '1';
   wait for 50 ns; 
   A <= '1';
   B <= '1';
   Cin <= '0';
   wait for 50 ns; 
   A <= '1';
   B <= '0';
   Cin <= '1';
   wait for 50 ns;
   A <= '0';
   B <= '0';
   Cin <= '0';
   wait for 50 ns;
   A <= '0';
   B <= '0';
   Cin <= '1';
   wait for 50 ns;   
   A <= '0';
   B <= '1';
   Cin <= '0';
   wait for 50 ns;
   A <= '0';
   B <= '1';
   Cin <= '1';
   wait for 50 ns;
   A <= '1';
   B <= '0';
   Cin <= '0';
   wait for 50 ns;
  
  end process;
  
end Behavioral;

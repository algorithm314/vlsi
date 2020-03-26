
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.NUMERIC_STD.ALL;


entity full_adder_bhv is
    Port ( A : in STD_LOGIC;
           B : in STD_LOGIC;
           Cin : in STD_LOGIC;
           S : out STD_LOGIC;
           Cout : out STD_LOGIC);
end full_adder_bhv;

architecture Behavioral of full_adder_bhv is

signal tmp: std_logic_vector(1 downto 0);
 begin  
   process(A,B,Cin)
   begin 
 tmp <= ('0'& A) + ('0'& B) +('0'& Cin) ;
   end process;
   S <= tmp(0);
   Cout <= tmp(1);

end Behavioral;

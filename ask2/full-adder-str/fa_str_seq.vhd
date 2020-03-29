
library IEEE;
library xil_defaultlib;
use xil_defaultlib.ALL;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity full_adder_structural is
    Port ( FA : in STD_LOGIC;
           FB : in STD_LOGIC;
           FC : in STD_LOGIC;
           clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           FS : out STD_LOGIC;
           FCA : out STD_LOGIC);
end full_adder_structural;

architecture Structural of full_adder_structural is

component half_adder_dtf is

Port ( A,B : in STD_LOGIC;

       S,CA : out STD_LOGIC);

end component;




component or_gate is

Port ( X,Y: in STD_LOGIC;

         Z: out STD_LOGIC);

end component;




SIGNAL S0,S1,S2,S3,S4:STD_LOGIC;

begin

U1:half_adder_dtf PORT MAP(A=>FA,B=>FB,S=>S0,CA=>S1);

U2:half_adder_dtf PORT MAP(A=>S0,B=>FC,S=>S3,CA=>S2);

U3:or_gate PORT MAP(X=>S2,Y=>S1,Z=>S4);

process(clk)
       begin
   
           if (rising_edge(clk)) then
           if (rst = '1') then 
           FS<='0';
           FCA<='0';
           else
           FS<=S3;
           FCA<=S4;
           end if;
             
       end if;
    end process;
end Structural;

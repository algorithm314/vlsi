library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


entity AND2 is
    PORT (A: in STD_LOGIC;
        B: in STD_LOGIC;
        AnB: out STD_LOGIC);
end AND2;

architecture trivial of AND2 is
begin
    AnB <= A and B;
end trivial;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity OR3 is
    PORT (A: in STD_LOGIC;
        B: in STD_LOGIC;
        C: in STD_LOGIC;
        AoBoC: out STD_LOGIC);
end OR3;

architecture trivial of OR3 is
begin
    AoBoC <= A or B or C;
end trivial;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity BCD_comb is
    Port ( A : in STD_LOGIC_VECTOR (3 downto 0);
           B : in STD_LOGIC_VECTOR (3 downto 0);
           Cin: in STD_LOGIC;
           S : out STD_LOGIC_VECTOR (3 downto 0);
           Cout : out STD_LOGIC);
end BCD_comb;

architecture structural of BCD_comb is

signal sum: std_logic_vector(3 downto 0);
signal Cint: std_logic;
signal o1,o2,o3:std_logic;
signal int_cout: std_logic;

begin
    adder1: entity work.rca_4bit_comb port map(A=>A,B=>B,Cin=>Cin,S=>sum,Cout=>int_cout);
    u1: entity work.AND2 port map(A=>sum(3),B=>sum(2),AnB=>o1);
    u2: entity work.AND2 port map(A=>sum(3),B=>sum(1),AnB=>o2);
    u3: entity work.OR3 port map(A=>o1,B=>o2,C=>int_cout,AoBoC=>Cint);
    adder2: entity work.rca_4bit_comb port map(A=>sum,B(3)=> '0',B(2)=>Cint,B(1)=>Cint,B(0)=>'0',Cin=>'0',S=>S);
end structural;

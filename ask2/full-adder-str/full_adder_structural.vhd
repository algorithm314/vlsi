----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.03.2020 22:11:45
-- Design Name: 
-- Module Name: full_adder_structural - Structural
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
library xil_defaultlib;
use xil_defaultlib.ALL;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity full_adder_structural is
    Port ( FA : in STD_LOGIC;
           FB : in STD_LOGIC;
           FC : in STD_LOGIC;
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




SIGNAL S0,S1,S2:STD_LOGIC;

begin

U1:half_adder_dtf PORT MAP(A=>FA,B=>FB,S=>S0,CA=>S1);

U2:half_adder_dtf PORT MAP(A=>S0,B=>FC,S=>FS,CA=>S2);

U3:or_gate PORT MAP(X=>S2,Y=>S1,Z=>FCA);

end Structural;

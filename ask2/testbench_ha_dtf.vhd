----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.03.2020 20:56:24
-- Design Name: 
-- Module Name: testbench_ha_dtf - Behavioral
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
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity testbench_ha_dtf is
 --    Port ( );
end testbench_ha_dtf;

architecture Behavioral of testbench_ha_dtf is

component half_adder_dtf is
  Port (A,B:in std_logic;
  S,CA: out std_logic );
end component;
--inputs
signal A: std_logic;
signal B: std_logic;
--outputs
signal CA : std_logic;
signal S : std_logic;

begin

uut: half_adder_dtf PORT MAP(A=>A,B=>B,CA=>CA,S=>S);
--Stimulus Process
stim_proc:process
begin
A<='0';
B<='0';
wait for 10ns;
A<='0';
B<='1';

 wait for 10ns;
A<='1';
B<='0';
 wait for 10ns; 
 
A<='1';
B<='1';
 wait for 10ns;

end process;

end Behavioral;

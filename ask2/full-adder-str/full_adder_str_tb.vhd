
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity full_adder_str_tb is
--    Port ( );
end full_adder_str_tb;

architecture Behavioral of full_adder_str_tb is

component full_adder_structural is 
 Port(
 FA : in std_logic;
 FB : in std_logic;
 FC : in std_logic;
 FS : out std_logic;
 FCA : out std_logic
 );
 end component;
 --Inputs
 signal FA : std_logic := '0';
 signal FB : std_logic := '0';
 signal FC : std_logic := '0';
 --Outputs
 signal FS : std_logic;
 signal FCA : std_logic;
 
begin

-- Instantiate the Unit Under Test (UUT)
 uut: full_adder_structural PORT MAP (FA => FA,FB => FB,FC => FC,FS => FS,FCA => FCA);
 -- Stimulus process
 stim_proc: process
 begin
 
 wait for 100 ns; 
  -- insert stimulus here
  FA <= '1';
  FB <= '0';
  FC <= '0';
  wait for 10 ns;
  FA <= '0';
  FB <= '1';
  FC <= '0';
  wait for 10 ns;
  FA <= '1';
  FB <= '1';
  FC <= '0';
  wait for 10 ns;
  FA <= '0';
  FB <= '0';
  FC <= '1';
  wait for 10 ns;
  FA <= '1';
  FB <= '0';
  FC <= '1';
  wait for 10 ns;
  FA <= '0';
  FB <= '1';
  FC <= '1';
  wait for 10 ns;
  FA <= '1';
  FB <= '1';
  FC <= '1';
  wait for 10 ns;
  end process;
end Behavioral;

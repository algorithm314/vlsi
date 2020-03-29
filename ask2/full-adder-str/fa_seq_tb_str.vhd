


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity fa_seq_tb_str is
 --   Port ( );
end fa_seq_tb_str;

architecture Structural of fa_seq_tb_str is

component full_adder_structural is 
 Port(
 FA : in std_logic;
 FB : in std_logic;
 FC : in std_logic;
 clk : in STD_LOGIC;
 rst : in STD_LOGIC;
 FS : out std_logic;
 FCA : out std_logic
 );
 end component;
 --Inputs
 signal FA : std_logic := '0';
 signal FB : std_logic := '0';
 signal FC : std_logic := '0';
 signal clk : std_logic := '1';
 signal rst : std_logic := '1';
 --Outputs
 signal FS : std_logic;
 signal FCA : std_logic;
 
 constant clock_period: time := 10 ns;
 constant clock_num: integer := 1024;
   
begin

UUT: full_adder_structural port map (FA => FA,FB => FB,FC => FC,FS => FS,FCA => FCA, clk=>clk, rst=>rst);

-- Process for generating the clock
    clk <= not clk after clock_period / 2;

	process is

	begin
              
 rst <= '1';
 for i0 in 0 to 1 loop
    for i1 in 0 to 1 loop
        for i2 in 0 to 1 loop
            for i3 in 0 to 1 loop
                 FA <= not FA;
               wait for clock_period;
            end loop;
        FB <= not FB;
        end loop;
    FC <= not FC;
    end loop;
 rst <= not rst;
 end loop;
 wait;
	end process;

end Structural;

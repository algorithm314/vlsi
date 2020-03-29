


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity fa_seq_tb_bhv is
 --   Port ( );
end fa_seq_tb_bhv;

architecture Behavioral of fa_seq_tb_bhv is

component fa_bhv_s
   port( 
  A, B, Cin,clk,rst : in std_logic;  
  S, Cout : out std_logic
  );  
 end component; 
 signal A,B,Cin,rst: std_logic:='0';
 signal clk: std_logic:='1';
 signal S,Cout: std_logic;
 
 constant clock_period: time := 10 ns;
 constant clock_num: integer := 1024;
   
begin

UUT: fa_bhv_s port map (A=>A, B=>B, Cin=>Cin, S=>S, Cout=>Cout, clk=>clk, rst=>rst);

-- Process for generating the clock
    clk <= not clk after clock_period / 2;

	process is

	begin
              
 rst <= '1';
 for i0 in 0 to 1 loop
    for i1 in 0 to 1 loop
        for i2 in 0 to 1 loop
            for i3 in 0 to 1 loop
                 A <= not A;
               wait for clock_period;
            end loop;
        B <= not B;
        end loop;
    Cin <= not Cin;
    end loop;
 rst <= not rst;
 end loop;
 wait;
	end process;

end Behavioral;

library IEEE;

use IEEE.STD_LOGIC_1164.ALL;

use ieee.numeric_std.all;

use ieee.std_logic_unsigned.all;



entity fa_bhv_s is

    Port ( A : in STD_LOGIC;
           B : in STD_LOGIC;
           Cin : in STD_LOGIC;
           clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           S : out STD_LOGIC;
           Cout : out STD_LOGIC);

end fa_bhv_s;

architecture Behavioral of fa_bhv_s is


signal tmp : std_logic_vector(1 downto 0);
begin
    process(clk)
    
       begin
   
           if (rising_edge(clk)) then
           if (rst = '1') then 
           tmp(0) <= '0';
           tmp(1) <= '0';
           else
            tmp <= ('0'& A) + ('0'& B) +('0'& Cin);
           end if;
             
       end if;
    end process;
    
        S <= tmp(0);
                             Cout <= tmp(1);
end Behavioral;
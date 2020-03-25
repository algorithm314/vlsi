library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity rca_4bit_pipeline is
    port ( A, B : in std_logic_vector(3 downto 0);
           Cin, clk, rst : in std_logic;
           S : out std_logic_vector(3 downto 0);
           Cout : out std_logic);
end rca_4bit_pipeline;

architecture Structural of rca_4bit_pipeline is
component full_adder_bhv_seq is
    Port ( A : in std_logic;
           B : in std_logic;
           Cin : in std_logic;
           clk : in std_logic;
           S : out std_logic;
           Cout : out std_logic);
end component;
type register_arr is array (0 to 4) of std_logic_vector(3 downto 0);

-- Arrays of registers
-- Every element of the array corresponds to a stage of the pipeline
signal a_regs : register_arr;

signal b_regs : register_arr;
--signal b0_regs : std_logic;
--signal b1_regs : std_logic_vector(1 downto 0);
--signal b2_regs : std_logic_vector(2 downto 0);
--signal b3_regs : std_logic_vector(3 downto 0);


signal c_regs : std_logic_vector(4 downto 0);

--shared variable i : integer;

begin
f1:for k in 0 to 3 generate
        u1:full_adder_bhv_seq port map(A=>a_regs(k)(k), B=>b_regs(k)(k), Cin=>c_regs(k), S=>a_regs(k+1)(k), Cout=>c_regs(k+1), clk=>clk);
    end generate f1;
process(clk)
begin



if rising_edge(clk) then
    a_regs(0) <= A;
    b_regs(0) <= B;
    c_regs(0) <= Cin;
    if rst = '1' then
        c_regs <= (others=>'0');
        for i in 0 to 3 loop
            a_regs(i) <= (others=>'0');
            b_regs(i) <= (others=>'0');
        end loop;
    else
        
        
        for i in 1 to 4 loop
            for j in 0 to 3 loop
--                if (i/=(j+1)) then
                    a_regs(i)(j) <= a_regs(i-1)(j);
                    b_regs(i)(j) <= b_regs(i-1)(j); 
--                end if;
            end loop;
            
        end loop;
        
        
    end if;
end if;
end process;
S <= a_regs(4);
Cout <= c_regs(4);
end Structural;

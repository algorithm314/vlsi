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
           rst : in std_logic;
           clk : in std_logic;
           S : out std_logic;
           Cout : out std_logic);
end component;
-- Intermediate output S registers
signal s_reg0 : std_logic;
signal s_reg1 : std_logic_vector(1 downto 0);
signal s_reg2 : std_logic_vector(2 downto 0);
signal s_reg3 : std_logic_vector(3 downto 0);
-- Intermediate input A and B registers
signal a_reg0, b_reg0 : std_logic_vector(2 downto 0);
signal a_reg1, b_reg1 : std_logic_vector(1 downto 0);
signal a_reg2, b_reg2 : std_logic;
-- Intermediate carries 
signal c_regs : std_logic_vector(4 downto 0);
begin
-- PIPELINE

-- Stage 0
u0:full_adder_bhv_seq port map(
        A=>A(0),
        B=>B(0),
        Cin=>Cin,
        S=>s_reg0,
        Cout=>c_regs(0),
        rst=>rst,
        clk=>clk
    );
process(clk)
begin
if rising_edge(clk) then
    a_reg0(0) <= A(1);
    a_reg0(1) <= A(2);
    a_reg0(2) <= A(3);
    
    b_reg0(0) <= B(1);
    b_reg0(1) <= B(2);
    b_reg0(2) <= B(3);
end if;
end process;

-- Stage 1
u1:full_adder_bhv_seq port map(
        A=>a_reg0(0),
        B=>b_reg0(0),
        Cin=>c_regs(0),
        S=>s_reg1(1),
        Cout=>c_regs(1),
        rst=>rst,
        clk=>clk        
    );
process(clk)
begin
if rising_edge(clk) then
    s_reg1(0) <= s_reg0;
    
    a_reg1(0) <= a_reg0(1);
    a_reg1(1) <= a_reg0(2);
    
    b_reg1(0) <= b_reg0(1);
    b_reg1(1) <= b_reg0(2);
end if;
end process;

-- Stage 2
u2:full_adder_bhv_seq port map(
        A=>a_reg1(0),
        B=>b_reg1(0),
        Cin=>c_regs(1),
        S=>s_reg2(2),
        Cout=>c_regs(2),
        rst=>rst,
        clk=>clk
    );
process(clk)
begin
if rising_edge(clk) then
    s_reg2(0) <= s_reg1(0);
    s_reg2(1) <= s_reg1(1);
    
    a_reg2 <= a_reg1(1);
    
    b_reg2 <= b_reg1(1);
end if;
end process;

-- Stage 3
u3:full_adder_bhv_seq port map(
        A=>a_reg2,
        B=>b_reg2,
        Cin=>c_regs(2),
        S=>s_reg3(3),
        Cout=>c_regs(3),
        rst=>rst,
        clk=>clk
    );
process(clk)
begin
if rising_edge(clk) then
    s_reg3(0) <= s_reg2(0);
    s_reg3(1) <= s_reg2(1);
    s_reg3(2) <= s_reg2(2);
end if;
end process;

-- Output
process(clk)
begin
if rising_edge(clk) then
    S <= s_reg3;
    Cout <= c_regs(3);
end if;
end process;
end Structural;

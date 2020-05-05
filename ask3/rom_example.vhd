library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity mlab_rom is
	 generic (
		coeff_width : integer :=8  				--- width of coefficients (bits)
	 );
    Port ( clk : in  STD_LOGIC;
			  en : in  STD_LOGIC;				--- operation enable
           addr : in  unsigned (2 downto 0);			-- memory address
           rom_out : out  unsigned (coeff_width-1 downto 0));	-- output data
end mlab_rom;

architecture Behavioral of mlab_rom is

    type rom_type is array (7 downto 0) of unsigned (coeff_width-1 downto 0);                 
    signal rom : rom_type:= ("00001000", "00000111", "00000110", "00000101", "00000100", "00000011", "00000010",
                             "00000001");      				 -- initialization of rom with user data                 

    signal rdata : unsigned(coeff_width-1 downto 0) := (others => '0');
begin

    rdata <= rom(to_integer(addr));

    process (clk)
    begin
        if rising_edge(clk) then
            if (en = '1') then
                rom_out <= rdata;
            end if;
        end if;
    end process;

end Behavioral;



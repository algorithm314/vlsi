LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.math_real.all;

PACKAGE types IS

	CONSTANT taps        : INTEGER := 8; --number of fir filter taps
	CONSTANT data_width  : INTEGER := 8; --width of data input 
	CONSTANT coeff_width : INTEGER := 8; --width of coefficients 
	constant ZERO : UNSIGNED(10 downto 0) := (others => '0');
	
	TYPE coefficient_array IS ARRAY (0 TO taps-1) OF STD_LOGIC_VECTOR(coeff_width-1 DOWNTO 0);  --array of all coefficients
	TYPE data_array IS ARRAY (0 TO taps-1) OF UNSIGNED(data_width-1 DOWNTO 0);                    --array of historic data values
	TYPE product_array IS ARRAY (0 TO taps-1) OF UNSIGNED((data_width + coeff_width)-1 DOWNTO 0); --array of coefficient * data products
	type ADD_TYPE is array(0 TO taps-1) of UNSIGNED(18 downto 0);
	
END PACKAGE types;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.math_real."ceil";
USE ieee.math_real."log2";

PACKAGE types IS

	CONSTANT taps        : INTEGER := 8; --number of fir filter taps
	CONSTANT data_width  : INTEGER := 8; --width of data input 
	CONSTANT coeff_width : INTEGER := 8; --width of coefficients 
	constant ZERO : UNSIGNED(data_width + coeff_width + integer(ceil(log2(real(taps)))) - 1  downto 0) := (others => '0');
	
	TYPE coefficient_array IS ARRAY (0 TO taps-1) OF STD_LOGIC_VECTOR(coeff_width-1 DOWNTO 0);  --array of all coefficients
    CONSTANT COEFS : coefficient_array := ("00000001", "00000010", "00000011", "00000100", "00000101", "00000110", "00000111", "00001000");
   -- CONSTANT COEFS : coefficient_array := ("00000001", "00000001", "00000001", "00000001","00000001"); 
	TYPE data_array IS ARRAY (0 TO taps-1) OF UNSIGNED(data_width-1 DOWNTO 0);                    --array of historic data values
	TYPE product_array IS ARRAY (0 TO taps-1) OF UNSIGNED((data_width + coeff_width)-1 DOWNTO 0); --array of coefficient * data products
	type ADD_TYPE is array(0 TO taps-1) of UNSIGNED(data_width + coeff_width + integer(ceil(log2(real(taps)))) - 1 downto 0);
	
END PACKAGE types;

LIBRARY ieee;
LIBRARY xil_defaultlib;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE IEEE.math_real."ceil";
USE IEEE.math_real."log2";
USE work.types.all;

ENTITY fir_filter IS
	PORT(
		--	valid_in        :   IN	STD_LOGIC;
			clk				:	IN	STD_LOGIC;                                  --system clock
			reset_n			:	IN	STD_LOGIC;                                  --active low asynchronous reset
			data			:	IN	STD_LOGIC_VECTOR(data_width-1 DOWNTO 0);    --data stream
			result			:	OUT	STD_LOGIC_VECTOR((data_width + coeff_width + integer(ceil(log2(real(taps)))) - 1) DOWNTO 0);  --filtered result
		--	valid_out       :   OUT STD_LOGIC;
		    data_pipeline   :   INOUT data_array;        --pipeline of historic data values
	        ADD             :   INOUT ADD_TYPE);
END fir_filter;

ARCHITECTURE behavior OF fir_filter IS
	SIGNAL data_temp, data_temp2, data_temp3, data_temp4, data_temp5, data_temp6, data_temp7 : data_array;        --extra latency
	SIGNAL products 		: product_array;     --array of coefficient*data products
	attribute syn_multstyle : string;
    attribute syn_multstyle of products : signal is "logic";
	
BEGIN
    
	PROCESS(clk, reset_n)
		
	BEGIN
	
		IF(reset_n = '1') THEN                                       --asynchronous reset
		
			data_pipeline <= (OTHERS => (OTHERS => '0'));              --clear data pipeline values
			data_temp <= (OTHERS => (OTHERS => '0'));
--			data_temp2 <= (OTHERS => (OTHERS => '0'));
--			data_temp3 <= (OTHERS => (OTHERS => '0'));
--			data_temp4 <= (OTHERS => (OTHERS => '0'));
--			data_temp5 <= (OTHERS => (OTHERS => '0'));
--			data_temp6 <= (OTHERS => (OTHERS => '0'));
--			data_temp7 <= (OTHERS => (OTHERS => '0'));
			products <= (OTHERS => (OTHERS => '0'));
		    ADD <= (OTHERS => (OTHERS => '0'));
			result <= (OTHERS => '0');                                  --clear result output
			
		ELSIF(clk'EVENT AND clk = '1') THEN                          --not reset
		
		    result <= std_logic_vector(ADD(taps-1));	                           --output result
--		    data_temp2 <= data_temp;
--		    data_temp3 <= data_temp2;
--		    data_temp4 <= data_temp3;
--		    data_temp5 <= data_temp4;
--		    data_temp6 <= data_temp5;
--		    data_temp7 <= data_temp6;
			FOR i IN taps-1 DOWNTO 0 LOOP
			if i = 0 then 
			 ADD(i) <=  products(i) + ZERO ;
			else
			 ADD(i) <=  products(i) + ADD(i-1);
			end if; 
			products(i) <= data_pipeline(i) * UNSIGNED(COEFS(i));
			data_pipeline <= data_temp; 
			data_temp <= UNSIGNED(data) & data_pipeline(0 TO taps-2);	--shift new data into data pipeline
			END LOOP;			
		END IF;
	END PROCESS;
	
	
END behavior;
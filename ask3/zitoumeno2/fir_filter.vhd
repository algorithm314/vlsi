
LIBRARY ieee;
LIBRARY xil_defaultlib;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.math_real.all;
USE xil_defaultlib.types.all;

ENTITY fir_filter IS
	PORT(
			clk				:	IN		STD_LOGIC;                                  --system clock
			reset_n			:	IN		STD_LOGIC;                                  --active low asynchronous reset
			data				:	IN		STD_LOGIC_VECTOR(data_width-1 DOWNTO 0);    --data stream
			coefficients	:	IN		coefficient_array;                          --coefficient array
		--	result			:	OUT	STD_LOGIC_VECTOR((data_width + coeff_width + integer(ceil(log2(real(taps)))) - 1) DOWNTO 0));  --filtered result
	        result			:	OUT	UNSIGNED(18 DOWNTO 0));
			--result :               OUT STD_LOGIC_VECTOR((integer(ceil(log2(real(taps)))) -1 ) DOWNTO 0));
END fir_filter;

ARCHITECTURE behavior OF fir_filter IS
	SIGNAL coeff_int 		: coefficient_array; --array of latched in coefficient values
	SIGNAL data_pipeline : data_array;        --pipeline of historic data values
	SIGNAL products 		: product_array;     --array of coefficient*data products
	attribute syn_multstyle : string;
    attribute syn_multstyle of products : signal is "logic";
	SIGNAL ADD             : ADD_TYPE;
BEGIN

	PROCESS(clk, reset_n)
		--VARIABLE sum : UNSIGNED((data_width + coeff_width + integer(ceil(log2(real(taps)))) - 1) DOWNTO 0); --sum of products
		
	BEGIN
	
		IF(reset_n = '0') THEN                                       --asynchronous reset
		
			data_pipeline <= (OTHERS => (OTHERS => '0'));               --clear data pipeline values
			coeff_int <= (OTHERS => (OTHERS => '0'));		               --clear internal coefficient registers
			result <= (OTHERS => '0');                                  --clear result output
			
		ELSIF(clk'EVENT AND clk = '1') THEN                          --not reset

			coeff_int <= coefficients;												--input coefficients		
			data_pipeline <= UNSIGNED(data) & data_pipeline(0 TO taps-2);	--shift new data into data pipeline

			FOR i IN 0 TO taps-1 LOOP
			products(i) <= data_pipeline(i) * UNSIGNED(coeff_int(i));
		--		sum := sum + products(i);                                --add the products
			if i = 0 then 
			 ADD(i) <= ZERO + products(0);
			else
			 ADD(i) <=  products(i) + ADD(i-1);
			end if;  
			END LOOP;
			
			result <= ADD(taps-1);	                           --output result
			
		END IF;
	END PROCESS;
	
	--perform multiplies
	--product_calc: FOR i IN 0 TO taps-1 GENERATE
		--products(i) <= data_pipeline(i) * UNSIGNED(coeff_int(i));
	--END GENERATE;
	
END behavior;
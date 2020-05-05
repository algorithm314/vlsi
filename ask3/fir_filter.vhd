LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.math_real."ceil";
USE ieee.math_real."log2";

PACKAGE types IS

	CONSTANT taps        : INTEGER := 8; --number of fir filter taps
	CONSTANT data_width  : INTEGER := 8; --width of data input 
	CONSTANT coeff_width : INTEGER := 8; --width of coefficients 
	CONSTANT ZERO : UNSIGNED(data_width + coeff_width + integer(ceil(log2(real(taps)))) - 1  downto 0) := (others => '0');
	
	TYPE coefficient_array IS ARRAY (0 TO taps-1) OF STD_LOGIC_VECTOR(coeff_width-1 DOWNTO 0);  --array of all coefficients
    CONSTANT COEFS : coefficient_array := ("00000001", "00000010", "00000011", "00000100", "00000101", "00000110", "00000111", "00001000");
	TYPE data_array IS ARRAY (0 TO 2*taps-1) OF UNSIGNED(data_width-1 DOWNTO 0);                    --array of historic data values, latency*2 for sync
	TYPE product_array IS ARRAY (0 TO taps-1) OF UNSIGNED((data_width + coeff_width)-1 DOWNTO 0); --array of coefficient * data products
	TYPE ADD_TYPE IS ARRAY(0 TO taps-1) of UNSIGNED(data_width + coeff_width + integer(ceil(log2(real(taps)))) - 1 downto 0); --array of sums of products*coef
	TYPE valid_array IS ARRAY(0 TO 17) of UNSIGNED(0 DOWNTO 0); --length same as latency-1 (1 stage before result) 
	
END PACKAGE types;

LIBRARY ieee;
LIBRARY xil_defaultlib;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;
USE ieee.math_real."ceil";
USE ieee.math_real."log2";
USE work.types.all;

ENTITY fir_filter IS
	PORT(
			valid_in        :   IN	STD_LOGIC_VECTOR(0 DOWNTO 0);
			clk				:	IN	STD_LOGIC;                                  --system clock
			reset_n			:	IN	STD_LOGIC;                                  --active low asynchronous reset
			data			:	IN	STD_LOGIC_VECTOR(data_width-1 DOWNTO 0);    --data stream
			data_pipeline   :   INOUT data_array;
			result			:	OUT	STD_LOGIC_VECTOR((data_width + coeff_width + integer(ceil(log2(real(taps)))) - 1) DOWNTO 0);
			ADD             :   INOUT  ADD_TYPE;  --filtered result
			valid_out       :   OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
			valid_reg       :   INOUT valid_array;
			count           :   INOUT STD_LOGIC_VECTOR(2 downto 0):="000");
		    
END fir_filter;

ARCHITECTURE behavior OF fir_filter IS
	SIGNAL products 		: product_array;     --array of coefficient*data products
--	  SIGNAL valid_reg        : valid_array;
--	  SIGNAL data_pipeline    : data_array;        --pipeline of historic data values
--	  SIGNAL ADD              :  ADD_TYPE;
	ATTRIBUTE syn_multstyle : string;
    ATTRIBUTE syn_multstyle OF products : SIGNAL IS "logic";
--    SIGNAL count : STD_LOGIC_VECTOR(2 downto 0):="000";
	
BEGIN
    
	PROCESS(clk, reset_n)
		
	BEGIN
	
		IF(reset_n = '1') THEN                                       --asynchronous reset
		
			data_pipeline <= (OTHERS => (OTHERS => '0'));              --clear data pipeline values
			valid_reg <= (OTHERS => (OTHERS => '0'));
			products <= (OTHERS => (OTHERS => '0'));
		    ADD <= (OTHERS => (OTHERS => '0'));
			result <= (OTHERS => '0');                                  --clear result output
			valid_out <= (OTHERS => '0');
		ELSIF(clk'EVENT AND clk = '1') THEN                          --not reset
	
			data_pipeline <= UNSIGNED(data) & data_pipeline(0 TO 2*taps-2);	--shift new data into data pipeline
                                                                            --even index is extra latency, odd index shifts to product array
			IF valid_in = "1" THEN 
			 IF  count > "000" THEN --there is previous valid_in=0 that affects validity of final result 
			     valid_reg <= UNSIGNED(not(valid_in)) & valid_reg(0 TO 16); --shift inversed new valid_in (0) into valid_reg
			     count <= count-1 ; --previous valid_in=0 goes to next stage 
			 ELSIF count="000" THEN --previous valid_in = 0 does not exist anymore
			     valid_reg<= UNSIGNED(valid_in) & valid_reg(0 TO 16);
			 END IF; 
			ELSIF valid_in = "0" THEN  
		      valid_reg <= UNSIGNED(valid_in) & valid_reg(0 TO 16); --shift new valid_in into valid_reg
			  count <= "111" ; --update counter, new valid_in=0 that affects "this" and the next 7 final results' validity 
			END IF;
			FOR i IN taps-1 DOWNTO 0 LOOP
			 IF i = 0 THEN 
			     ADD(i) <=  products(i) + ZERO ;
			 ELSE
			     ADD(i) <=  products(i) + ADD(i-1);
			 END IF; 
			 products(i) <= data_pipeline(2*i + 1) * UNSIGNED(COEFS(i));
			END LOOP;	
			result <= STD_LOGIC_VECTOR(ADD(taps-1));	                          --output result	
			valid_out <= STD_LOGIC_VECTOR(valid_reg(17));                         --valid_out
				
		END IF;
	END PROCESS;
	
	
END behavior;
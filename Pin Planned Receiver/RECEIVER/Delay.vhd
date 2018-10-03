library IEEE;
 
use IEEE.STD_LOGIC_1164.ALL;
  
use IEEE.NUMERIC_STD.ALL; 
 
use IEEE.STD_LOGIC_unSIGNED.ALL; 

ENTITY Delay IS

PORT (	enable, clk, reset_n :IN STD_LOGIC;

			flag :OUT STD_LOGIC);
END Delay;

ARCHITECTURE Clock OF Delay IS

------------------------------------------------------------------------------------------------------------ the mux stuff
constant micro_sec 		: STD_LOGIC_VECTOR(27 DOWNTO 0) := X"0000031";
------------------------------------------------------------------------------------------------------------

Signal count 			:STD_LOGIC_VECTOR (27 DOWNTO 0); -- is the signal which gets the microsecond value for the delay.
Signal tst: std_logic;

BEGIN 


Reaching_a_micro_second : Process (clk,reset_n,enable,count) -- clocks the enable for the shift register

BEGIN

 
    IF (enable = '0' OR reset_n ='0') THEN 
	flag  <= '0'; 
    count <= (OTHERS => '0');
                      
     ELSIF (RISING_EDGE(clk)) THEN
 	IF(enable = '1') THEN
		IF ( count = micro_sec) THEN
		    flag <= '1';
		    count <= (OTHERS => '0');           
        ELSE 
			flag <= '0';
           	count <= count + 1;
		END IF;
       	END IF;
	  END if;
END PROCESS;
END Clock;
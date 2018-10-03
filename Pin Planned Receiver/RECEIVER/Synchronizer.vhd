library ieee;  
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_unSIGNED.ALL;

ENTITY Synchronizer IS
PORT(
        clk,reset_n,Data_in:IN STD_LOGIC; 
    
    Wake, Data_out :OUT STD_LOGIC);
END Synchronizer;

ARCHITECTURE Together OF Synchronizer IS
Signal q1,q2,q3 :STD_LOGIC;  

BEGIN

Synchronizers: Process(clk,reset_n,q1,q2,Data_in) IS

BEGIN

if reset_n = '0' THEN

    q1<='0';
    q2<='0';
    q3<='0';
    
    ELSIF Rising_edge(clk) THEN
    
    q1 <= Data_in; 
    q2 <= q1;
    q3 <= q2;
    
END IF;

END PROCESS;

Waking_Up_The_Reciever: Process (q1,q2,q3)

	BEGIN
	
	IF(q3 = '1' AND q2= '0' AND q1 = '0') THEN
	
		Wake <= '0'; 
		
	ELSE
	 
		Wake <='1';
	END IF;
END PROCESS;
Data_out <= q3;
 


END Together;



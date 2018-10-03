library IEEE;
 
use IEEE.STD_LOGIC_1164.ALL;
  
use IEEE.NUMERIC_STD.ALL; 
 
use IEEE.STD_LOGIC_unSIGNED.ALL; 

ENTITY MOD8 IS

    PORT(  enable1,enable2 :IN STD_LOGIC;
                clk :IN STD_LOGIC;
                reset_n :IN STD_LOGIC;
                CNT : out STD_LOGIC);
            
END MOD8;
    
ARCHITECTURE Counter OF MOD8 IS



signal counting: STD_LOGIC_VECTOR(3 DOWNTO 0);


BEGIN

Modulous8: Process (reset_n, clk,counting,enable1,enable2)
BEGIN

    IF (reset_n = '0') THEN
        counting <= "0000";
        CNT <= '0';
    ELSIF(RISING_EDGE(clk)) THEN
        IF(enable1 = '1' AND enable2 = '1') THEN            
            IF(counting = "111") THEN           
                counting <="0000";  
                CNT <=  '1';        
            ELSE                
                counting <= counting + 1;
                CNT <= '0';
            END If;
        ELSE CNT <= '0';
        END If;
    END If;         
END PROCESS;    
END Counter;
    
    
    
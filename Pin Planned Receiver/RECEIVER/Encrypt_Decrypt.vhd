library ieee;  
use ieee.std_logic_1164.all;  
 
entity Encrypt_Decrypt is  
  port(Enable, Clk,sw9             : in std_logic; 
       Data_In_Port1, Data_In_Port2 : in std_logic_vector(7 downto 0);
       Data_out    		    : out std_logic_vector(7 downto 0));  
end Encrypt_Decrypt;  
architecture arc of Encrypt_Decrypt is  
  begin  
    process (Clk,enable,sw9)  
    begin  
        if (rising_edge(clk)) then  
          --if(enable = '1') then
            if (sw9 = '1') then
              Data_out <= Data_In_Port1;
            else
	      Data_out <= Data_In_Port1 XOR Data_In_Port2; 
            end if;
          --end if; 
	end if; 
    end process;  
end arc; 
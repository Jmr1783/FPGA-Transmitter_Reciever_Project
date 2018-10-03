library ieee;  
use ieee.std_logic_1164.all;  
 
entity storage is  
  port(Enable, Clk: in std_logic; 
	   Data_in : in std_logic_vector(7 downto 0);
       Data_out : out std_logic_vector(7 downto 0));  
end storage;  
architecture arc of storage is  
  begin  
    process (Clk)  
      begin  
        if (rising_edge(clk)) then
			if(Enable = '0') then
				Data_out <= Data_in; 
			End IF; 
        end if;  
    end process;  
end arc; 
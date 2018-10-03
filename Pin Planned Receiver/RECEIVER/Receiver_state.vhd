library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Receiver_state is
   port(Clk,reset_n :IN std_logic;
        Key, data_Waker, CNT, Delay_signal :IN STD_LOGIC;
        Delay_EN, Shift_EN, Decrypt_EN:OUT STD_LOGIC
		);
end Receiver_state;
 

architecture Behavioral of Receiver_state is

TYPE state_type IS (Key2,Wait1,Shift);
SIGNAL current_state, next_state: state_type;
 
BEGIN   

sync: process(clk, reset_n)
	BEGIN
		if(reset_n = '0') then
			current_state <= Key2;
		elsif (rising_edge(clk)) then
			current_state <= next_state;
		END IF;

End PROCESS;

comb: PROCESS(current_state, Key,data_waker,CNT)
  BEGIN
	CASE(current_state) IS
	When Key2 => --waits for Key2 to be pressed
		if (key = '0') then 
		    next_state <= Wait1;
		else 
		    next_state <= Key2;
		end if;
	When Wait1 => --waits for the data_waker to drop
		if ( data_waker = '0') then 
		    next_state <= Shift;
		else 
		    next_state <= Wait1;
		end if;
	When Shift => --sends out the shift bit
	    if (CNT = '1') then
			next_state <= Key2;
		else
			next_state <= Shift;
		End if;
	-- When Cryption => --sends out the start bit
	        -- next_state <= Key2;
	END CASE;
	
End PROCESS;

-- Encryption: PROCESS(current_state) BEGIN -- turn on encryption module
	-- CASE(current_state) IS
	-- When Cryption => Decrypt_EN <= '1';
	-- When others => Decrypt_EN <= '0';
	-- END Case;
-- END PROCESS;

Delay_Unit:PROCESS(current_state) BEGIN -- turn on dely unit
	CASE(current_state) IS
	When Shift => Delay_EN <= '1';
	When others => Delay_EN <= '0';
	END Case;
END PROCESS;

Shift_Reg:PROCESS(current_state) BEGIN -- turn on shift register
	CASE(current_state) IS
	When Shift => Shift_EN <= '1';
	When others => Shift_EN <= '0';
	END Case;
END PROCESS;


end Behavioral;
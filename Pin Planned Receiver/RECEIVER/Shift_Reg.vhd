Library Ieee;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Shift_Reg is 
port(
	clk,Enable : in std_logic;
	reset_n, Shift :  in std_logic;
	serial_in :  in std_logic;
	Paralell_out :  out std_logic_vector(7 downto 0));
end shift_reg;
architecture rtl of shift_reg is
	signal Shift_Reg : std_logic_vector(7 downto 0);
	begin
	shifter: process(clk,reset_n,Shift_Reg,Enable,Shift) begin
			if (reset_n = '0') then
				Shift_Reg <= (others => '0');
			elsif (clk'event and clk = '1') then
				if (Enable = '1' And Shift = '1') then -- shift right
						Shift_Reg(7 downto 1) <= Shift_Reg(6 downto 0);
						Shift_Reg(0) <= serial_in;
				end if;    
		   end if;       
	end process;
Paralell_out <= Shift_Reg;
End rtl;
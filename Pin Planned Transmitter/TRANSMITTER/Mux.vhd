library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unSIGNED.ALL;

ENTITY Mux IS

	PORT( Data_IN :IN STD_LOGIC;
	      sel  :IN STD_LOGIC_VECTOR (1 DOWNTO 0);
	      Data_Out :OUT STD_LOGIC);
END Mux;

Architecture Arc OF Mux  IS

Signal Data_Line :STD_LOGIC; --signal for the output


BEGIN --ARCHITEVTURTE BEGINS
Selection: Process (sel, Data_IN)

	BEGIN
	
	Case sel IS	
	  WHEN "00" => Data_Line <= '0';
	  WHEN "10" => Data_Line <= Data_IN;
	  WHEN OTHERS => Data_Line <= '1';
	END Case;				
END PROCESS;
Data_Out <= Data_Line;
END ARC;
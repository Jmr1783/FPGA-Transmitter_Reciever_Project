library ieee;  
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_unSIGNED.ALL;

ENTITY TOP_level IS

PORT( Switches :IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    Key1,Key2, clk, reset_n :IN STD_LOGIC;
    GPIO :OUT STD_LOGIC;
    HEX0,HEX1 :OUT STD_LOGIC_VECTOR(6 DOWNTO 0));   
END TOP_level;

ARCHITECTURE TOPS OF TOP_level IS
----------------------------------------------------------------------------------
COMPONENT BCD2SSD IS
PORT(Bin :IN STD_LOGIC_VECTOR(3 downto 0);                             
     Hex :OUT STD_LOGIC_VECTOR(6 downto 0));
END COMPONENT;
----------------------------------------------------------------------------------
COMPONENT Mux IS
PORT(Data_IN :IN STD_LOGIC;
     sel  :IN STD_LOGIC_VECTOR (1 DOWNTO 0);
     Data_Out :OUT STD_LOGIC);
END COMPONENT;
----------------------------------------------------------------------------------
COMPONENT Encrypt_Decrypt IS
 port(Enable, Clk                  : in std_logic; 
      Data_In_Port1, Data_In_Port2 : in std_logic_vector(7 downto 0);
      Data_out  : out std_logic_vector(7 downto 0)); 
END COMPONENT;
----------------------------------------------------------------------------------
COMPONENT Delay IS
PORT (	enable, clk, reset_n :IN STD_LOGIC;
	flag :OUT STD_LOGIC);
END COMPONENT;
----------------------------------------------------------------------------------
COMPONENT Shift_Reg IS
port(
	clk, Enable : in std_logic;
	reset_n :  in std_logic;
	Load, Shift: in std_logic;
	Din:  in std_logic_vector(7 downto 0);
	serial_out :  out std_logic);
END COMPONENT;
----------------------------------------------------------------------------------
COMPONENT FSM IS
 port(Clk,Reset_n,Key1,Key2,Delay: in std_logic;
		CNT : in std_logic;
 	    Encrypt_EN, Delay_EN, Shift_EN, Load_EN: out std_logic;
		Transmit_OUT_Bit_Selector : out std_logic_vector(1 downto 0));
END COMPONENT;
----------------------------------------------------------------------------------
COMPONENT storage IS
port(Enable, Clk: in std_logic; 
	   Data_in : in std_logic_vector(7 downto 0);
       Data_out : out std_logic_vector(7 downto 0)); 
END COMPONENT;
----------------------------------------------------------------------------------
COMPONENT MOD8 IS
PORT(  enable1,enable2 :IN STD_LOGIC;
       clk :IN STD_LOGIC;
       reset_n :IN STD_LOGIC;
       CNT : out std_logic -- count is the flag which goes to the finite state machine
	); 
END COMPONENT;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
Signal Serial :STD_LOGIC; --This is the serial out data form the shift reg
Signal Selector :STD_LOGIC_VECTOR (1 DOWNTO 0); -- signal that will be taking the output from the state machine
Signal EncryptS_EN, DelayS_EN, ShiftS_EN, LoadS_EN :STD_LOGIC; -- Signals for the state machine
Signal counter : std_logic; --the count from the MOD8
Signal delay_signal : STD_LOGIC; --the signal for the delay &  flag to the shift register
Signal Data_out_signal1,Data_out_signal2,input_data_Encrypted : std_logic_vector(7 downto 0); --signal taking in teh switches data that is inputed
BEGIN
----------------------------------------------------------------------------------
Display0: BCD2SSD
PORT MAP
( Bin => Data_out_signal1(3 DOWNTO 0),
  Hex => HEX0
  );

Display1: BCD2SSD
PORT MAP
( Bin => Data_out_signal1(7 DOWNTO 4),
  Hex => HEX1
  );
----------------------------------------------------------------------------------
--------------------------------------

Port_Mapping_Mux: Mux

PORT MAP

    (Data_IN => Serial,
    sel => Selector,
    Data_OUT => GPIO
    );
--------------------------------------
--------------------------------------
    
Port_Mapping_ED : Encrypt_Decrypt

PORT MAP

    (Enable => EncryptS_EN,
     Clk => clk,
     Data_In_Port1 => Data_out_signal1,
     Data_In_Port2 => Data_out_signal2,
     Data_out => input_data_Encrypted
    );
--------------------------------------
--------------------------------------

Port_Mapping_Shifter : Shift_Reg

PORT MAP

    (serial_out  => Serial,
     clk => clk,
     reset_n => reset_n,
     load => LoadS_EN,
     Din => input_data_Encrypted,
     Shift => ShiftS_EN,
     enable => delay_signal
    );
--------------------------------------
--------------------------------------

Port_Mapping_Delay : Delay

PORT MAP

    (enable => DelayS_EN, 
     clk => clk,
     reset_n => reset_n,
     flag => delay_signal
    );
--------------------------------------
--------------------------------------

Port_Mapping_statemachine : FSM

PORT MAP

    ( Clk => clk,
      Reset_n => reset_n,
      Key1 => Key1,
      Key2 => Key2,
      Delay => delay_signal,
      CNT => counter,
      Transmit_OUT_Bit_Selector => Selector,
      Encrypt_EN => EncryptS_EN,
      Delay_EN => DelayS_EN,
      Shift_EN => ShiftS_EN,
      Load_EN => LoadS_EN
      );
--------------------------------------
--------------------------------------

Port_Mapping_MOD : MOD8

PORT MAP

    (clk => clk,
     reset_n => reset_n,
     enable1 => delay_signal,
     enable2 => ShiftS_EN,
     CNT => counter
    );
--------------------------------------
--------------------------------------

Port_Mapping_FlipFlop1 : storage

PORT MAP

    (Enable => Key1,
     Clk => clk,
     Data_in => Switches,
     Data_out => Data_out_signal1
    );
--------------------------------------
--------------------------------------

Port_Mapping_FlipFlop2 : storage

PORT MAP

    (Enable => Key2,
     Clk => clk,
     Data_in => Switches,
     Data_out => Data_out_signal2
    );
--------------------------------------
--------------------------------------


END TOPS;






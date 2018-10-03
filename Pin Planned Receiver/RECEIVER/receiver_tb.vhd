--*****************************************************************************
--***************************  VHDL Source Code  ******************************
--*********  Copyright 2010, Rochester Institute of Technology  ***************
--*****************************************************************************
--
--  DESIGNER NAME:  Jeanne Christman
--
--       LAB NAME:  encryption receiver
--
--      FILE NAME:  receiver_tb.vhd
--
-------------------------------------------------------------------------------
--
--  DESCRIPTION
--
--    This test bench will provide input to test the encryption receiver
--
-------------------------------------------------------------------------------
--
--  REVISION HISTORY
--
--  _______________________________________________________________________
-- |  DATE    | USER | Ver |  Description                                  |
-- |==========+======+=====+================================================
-- |          |      |     |
-- | 11/13/13 | JWC  | 1.0 | original 
-- | 11/30/16 | JWC  | 2.0 | updated for the DE0-CV board
-- |          |      |     |
--
--*****************************************************************************
--*****************************************************************************


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;           -- need for conv_std_logic_vector
USE ieee.std_logic_unsigned.ALL;        -- need for "+"


ENTITY receiver_tb IS
END receiver_tb;


ARCHITECTURE test OF receiver_tb IS

   -- Component Declaration for the Unit Under Test (UUT)
   -- if you use a package with the component defined then you do not need this
component Receiver_TOP_level is 
PORT ( clk, reset_n, sw9       : IN std_logic;
       data_line                 : IN std_logic;
       Switches                : IN std_logic_vector(7 downto 0);
       key                     : IN std_logic;
       HEX0,HEX1               : OUT std_logic_vector(6 downto 0));
END component;

   -- define signals for component ports
   SIGNAL clk_tb          : std_logic                    := '0';
   SIGNAL reset_n_tb      : std_logic                    := '0';
   SIGNAL key2_tb         : std_logic                    := '1';
   SIGNAL sw_tb           : std_logic_vector(7 DOWNTO 0) := "00000000";
	SIGNAL sw9_tb          : std_logic                    := '0';
   SIGNAL data_tb         : std_logic                    := '1';
   -- Outputs
   SIGNAL hex0_tb   : std_logic_vector(6 DOWNTO 0);
   SIGNAL hex1_tb   : std_logic_vector(6 DOWNTO 0);
   

   -- signals for test bench control
   SIGNAL sim_done : boolean := false;
   SIGNAL PERIOD_c : time    := 20 ns;  -- 50MHz

BEGIN  -- test

   -- component instantiation
   UUT : Receiver_TOP_level
      PORT MAP (
         clk           => clk_tb,
         reset_n       => reset_n_tb,
	 sw9           => sw9_tb,
	 data_line       => data_tb,
	 Switches            => sw_tb,
         key          => key2_tb,   
         --
         hex0            => hex0_tb,
         hex1            => hex1_tb
        
         );

   -- This creates an clock_50 that will shut off at the end of the Simulation
   -- this makes a clock_50 that you can shut off when you are done.
   clk_tb <= NOT clk_tb AFTER PERIOD_C/2 WHEN (NOT sim_done) ELSE '0';


   ---------------------------------------------------------------------------
   -- NAME: Stimulus
   --
   -- DESCRIPTION:
   --    This process will apply stimulus to the UUT.
   ---------------------------------------------------------------------------
   stimulus : PROCESS
   BEGIN
      -- de-assert all input except the reset which is asserted
      reset_n_tb     <= '0';
	   key2_tb        <= '1';
      sw_tb          <= x"FF";
	   sw9_tb         <= '1';

      -- now lets sync the stimulus to the clock_50
      -- move stimulus 1ns after clock edge
      WAIT UNTIL clk_tb = '1';
      WAIT FOR 1 ns;
      WAIT FOR PERIOD_c*2;

      -- de-assert reset
      reset_n_tb <= '1';
      WAIT FOR PERIOD_c*2;
--first reception
      WAIT FOR PERIOD_c*100;
      key2_tb <= '0';
      WAIT FOR PERIOD_c*10;
	   key2_tb <= '1';
      WAIT FOR PERIOD_c*100;
      data_tb <= '0';
	   wait for PERIOD_c*50;
      for i in 0 to 7 loop
	      data_tb <= not(data_tb);
		  wait for PERIOD_c*50;
	   end loop;
	   data_tb <= '1';
	   wait for PERIOD_c*50;
	   sw9_tb <= '0';
	   wait for PERIOD_c *30;
		
--second reception
 --reset_n_tb     <= '0';
 --WAIT FOR PERIOD_c*2;
  --reset_n_tb     <= '1';
		sw9_tb <= '1';
      sw_tb <= x"34";
      WAIT FOR PERIOD_c*100;
      key2_tb <= '0';
      WAIT FOR PERIOD_c*10;
	   key2_tb <= '1';
      WAIT FOR PERIOD_c*100;
      data_tb <= '0';
	   wait for PERIOD_c*150;
      data_tb <= '1';
	   wait for PERIOD_c*50;
		data_tb <= '0';
	   wait for PERIOD_c*100;
		data_tb <= '1';
	   wait for PERIOD_c*100;
		data_tb <= '0';
	   wait for PERIOD_c*50;
	   data_tb <= '1';
	   wait for PERIOD_c*50;
	   sw9_tb <= '0';
	   wait for PERIOD_c *30;


      sim_done <= true;
      WAIT FOR PERIOD_c*1;

      
		report "this is not a self-checking testbench.  You need to verify your waveform results.";
		report "The first reception should display AA for encrypted data and 55 for decrypted data";
		report "The second transmission should display 26 for encrypted data and 12 for decrypted data";
		
		-----------------------------------------------------------------------
      -- This Last WAIT statement needs to be here to prevent the PROCESS
      -- sequence from re starting.
      -----------------------------------------------------------------------
      WAIT;

   END PROCESS stimulus;



END test;

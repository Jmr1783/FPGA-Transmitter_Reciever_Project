library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity FSM is
   port(Clk,Reset_n,Key1,Key2,Delay: in std_logic;
        CNT : in std_logic;
        Encrypt_EN, Delay_EN, Shift_EN, Load_EN: out std_logic;
        Transmit_OUT_Bit_Selector : out std_logic_vector(1 downto 0));
end FSM;
 

architecture Behavioral of FSM is
TYPE state_type IS (Data,Key_IN,ELS,Transmit);
SIGNAL current_state, next_state: state_type;
 
BEGIN   

sync: process(clk, reset_n)
    BEGIN
        if(reset_n = '0') then
            current_state <= Data;
        elsif (rising_edge(clk)) then
            current_state <= next_state;
        END IF;
End PROCESS;

comb: PROCESS(current_state,key1,key2,delay,cnt)
  BEGIN
    CASE(current_state) IS
    When Data =>
        if (Key1 = '0') then next_state <= Key_IN;
        else next_state <= Data;
        end if;
    When Key_IN =>
        if (Key2 = '0') then next_state <= ELS;
        else next_state <= Key_IN;
        end if;
    When ELS =>
        IF(Delay = '1') then next_state <= Transmit;
        else next_state <= ELS;
        end if;
    When Transmit => 
        if (CNT = '1') then next_state <= Data;
        else next_state <= Transmit;
        end if;
    When others => next_state <= Data;
    END CASE;
End PROCESS;

Encryption: PROCESS(current_state) BEGIN
    CASE(current_state) IS
    When ELS => Encrypt_EN <= '1';
    When others => Encrypt_EN <= '0';
    END Case;
END PROCESS;

Delay_Unit:PROCESS(current_state) BEGIN
    CASE(current_state) IS
    When ELS => Delay_EN <= '1';
    When Transmit => Delay_EN <= '1';
    When others => Delay_EN <= '0';
    END Case;
END PROCESS;

Shift_Reg:PROCESS(current_state) BEGIN
    CASE(current_state) IS
    When Transmit => Shift_EN <= '1';
    When others => Shift_EN <= '0';
    END Case;
END PROCESS;

Load_Shift:PROCESS(current_state) BEGIN
    CASE(current_state) IS
    When ELS => Load_EN <= '1';
    When others => Load_EN <= '0';
    END Case;
END PROCESS;

Transmition:PROCESS(current_state) BEGIN
    CASE(current_state) IS
    When ELS => Transmit_OUT_Bit_Selector <= "00";
    When Transmit => Transmit_OUT_Bit_Selector <= "10";
    When others => Transmit_OUT_Bit_Selector <= "01";
    END Case;
END PROCESS;

end Behavioral;
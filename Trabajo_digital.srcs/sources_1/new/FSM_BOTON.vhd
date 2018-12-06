----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Alejandro Campanero
-- 
-- Create Date: 26.11.2018 20:08:40
-- Design Name: 
-- Module Name: FSM_BOTON - Behavioral
-- Project Name: Trabajo_digital
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FSM_BOTON is
    Port (
	clk            : in std_logic;
	reset          : in std_logic;
	IB             : in std_logic;         -- Intervalo Basico
	S              : in std_logic;         -- Salida antirebotes
	ALT_NAVE       : out std_logic_vector (1 downto 0)
);    
end FSM_BOTON;

architecture Behavioral of FSM_BOTON is

    -- 1  -> pulsacion larga simple
    -- 11 -> larga doble
    -- 0  -> corta simple
    -- 00 -> corta doble

    type state_t        is (S_DOWN, S_MIDDLE,S_UP, S_1, S_11, S_0, S_00, S_RIS_1, S_FALL, S_RIS_2);
    signal state        : state_t;
    signal T_05_INI     : std_logic;
    signal T_05_FIN     : std_logic;

begin

    maquina_estados: process(clk, reset)
  
    begin
  
        if reset = '1' then 
             
            state <= S_DOWN;
          
        elsif clk'event and clk = '1' then
      
        case state is
          
            when S_DOWN =>
                  if S = '1' then   
                      state <= S_RIS_1; 
                  end if;
                   
            when S_RIS_1 =>
                    if IB = '1' then
                        state <= S_UP;
                    elsif T_05_FIN = '1' then
                        state <= S_1;   
                    elsif S = '0' then
                        state <= S_FALL;
                    end if;
                  
            when S_FALL =>
                    if IB = '1' then
                         state <= S_MIDDLE;
                    elsif T_05_FIN = '1' then
                        state <= S_0;
                    elsif S = '1' then
                        state <= S_RIS_2;
                    end if;
                    
            when S_RIS_2 =>
                    if IB = '1' then
                         state <= S_1;
                    elsif T_05_FIN = '1' then
                        state <= S_11;
                    elsif S = '0' then
                        state <= S_00;
                    end if;   
                                  
            when S_00 =>
                    if IB = '1' then
                         state <= S_0;
                    end if;          
                      
            when S_11 =>
                    if IB = '1' then
                         state <= S_1;
                    end if;          
            
            when S_0 =>
                    if IB = '1' then
                         state <= S_MIDDLE;
                    end if; 
            
            when S_1 =>
                    if IB = '1' then
                         state <= S_UP;
                    end if;
                    
            when S_UP =>
                    if IB = '1' then
                         state <= S_MIDDLE;
                    end if;

            when S_MIDDLE =>
                    if IB = '1' then
                         state <= S_DOWN;
                    end if;       
                  
          end case;
          
      end if;
      
end process;
  
  -- Salidas de la maquina de estados
  T_05_INI <= '1' when ((state = S_DOWN) and (IB = '0') and (S = '1') and (T_05_FIN = '0')) else '0';
  ALT_NAVE <= "00" when (state = S_RIS_1) or (state = S_FALL) or (state = S_RIS_2) or (state = S_DOWN)
         else "01" when (state = S_00) or (state = S_0) or (state = S_MIDDLE)
         else "10" when (state = S_11) or (state = S_1) or (state = S_UP);
         
         

end Behavioral;

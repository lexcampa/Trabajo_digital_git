----------------------------------------------------------------------------------
-- Company: 
-- Engineer-- Alejandro Campanero
-- Create Date: 05.12.2018 19:24:10
-- Design Name: 
-- Module Name: FSM_OBS - Behavioral
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

entity FSM_OBS is
    Port(
    clk             :in std_logic;
    reset           :in std_logic;
    IB              :in std_logic;
    NUM_RANDOM      :in std_logic_vector(2 downto 0);
    S_OBS           :out std_logic_vector(1 downto 0);
    SIG             :out std_logic
);    
    
end FSM_OBS;

architecture Behavioral of FSM_OBS is

    --  NUM_RANDOM
    --  000 -> Nada
    --  001 -> Nada
    --  010 -> Bajo Simple
    --  011 -> Caja Simple
    --  100 -> Bajo Doble
    --  101 -> Caja Doble
    
    --  S_OBS
    --  00  -> Nada
    --  01  -> Bajo
    --  10  -> Caja
    
    type state_t        is (S_NADA, S_NADAx2, S_BAJOx1, S_BAJOx2, S_CAJAx1, S_CAJAx2);
    signal state        : state_t;

begin

    maquina_estados: process(clk, reset)
    
    begin
    
        if reset = '1' then
            
            state <= S_NADA;
            
        elsif clk'event and clk = '1' then
            
            case state is
            
            when S_NADA =>
                if NUM_RANDOM = "100" and IB = '1' then
                    state <= S_BAJOx2;
                elsif NUM_RANDOM = "010" and IB = '1' then
                    state <= S_BAJOx1;
                elsif NUM_RANDOM = ("000" or "001") and IB = '1' then
                    state <= S_NADAx2;
                elsif NUM_RANDOM = "011" and IB = '1' then
                    state <= S_CAJAx1;
                elsif NUM_RANDOM = "101" and IB = '1' then
                    state <= S_CAJAx2;
                end if;
                
            when S_BAJOx2 =>
                if IB = '1' then
                    state <= S_BAJOx1;
                end if;
            
            when S_BAJOx1 =>
                if IB = '1' then
                    state <= S_NADA;
                end if;
            
            when S_NADAx2 =>
                if IB = '1' then
                    state <= S_NADA;
                end if;
            
            when S_CAJAx1 =>
                if IB = '1' then
                    state <= S_NADAx2;
                end if;
            
            when S_CAJAx2 =>
                if IB = '1' then
                    state <= S_CAJAx1;
                end if;
                
            end case;
                
        end if;
        
    end process;
    
    S_OBS <= "00" when (state = S_NADA) or (state = S_NADAx2)
        else "01" when (state = S_BAJOx1) or (state = S_BAJOx2)
        else "10" when (state = S_CAJAx1) or (state = S_CAJAx2);
        
    SIG <= '1' when (state = S_NADA) and IB = '1' and NUM_RANDOM = ("000" or "001");


end Behavioral;

----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/20/2019 09:52:31 PM
-- Design Name: 
-- Module Name: uart_tx - Behavioral
-- Project Name: 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity uart_tx is
    Port (
        clk, en, send, rst  : in std_logic;
        char                : in std_logic_vector (7 downto 0);
        ready, tx           : out std_logic
    );
end uart_tx;

architecture Behavioral of uart_tx is
    --State machine signals
    type state_type is (idle, start, sending, stop);
    signal current_state : state_type := idle;
    signal next_state : state_type;
    
    --Sending and recieving data
    signal send_buffer : std_logic_vector(7 downto 0);
    signal send_count : integer;
    signal chip_enable : std_logic;
    signal load : std_logic := '0';
    signal output : std_logic := '1';
begin

--Chip enable
chip_enable <= clk and en;
tx <= output;

with current_state select
    ready <= '1' when idle,
             '0' when others;

state_machine : process(en, send, clk, rst)
begin
    if(rising_edge(clk)) then
    if(rst = '1') then
        current_state <= idle;
        output <= '1';
        send_count <= 0;
        send_buffer <= (others => '0'); 
    elsif(en = '1') then
        case current_state is
            when idle =>
                output <= '1';
                send_count <= 0;
                
                if(send = '1') then
                    --Time to send
                    current_state <= start;
                    send_buffer <= char;
                else
                    current_state <= idle;
                end if;
            when start =>
                output <= '0';
                current_state <= sending;
                send_count <= 0;
            when sending =>
                if(send_count < 8) then
                    output <= send_buffer(send_count);
                    send_count <= send_count + 1;
                    current_state <= sending;
                else
                    output <= '1';
                    current_state <= stop;
                end if;
            when stop =>
                output <= '1';
                current_state <= idle;
                send_count <= 0;
            when others =>
                current_state <= current_state;
        end case;
    end if;
    end if;
end process;

end Behavioral;

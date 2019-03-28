----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/21/2019 02:54:11 AM
-- Design Name: 
-- Module Name: sender - Behavioral
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

entity sender is
    Port ( btn : in STD_LOGIC;
           clk : in STD_LOGIC;
           en : in STD_LOGIC;
           rdy : in STD_LOGIC;
           rst : in STD_LOGIC;
           send : out STD_LOGIC;
           char : out STD_LOGIC_VECTOR (7 downto 0));
end sender;

architecture Behavioral of sender is

    --NETID data
    type NETID_ARRAY is array (5 downto 0) of std_logic_vector(7 downto 0);
    signal NETID : NETID_ARRAY := (x"39", x"31",x"31",x"61",x"63",x"61");
    constant n : integer := 6;
    signal i : std_logic_vector(2 downto 0) := (others => '0');
    
    --FSM Data
    type state_type is (idle, busyA, busyB, busyC);
    signal current_state : state_type := idle;
    signal next_state : state_type := idle;
    
    
begin
    
    state_machine : process(clk, en, btn, rdy, rst)
    begin
        if(rising_edge(clk)) then   
            if(rst = '0' and en = '1') then
                case current_state is
                    when idle =>
                        if (rdy = '1' and btn = '1') then
                            if(to_integer(unsigned(i)) < n) then
                                send <= '1';
                                char <= NETID(to_integer(unsigned(i)));
                                i <= std_logic_vector(unsigned(i) + 1);
                                current_state <= busyA;
                            else
                                send <= '0';
                                current_state <= idle;
                                i <= (others => '0');
                            end if;
                        else
                            send <= '0';
                        end if;               
                    when busyA =>
                        send <= '1';
                        current_state <= busyB;
                    when busyB =>
                        send <= '0';
                        current_state <= busyC;
                    when busyC =>
                        send <= '0';
                        if(rdy = '1' and btn = '0') then
                            current_state <= idle;
                        else
                            current_state <= busyC;
                        end if;
                when others =>
                    send <= '0';
                    current_state <= current_state;
                end case;
                
            --HANDLE A RESET
            elsif(rst = '1' and en = '1') then
                send <= '0';
                char <= (others => '0');           
                i <= (others => '0');
                current_state <= idle;
            end if;
        end if;
    end process;
    

end Behavioral;

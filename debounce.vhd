----------------------------------------------------------------------------------
-- Company: DEBOUNCE
-- Engineer: 
-- 
-- Create Date: 02/20/2019 03:19:36 AM
-- Design Name: 
-- Module Name: debounce - Behavioral
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

entity debounce is
    Port ( btn : in STD_LOGIC;
           clk : in STD_LOGIC;
           dbnce : out STD_LOGIC);
end debounce;

architecture Behavioral of debounce is
    signal shift_register : STD_LOGIC_VECTOR (1 downto 0) := "00";
    signal counter : STD_LOGIC_VECTOR (23 downto 0) := (others => '0');
    signal sampled_button_value : STD_LOGIC := '0';
    signal output : STD_LOGIC := '0';
    signal shift_in : STD_LOGIC;
begin
    --tie things together
    sampled_button_value <= shift_register(1);
    dbnce <= output;
    
    --Sample the button
    button_sample : process(clk)
    begin
        if(rising_edge(clk)) then
            --Check if the button was pressed
            shift_register(1) <= shift_register(0);
            
            if(btn = '1') then
                --Button pressed
                shift_in <= '1';
            else
                shift_in <= '0';
            end if;
            
            shift_register(0) <= shift_in;
            --Shift the register
            --shift_register <= std_logic_vector(unsigned(shift_register) sll 1);
            
        end if;
    end process;
    
    --Increment the counter
    debounce : process(clk, sampled_button_value)
    begin
        if(rising_edge(clk)) then     
            --increment the counter
            if(sampled_button_value = '1') then
                --If the output is already high we shouldn't increment the counter further
                if(output = '0') then
                    counter <= std_logic_vector(unsigned(counter) + 1);
                end if;
            else
                --If the sampled value ever goes to 0, reset the counter
                counter <= (others => '0');
            end if;
        end if;
    end process;
    
    --Have we reached the threshold?
    counter_increment : process(counter)
    begin
        --Have we reached the threshold?
        if(unsigned(counter) > 2499999) then
            output <= '1';
        else
            output <= '0';
        end if;
    end process;
    

end Behavioral;

----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/27/2019 09:22:25 PM
-- Design Name: 
-- Module Name: top_level_tb - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_level_tb is

end top_level_tb;

architecture Behavioral of top_level_tb is

--Declare components
component uart is
    Port (

    clk, en, send, rx, rst      : in std_logic;
    charSend                    : in std_logic_vector (7 downto 0);
    ready, tx, newChar          : out std_logic;
    charRec                     : out std_logic_vector (7 downto 0));
end component;

component sender is
    Port ( btn : in STD_LOGIC;
           clk : in STD_LOGIC;
           en : in STD_LOGIC;
           rdy : in STD_LOGIC;
           rst : in STD_LOGIC;
           send : out STD_LOGIC;
           char : out STD_LOGIC_VECTOR (7 downto 0));
end component;

component clock_div is
    Port ( clk : in STD_LOGIC;
           div : out STD_LOGIC);
end component;

--signals
--Signals
signal btn : std_logic := '0';
signal slowed_clock : std_logic;
signal ready, send : std_logic;
signal charSend : std_logic_vector (7 downto 0);
signal clk : std_logic := '0';
signal tx, newChar : std_logic;
signal charRec : std_logic_vector (7 downto 0);

begin

divider : clock_div port map (clk, slowed_clock);
uart_device: uart port map (clk, slowed_clock, send, '0', '0', charSend, ready, tx, newChar, charRec);
send_device : sender port map (btn, clk, slowed_clock, ready, '0', send, charSend); 

clock : process
begin
    clk <= not clk;
    wait for 4 ns;
end process;



main : process
begin
    wait for 1 ms;
    btn <= '1';
    wait for 30 ms;
    btn <= '0';
end process;

end Behavioral;

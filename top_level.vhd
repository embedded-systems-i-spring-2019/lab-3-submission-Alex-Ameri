----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/21/2019 03:56:19 AM
-- Design Name: 
-- Module Name: top_level - Behavioral
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

entity top_level is
    Port ( TXD : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR(1 downto 0);
           clk : in STD_LOGIC;
           CTS : out STD_LOGIC;
           RTS : out STD_LOGIC;
           RXD : out STD_LOGIC);
end top_level;

architecture Behavioral of top_level is

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

component debounce is
    Port ( btn : in STD_LOGIC;
           clk : in STD_LOGIC;
           dbnce : out STD_LOGIC);
end component;

--Signals
signal debounce0, debounce1, slowed_clock : std_logic;
signal ready, send : std_logic;
signal charSend : std_logic_vector (7 downto 0);

begin
    --Instantiate components
    u1 : debounce port map (btn(0), clk, debounce0);
    u2 : debounce port map (btn(1), clk, debounce1);
    u3 : clock_div port map (clk, slowed_clock);
    u4 : sender port map (debounce1, clk, slowed_clock, ready, debounce0, send, charSend); 
    u5 : uart port map (clk, slowed_clock, send, TXD, debounce0, charSend, ready, RXD, open, open);
    
    CTS <= '0';
    RTS <= '0';

end Behavioral;

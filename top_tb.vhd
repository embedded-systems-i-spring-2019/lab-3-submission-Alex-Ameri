----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/28/2019 01:05:02 AM
-- Design Name: 
-- Module Name: top_tb - Behavioral
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

entity top_tb is
   -- Port (clk : in std_logic);
end top_tb;

architecture Behavioral of top_tb is
    component top_level is
    Port ( TXD : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR(1 downto 0);
           clk : in STD_LOGIC;
           CTS : out STD_LOGIC;
           RTS : out STD_LOGIC;
           RXD : out STD_LOGIC);
    end component;
    
    signal txd : std_logic := '0';
    signal btn : std_logic_vector (1 downto 0);
    signal CTS : std_logic := '0';
    signal RTS : std_logic := '0';
    signal RXD : std_logic;
    signal clk : std_logic := '0';
    
begin
    btn(0) <= '0';
    top : top_level port map(txd, btn, clk, CTS, RTS, RXD);
    
    clock: process begin
        wait for 4 ns;
        clk <= not clk;
    end process;
    
    main: process begin
        wait for 1 ms;
        btn(1) <= '1';
        wait for 3 ms;
        btn(1) <= '0';
        wait for 1 ms;
    end process;
    
end Behavioral;

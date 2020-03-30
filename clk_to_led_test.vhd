----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/16/2020 04:49:44 PM
-- Design Name: 
-- Module Name: clk_to_led_test - Behavioral
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

entity clk_to_led_test is
    Port ( clk : in STD_LOGIC;
           swv16 : in STD_LOGIC;
           ledu16 : out STD_LOGIC;
           lede19 : out STD_LOGIC);
end clk_to_led_test;

architecture Behavioral of clk_to_led_test is

begin
ledu16 <= clk or swv16;
lede19 <= clk and swv16;


end Behavioral;

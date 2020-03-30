----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 02/20/2020 04:17:46 PM
-- Design Name:
-- Module Name: framebuffer - Behavioral
-- Project Name:
-- Target Devices:
-- Tool Versions:
-- Description: Stores decoded picture information to be retransmitted or scaled
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

constant res_x : natural := 640;
constant res_y : natural := 480;
constant color_depth : natural := 8;    -- per-channel color depth

entity Framebuffer is
    Port ( clk          : in std_logic;
           write_enable : in std_logic;

           write_addr_x : in natural range 0 to res_x - 1;
           write_addr_y : in natural range 0 to res_y - 1;
           read_addr_x  : in natural range 0 to res_x - 1;
           read_addr_y  : in natural range 0 to res_y - 1;

           r_in         : in STD_LOGIC_VECTOR (color_depth - 1 downto 0);
           g_in         : in STD_LOGIC_VECTOR (color_depth - 1 downto 0);
           b_in         : in STD_LOGIC_VECTOR (color_depth - 1 downto 0);
           r_out        : out STD_LOGIC_VECTOR (color_depth - 1 downto 0);
           g_out        : out STD_LOGIC_VECTOR (color_depth - 1 downto 0);
           b_out        : out STD_LOGIC_VECTOR (color_depth - 1 downto 0)
           );
end Framebuffer;

architecture Behavioral of Framebuffer is

    type framebuffer_arr is array (0 to (res_x * res_y) - 1) of STD_LOGIC_VECTOR ((color_depth * 3) - 1 downto 0);
    signal buff         : framebuffer_arr;
    signal write_addr   : natural range 0 to (res_x * res_y) - 1;
    signal read_addr    : natural range 0 to (res_x * res_y) - 1;

begin
    -- find array index based on desired x/y
    write_addr <= write_addr_x * res_x + write_addr_y;
    read_addr  <= read_addr_x  * res_x + read_addr_y;

    process(clk)
    begin
        -- write only on the clock edge
        if rising_edge(clk) then
            if write_enable then
                buff(write_addr) <= r_in & g_in & b_in
            end if;
        end if;
    end process;

    -- read out the given pixel
    r_out <= buff(read_addr)((color_depth * 3) - 1 downto color_depth * 2);
    g_out <= buff(read_addr)((color_depth * 2) - 1 downto color_depth);
    b_out <= buff(read_addr)(color_depth - 1 downto 0);

end Behavioral;

-- Contains and drives counters that will iterate over the rows of a frame,
-- outputing hsync/vsync signals during the blanking period. This is intended
-- to be a basic building block in video signal generation.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity framedriver is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           hsync : out STD_LOGIC;
           vsync : out STD_LOGIC;
           active: out STD_LOGIC;
           frame_row : out STD_LOGIC_VECTOR (11 downto 0);
           frame_col : out STD_LOGIC_VECTOR (11 downto 0));
end framedriver;

architecture Behavioral of framedriver is
    -- the width and height of the visible screen
    constant frame_width  :natural := 640;
    constant frame_height : natural := 480;
    
    -- column where hsync begins and ends
    constant hsync_start : natural := 656;
    constant hsync_end   : natural := 752;
    
    -- row where vsync begins and ends
    constant vsync_start : natural := 490;
    constant vsync_end   : natural := 492;
    
    -- the full transmitted resolution, including the visible area and the front/back porch.
    constant frame_height_full : natural := 525;
    constant frame_width_full  : natural := 800;
    
    -- counts the current pixel to be shown
    signal counter_row : natural range 0 to (frame_height_full - 1) := 0;
    signal counter_col : natural range 0 to (frame_width_full - 1) := 0;
begin    
    -- set up logic for hsync/vsync
    hsync <= '1' when (hsync_start <= counter_col and counter_col < hsync_end) else '0';
    vsync <= '1' when (vsync_start <= counter_row and counter_row < vsync_end) else '0';
    
    -- set up logic for active display
    active <= '1' when (counter_col < frame_width and counter_row < frame_height) else '0';
    
    -- push the row and column to the output
    frame_col <= std_logic_vector(to_unsigned(counter_col, frame_col'length));
    frame_row <= std_logic_vector(to_unsigned(counter_row, frame_row'length));
    
    process(clk)
    begin
        if rising_edge(clk) then
            -- iterate (or reset) the row/column counters
            if counter_col = (frame_width_full - 1) then
                counter_col <= 0;
                
                -- when the column resets, iterate the row
                if counter_row = (frame_height_full - 1) then
                    counter_row <= 0;
                else
                    counter_row <= counter_row + 1;
                end if;
            else
                counter_col <= counter_col + 1;
            end if;
        end if;
    end process;
    
end Behavioral;

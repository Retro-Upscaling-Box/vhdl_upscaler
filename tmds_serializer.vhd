-- Takes a parallel 10-bit TMDS signal and serializes it.
-- Input clk should be 5x the pixel clock.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tmds_serializer is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           tmds_p : in STD_LOGIC_VECTOR (9 downto 0);
           tmds_s : out STD_LOGIC);
end tmds_serializer;

architecture Behavioral of tmds_serializer is
    signal clk_count : integer range 0 to 9;
begin

process(clk, rst)
begin
    if rst = '1' then
        clk_count <= 0;
        tmds_s <= '0';
    else
        tmds_s <= tmds_p(clk_count);
        
        if clk_count < 9 then
            clk_count <= clk_count + 1;
        else
            clk_count <= 0;
        end if;
    end if;
end process;


end Behavioral;

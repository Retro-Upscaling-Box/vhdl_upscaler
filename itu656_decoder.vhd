----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/20/2020 04:17:46 PM
-- Design Name: 
-- Module Name: itu656_decoder - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: This package takes signal from the ADV7280AEBZ board and decodes it into
--              a usable signal that we can then later manipulate to upscale.
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

entity itu656_decoder is
    Port ( pmod_in : in STD_LOGIC_VECTOR (7 downto 0); -- ITU-R BT.656
           clk : in STD_LOGIC; --27MHz
           decode_out : in STD_LOGIC_VECTOR (7 downto 0);
           C_b_out : out STD_LOGIC_VECTOR (7 downto 0);
           C_r_out : out STD_LOGIC_VECTOR (7 downto 0);
           Y_1_out : out STD_LOGIC_VECTOR (7 downto 0);
           Y_2_out : out STD_LOGIC_VECTOR (7 downto 0);
           line_num : out natural;
           col_num : out natural
           ); 
end itu656_decoder;

architecture Behavioral of itu656_decoder is

    SIGNAL clk_counter : natural RANGE 0 to 3 := 0;
    SIGNAL C_b, Y_1, C_r, Y_2 : std_logic_vector (7 downto 0);
    SIGNAL is_active : std_logic := '0';
    
begin
 
 process(clk)
 begin
    if rising_edge(clk) then
        C_b <= Y_1;
        Y_1 <= C_r;
        C_r <= Y_2;
        Y_2 <= pmod_in;
        
        
        if clk_counter = 3 then
            clk_counter <= 0;
            if C_b = "11111111" and Y_1 = "00000000" and C_r = "00000000" then -- Checks for timing signal
                if Y_2(4) = '0' then -- Start of active video
                    is_active <= '1';
                else -- End of active video
                    is_active <= '0';
                end if;
            elsif is_active = '1' then
                C_b_out <= C_b;
                C_r_out <= C_r;
                Y_1_out <= Y_1;
                Y_2_out <= Y_2;
            else 
            
            end if;
        else
            clk_counter <= clk_counter + 1;
        end if; 
    end if;   
 end process;

end Behavioral;

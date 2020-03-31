-- This is  Transition-Minimized Differential Signaling Encoder made using
-- version 1.0 of the DVI spec as reference. This encoding is used in DVI
-- and HDMI connections. DVI spec can be found here:
-- http://www.cs.unc.edu/Research/stc/FAQs/Video/dvi_spec-V1_0.pdf

-- Author: Gage Phillips


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tmds_encoder is
    Port ( data : in STD_LOGIC_VECTOR (7 downto 0);
           control : in STD_LOGIC_VECTOR (1 downto 0);
           clk : in STD_LOGIC;
           en : in STD_LOGIC;
           tmds : out STD_LOGIC_VECTOR (9 downto 0)
           );
end tmds_encoder;

architecture Behavioral of tmds_encoder is
    signal data_in : STD_LOGIC_VECTOR (8 downto 0);
    signal stream_disparity : integer;
    
    function count(X : STD_LOGIC_VECTOR; C : STD_LOGIC) return integer is
        variable num : integer := 0;
    begin
        for i in 0 to 7 loop
            if (X(i) = '1' and C = '1') or (X(i) = '0' and C = '0') then
                num := num + 1;
            end if;
        end loop;
        return num;
    end count;
begin
    process(clk)
        variable num_ones : integer range 0 to 8 := 0;
        variable num_zeros: integer range 0 to 8 := 0;
    begin
        if rising_edge(clk) then
            num_ones := count(data, '1');
            
            data_in(0) <= '0';
            if num_ones > 4 or data(0) = '0' then
                for i in 1 to 7 loop
                    data_in(i) <= data_in(i - 1) xnor data_in(i);
                end loop;
                data_in(8) <= '0';
            else
                for i in 1 to 7 loop
                    data_in(i) <= data_in(i - 1) xor data_in(i);
                end loop;
                data_in(8) <= '1';
            end if;
            
            num_ones := count(data_in, '1');
            num_zeros := 8 - num_ones;
            if en = '1' then                
                if stream_disparity = 0 or num_ones = 4 then
                    tmds(9) <= not data_in(8);
                    tmds(8) <= data_in(8);
                    if data_in(8) = '1' then
                        tmds(7 downto 0) <= data_in(7 downto 0);
                    else
                        tmds(7 downto 0) <= not data_in(7 downto 0);
                    end if;
                    
                    if data_in(8) = '0' then
                        stream_disparity <= stream_disparity + (num_zeros - num_ones);
                    else
                        stream_disparity <= stream_disparity + (num_ones - num_zeros);
                    end if;
                else
                    if (stream_disparity > 0 and num_ones > num_zeros) or (stream_disparity < 0 and num_zeros > num_ones) then
                        tmds(9) <= '1';
                        tmds(8) <= data_in(8);
                        tmds(7 downto 0) <= not data_in(7 downto 0);
                        if data_in(8) = '1' then
                            stream_disparity <= stream_disparity + 2 + (num_zeros - num_ones);
                        else
                            stream_disparity <= stream_disparity + (num_zeros - num_ones);
                        end if;
                    else
                        tmds(9) <= '0';
                        tmds(8) <= data_in(8);
                        tmds(7 downto 0) <= data_in(7 downto 0);
                        if data_in(8) = '1' then
                            stream_disparity <= stream_disparity + (num_zeros - num_ones);
                        else
                            stream_disparity <= stream_disparity - 2 + (num_zeros - num_ones);
                        end if;
                    end if;
                end if;
            else
                -- issue control word
                stream_disparity <= 0;
                case control is
                    -- read C1 then C0
                    when "00" => tmds <= "1101010100";
                    when "01" => tmds <= "0010101011";
                    when "10" => tmds <= "0101010100";
                    when "11" => tmds <= "1010101011";
                end case;
            end if;
        end if;
    end process;

end Behavioral;

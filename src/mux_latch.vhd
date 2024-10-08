library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity mux_latch is
  port (
    clk         : in std_logic;
    in_a        : in std_logic_vector (11 downto 0);
    in_b        : in std_logic_vector (11 downto 0);
    o           : out std_logic_vector (12 downto 0);
    sel0, sel1  : in std_logic
  );
end mux_latch;

architecture Behavioral of mux_latch is

begin
  process (clk) begin
    if (clk'event and clk = '1' and sel0 = '1') then
      if (sel1 = '1') then
        o <= '0' & in_a;
      else
        o <= '1' & in_b;
      end if;
    end if;

  end process;

end Behavioral;

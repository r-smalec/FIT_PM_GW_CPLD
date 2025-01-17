--  module to generate output signal
--  that is clk frequency divided by two


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_MISC.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity cnt2 is
  port (
    clk    : in std_logic;
    o : out std_logic_vector (1 downto 0)
  );
end cnt2;

architecture Behavioral of cnt2 is
  signal tmp : std_logic_vector (1 downto 0) := (others => '0');

begin
  process (clk) begin
    if falling_edge(clk) then
       tmp <= tmp+1;
    end if;
  end process;
  
  o <= tmp;

end Behavioral;

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
  signal tmp : std_logic_vector (1 downto 0);

begin
  process (clk) begin
    if (clk'event and clk = '0') then
        tmp <= tmp;
    end if;
  end process;
  
  o <= tmp;

end Behavioral;

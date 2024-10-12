library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cnt2_tb is
end;

architecture bench of cnt2_tb is
  -- Clock period
  constant CLK_PERIOD : time := 10 ns;
  -- Generics
  -- Ports
  signal clk : std_logic;
  signal o : std_logic_vector (1 downto 0);
begin

  cnt2_inst : entity work.cnt2
  port map (
    clk => clk,
    o => o
  );

  clock_gen: process begin
      
    for i in 0 to 9 loop
      clk <= '0';
      wait for CLK_PERIOD / 2;  -- Low phase of the clock
      clk <= '1';
      wait for CLK_PERIOD / 2;  -- High phase of the clock
      report "Cnt2 simulatoin finished";
    end loop;
    wait;
end process;


end;
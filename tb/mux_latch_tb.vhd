
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_latch_tb is
end;

architecture bench of mux_latch_tb is
  -- Clock 
  constant CLK_PERIOD : time := 10 ns;
  -- Generics
  -- Ports
  signal clk : std_logic;
  signal in_a : std_logic_vector (11 downto 0);
  signal in_b : std_logic_vector (11 downto 0);
  signal o : std_logic_vector (12 downto 0);
  signal sel0 : std_logic;
  signal sel1 : std_logic;

  signal clk_gen_en : boolean := true;
  signal sel : std_logic_vector (1 downto 0);
begin

  mux_latch_inst : entity work.mux_latch
  port map (
    clk => clk,
    in_a => in_a,
    in_b => in_b,
    o => o,
    sel0 => sel0,
    sel1 => sel1
  );

    clock_gen: process begin
        
        while clk_gen_en loop
            clk <= '0';
            wait for CLK_PERIOD/2;
            clk <= '1';
            wait for CLK_PERIOD/2;
        end loop;
        report "Mux latch simulatoin finished";
        wait;
    end process;

    stimulus: process begin
        in_a <= x"0A2";
        in_b <= x"B10";
        sel <= "00";
        wait for CLK_PERIOD*2;
        sel <= "01";
        wait for CLK_PERIOD*2;
        sel <= "10";
        wait for CLK_PERIOD*2;
        sel <= "11";
        wait for CLK_PERIOD*2;
        clk_gen_en <= false;
        wait;
    end process;

    sel0 <= sel(0);
    sel1 <= sel(1);

end;
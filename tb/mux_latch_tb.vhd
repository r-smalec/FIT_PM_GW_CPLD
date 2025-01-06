
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_latch_tb is
end;

architecture bench of mux_latch_tb is
  -- Clock 
  constant CLK_PERIOD : time := 12.5 ns;
  -- Generics
  -- Ports
  signal clk : std_logic;
  signal in_a : std_logic_vector (11 downto 0);
  signal in_b : std_logic_vector (11 downto 0);
  signal o : std_logic_vector (12 downto 0);
  signal sel0 : std_logic;
  signal sel1 : std_logic;

  signal clk_gen_en : boolean := true;
  signal dly_6 : std_logic;
  signal cnt : std_logic_vector (1 downto 0);

  component cnt2 is
    Port ( CLK : in  STD_LOGIC;
            O : out  STD_LOGIC_VECTOR (1 downto 0)
         );
  end component;

begin

  cnt2_inst: cnt2
  port map (
    clk=>clk,
    o=>cnt
  );

  mux_latch_inst : entity work.mux_latch
  port map (
    clk => clk,
    in_a => in_a,
    in_b => in_b,
    o => o,
    sel0 => dly_6, -- dly(6) delay singal, one cycle before data valid
    sel1 => cnt(1)  -- CNT(1) 20Mhz clock for integrators
  );

  clock_gen: process begin
        
        while clk_gen_en loop
            clk <= '1';
            wait for CLK_PERIOD/2;
            clk <= '0';
            wait for CLK_PERIOD/2;
        end loop;
        report "Mux latch simulatoin finished";
        wait;
  end process;

  dly_gen: process begin
    wait until rising_edge(cnt(1));
    dly_6 <= '0';
    wait for CLK_PERIOD+CLK_PERIOD/2;
    dly_6 <= '1';
    wait for CLK_PERIOD;
    dly_6 <= '0';

    wait until falling_edge(cnt(1));
    dly_6 <= '0';
    wait for CLK_PERIOD+CLK_PERIOD/2;
    dly_6 <= '1';
    wait for CLK_PERIOD;
    dly_6 <= '0';
  end process;

  stimulus: process begin
    in_a <= x"1A1";
    in_b <= x"2B2";
    wait for CLK_PERIOD*10;
    clk_gen_en <= false;
    wait;
  end process;

end;
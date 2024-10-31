library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ampl_logic_tb is
end;

architecture bench of ampl_logic_tb is
  -- Clock period
  constant CLK_PERIOD : time := 10 ns;
  -- Generics
  -- Ports
  signal clk80      : std_logic;
  signal rstn     : std_logic;

  signal mux_in_a : std_logic_vector (11 downto 0);
  signal mux_in_b : std_logic_vector (11 downto 0);
  signal mux_out  : std_logic_vector (12 downto 0);

  signal strb     : std_logic;
  signal dv       : std_logic;
  signal en       : std_logic;
  signal evnt     : std_logic;
  signal evout    : std_logic;

  signal clk_gen_en : boolean := true;

begin

  ampl_logic_0 : entity work.ampl_logic
  port map (
    clk80 => clk80,
    rstn => rstn,

    mux_in_a => mux_in_a,
    mux_in_b => mux_in_b,
    mux_out => mux_out,

    strb => strb,
    dv => dv,
    en => en,
    evnt => evnt,
    evout => evout
  );

  clock_gen: process begin
      
    while clk_gen_en loop
      clk80 <= '0';
      wait for CLK_PERIOD/2;
      clk80 <= '1';
      wait for CLK_PERIOD/2;
    end loop;
    wait;
  end process;

  stimulus: process begin
    mux_in_a <= x"1A1";
    mux_in_b <= x"2B2";

    -- trigger using event signal
    rstn <= '0';
    strb <= '0';
    en <= '0';
    evnt <= '0';
    wait for CLK_PERIOD;
    rstn <= '1';
    en <= '0';
    evnt <= '0';
    wait for CLK_PERIOD;
    en <= '1';
    wait for CLK_PERIOD*6;
    evnt <= '1';
    wait until evout = '1';

    -- trigger using strobe signal
    wait for CLK_PERIOD*6;
    rstn <= '0';
    wait for CLK_PERIOD;
    strb <= '0';
    evnt <= '0';
    wait for CLK_PERIOD;
    rstn <= '1';
    wait for CLK_PERIOD;
    strb <= '1';
    wait for CLK_PERIOD*6;
    strb <= '0';
    wait for CLK_PERIOD*100;
    clk_gen_en <= false;

    wait;
  end process;

end;

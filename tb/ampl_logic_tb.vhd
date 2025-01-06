library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ampl_logic_tb is
end;

architecture bench of ampl_logic_tb is
  -- Clock period
  constant CLK_PERIOD : time := 12.5 ns; -- 80MHz refers to 12.5ns
  -- Generics
  -- Ports
  signal clk80      : std_logic;
  signal rstn     : std_logic;

  signal clk40      : std_logic;
  signal clk20      : std_logic;
  signal clk20n     : std_logic;

  signal mux_in_a : std_logic_vector (11 downto 0);
  signal mux_in_b : std_logic_vector (11 downto 0);
  signal mux_out  : std_logic_vector (12 downto 0);

  signal strb     : std_logic;
  signal dv       : std_logic;
  signal en       : std_logic;
  signal evnt     : std_logic;
  signal evout    : std_logic;

  signal gate_str_o : std_logic;
  signal clk_gen_en : boolean := true;

begin

  ampl_logic_0 : entity work.ampl_logic
  port map (
    clk80 => clk80,
    rstn => rstn,

    clk40 => clk40,
    clk20 => clk20,
    clk20n => clk20n,

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

  gate_delay: process (clk40) begin
    gate_str_o <= clk40 after 2 ns;
  end process;

  strb_latch: process (strb) begin
    if rstn = '0' then
      en <= '0';
    elsif rising_edge(strb) then
      en <= gate_str_o;
    end if;
  end process;

  stimulus: process begin
    mux_in_a <= x"1A1";
    mux_in_b <= x"2B2";

    -- trigger using event signal
    rstn <= '0';
    strb <= '0';
    evnt <= '0';
    wait for CLK_PERIOD;
    rstn <= '1';
    evnt <= '0';
    wait for CLK_PERIOD*2;
    evnt <= '1';
    wait until evout = '1';

    -- trigger using strobe signal
    wait for CLK_PERIOD*20;
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

    wait for CLK_PERIOD*20;
    wait for CLK_PERIOD;
    strb <= '1';
    wait for CLK_PERIOD*6;
    strb <= '0';

    wait for CLK_PERIOD*100;
    clk_gen_en <= false;

    wait;
  end process;

end;

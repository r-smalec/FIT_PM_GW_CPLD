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
  signal clk      : std_logic;
  signal rstn     : std_logic;

  signal mux_in_a : std_logic_vector (11 downto 0);
  signal mux_in_b : std_logic_vector (11 downto 0);
  signal mux_out  : std_logic_vector (12 downto 0);

  signal strb     : std_logic;
  signal enai     : std_logic;
  signal evnt     : std_logic;
  signal dly_in   : std_logic_vector (7 downto 0);

  signal cnt_out  : std_logic_vector (1 downto 0);
  signal evout    : std_logic;
  signal cal_str  : std_logic;
  signal c_count  : std_logic_vector (6 downto 0);

  signal clk40    : std_logic;
  signal clk20_p  : std_logic;
  signal clk20_n  : std_logic;

begin

  ampl_logic_0 : entity work.ampl_logic
  port map (
    clk => clk,
    rstn => rstn,

    mux_in_a => mux_in_a,
    mux_in_b => mux_in_b,
    mux_out => mux_out,

    strb => strb,
    enai => enai,
    evnt => evnt,

    dly_in => dly_in,
    cnt_out => cnt_out,
    evout => evout,
    cal_str => cal_str,
    c_count => c_count
  );

  clock_gen: process begin
      
    for i in 0 to 20 loop
      clk <= '0';
      wait for CLK_PERIOD / 2;  -- Low phase of the clock
      clk <= '1';
      wait for CLK_PERIOD / 2;  -- High phase of the clock
      report "Cnt2 simulatoin finished";
    end loop;
    wait;
  end process;

  stimulus: process begin
    mux_in_a <= x"1A1";
    mux_in_b <= x"2B2";
    dly_in <= x"01";
    rstn <= '0';
    strb <= '0';
    enai <= '0';
    evnt <= '0';
    wait for CLK_PERIOD;
    rstn <= '1';
    strb <= '1';
    enai <= '0';
    evnt <= '0';
    wait for CLK_PERIOD;
    strb <= '1';
    enai <= '1';
    evnt <= '0';
    wait for CLK_PERIOD;
    strb <= '0';
    enai <= '1';
    evnt <= '0';
    wait for CLK_PERIOD;
    strb <= '0';
    enai <= '1';
    evnt <= '1';
    wait for CLK_PERIOD*5;

    wait;
  end process;


  clk20_P <= cnt_out(1);
  clk20_N <= cnt_out(1);
  clk40 <= cnt_out(0);

end;

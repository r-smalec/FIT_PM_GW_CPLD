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

  signal cnt_out  : std_logic_vector (1 downto 0);
  signal evout    : std_logic;
  signal cal_str  : std_logic;
  signal c_count  : std_logic_vector (6 downto 0);

  signal clk40    : std_logic;
  signal clk20_p  : std_logic;
  signal clk20_n  : std_logic;

  signal clk_gen_en : boolean := true;

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

    cnt_out => cnt_out,
    evout => evout,
    cal_str => cal_str,
    c_count => c_count
  );

  clock_gen: process begin
      
    while clk_gen_en loop
      clk <= '0';
      wait for CLK_PERIOD/2;
      clk <= '1';
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
    enai <= '0';
    evnt <= '0';
    wait for CLK_PERIOD;
    rstn <= '1';
    enai <= '0';
    evnt <= '0';
    wait for CLK_PERIOD;
    enai <= '1';
    wait for CLK_PERIOD*5;
    evnt <= '1';
    wait until evout = '1';
    wait for CLK_PERIOD*100;

    -- trigger using strobe signal
    rstn <= '0';
    strb <= '0';
    enai <= '0';
    evnt <= '0';
    wait for CLK_PERIOD;
    rstn <= '1';
    enai <= '1';
    wait for CLK_PERIOD;
    strb <= '1';
    wait for CLK_PERIOD*5;
    strb <= '0';
    wait for CLK_PERIOD*20;
    clk_gen_en <= false;

    wait;
  end process;


  clk20_P <= cnt_out(1);
  clk20_N <= cnt_out(1);
  clk40 <= cnt_out(0);

end;

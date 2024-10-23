
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity amplcpld_tb is
end;

architecture bench of amplcpld_tb is
  -- Clock period
  constant clk_period : time := 12.5 ns;
  -- Generics
  -- Ports
  signal CLK80 : STD_LOGIC;
  signal STR : STD_LOGIC;
  signal ENA : STD_LOGIC;
  signal DOUT : STD_LOGIC_VECTOR (12 downto 0);
  signal ADC0 : STD_LOGIC_VECTOR (11 downto 0);
  signal ADC1 : STD_LOGIC_VECTOR (11 downto 0);
  signal CLK40 : STD_LOGIC;
  signal CLK20_P : STD_LOGIC;
  signal CLK20_N : STD_LOGIC;
  signal DV : STD_LOGIC;
  signal EV : STD_LOGIC;
  signal EV_out : STD_LOGIC;

  signal clk_gen_en : boolean := true;
begin

  amplcpld_inst : entity work.amplcpld
  port map (
    CLK80 => CLK80,
    STR => STR,
    ENA => ENA,
    DOUT => DOUT,
    ADC0 => ADC0,
    ADC1 => ADC1,
    CLK40 => CLK40,
    CLK20_P => CLK20_P,
    CLK20_N => CLK20_N,
    DV => DV,
    EV => EV,
    EV_out => EV_out
  );

clock_gen: process begin
        
    while clk_gen_en loop
      CLK80 <= '0';
        wait for CLK_PERIOD/2;
        CLK80 <= '1';
        wait for CLK_PERIOD/2;
    end loop;
    report "Simulatoin finished";
    wait;
end process;

stimulus: process begin
    ADC0 <= x"1A1";
    ADC1 <= x"2B2";
    STR <= '0';
    ENA <= '0';
    EV <= '0';
    wait for CLK_PERIOD;
    ENA <= '1';
    wait for CLK_PERIOD;
    STR <= '1';
    wait for CLK_PERIOD;
    STR <= '0';
    wait for CLK_PERIOD*5;
    EV <= '1';
    wait for CLK_PERIOD*5;
    clk_gen_en <= false;
    wait;
end process;

end;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pulse_delay_tb is
end;

architecture bench of pulse_delay_tb is
  -- Clock period
  constant clk_period : time := 5 ns;
  -- Generics
  constant DELAY_CYCLES : integer := 4;
  constant DURATION_CYCLES : integer := 4;
  -- Ports
  signal clk : std_logic;
  signal sig_in : std_logic;
  signal pulse_out : std_logic;

  signal clk_gen_en : boolean := true;
begin

  pulse_delay_inst : entity work.pulse_delay
  generic map (
    DELAY_CYCLES => DELAY_CYCLES,
    DURATION_CYCLES => DURATION_CYCLES
  )
  port map (
    clk => clk,
    sig_in => sig_in,
    pulse_out => pulse_out
  );
  clock_gen: process begin
        
        while clk_gen_en loop
            clk <= '1';
            wait for CLK_PERIOD/2;
            clk <= '0';
            wait for CLK_PERIOD/2;
        end loop;
        wait;
    end process;

    stimulus: process begin

        sig_in <= '0';
        wait for CLK_PERIOD*2;
        sig_in <= '1';
        wait until pulse_out = '0';
        clk_gen_en <= false;
        wait;
    end process;

end;
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity ampl_logic is
  port (
    clk80     : in std_logic;
    rstn      : in std_logic;

    mux_in_a  : in std_logic_vector (11 downto 0); -- mux latch input
    mux_in_b  : in std_logic_vector (11 downto 0); -- mux latch input
    mux_out   : out std_logic_vector (12 downto 0); -- mux latch output

    strb      : in std_logic; -- on f edge & en: str_div = !str_div
    en        : in std_logic; -- enable to activate f edge on strb
    evnt      : in std_logic; -- event flag
    dv        : out std_logic; -- data valid
    evout     : out std_logic -- true when c_count = "1111111" and cal_str = '1'
  );
end ampl_logic;

architecture logic of ampl_logic is


  signal cnt_out    : std_logic_vector (1 downto 0) := (others => '0'); -- cnt2 output
  signal cal_str    : std_logic := '0'; -- true on 1 cycle after c_count = "1111111"
  signal c_count    : std_logic_vector (6 downto 0) := (others => '0'); -- counter inremented every cycle if clk40 = '1'

  signal str_div    : std_logic := '0';
  signal str_synch  : std_logic_vector (1 downto 0) := (others => '0');

  signal evnt_synch : std_logic_vector (2 downto 0) := (others => '0');
  signal dly        : std_logic_vector (7 downto 0) := (others => '0');

  signal clk40      : std_logic;
  signal clk20      : std_logic;
  signal clk20n     : std_logic;

  component mux_latch
    port (
      clk        : in std_logic;
      in_a       : in std_logic_vector (11 downto 0);
      in_b       : in std_logic_vector (11 downto 0);
      o          : out std_logic_vector (12 downto 0);
      sel0, sel1 : in std_logic
    );
  end component;

  component cnt2 is
    port (
      clk : in std_logic;
      o   : out std_logic_vector (1 downto 0)
    );
  end component;

begin

  cnt2_inst : cnt2 port map (
    clk => clk80,
    o   => cnt_out
  );

  mux_latch_inst : mux_latch port map (
    in_a  => mux_in_a,
    in_b  => mux_in_b,
    o     => mux_out,
    clk   => clk80,
    sel0  => dly(6),
    sel1  => clk20
  );

  clk40 <= cnt_out(0);
  clk20 <= cnt_out(1);
  clk20n <= not cnt_out(1);

  process (clk80) begin

    if falling_edge(clk80) then
      if (clk40 = '0') then
        str_synch(0) <= str_div;
      end if;
    end if;
  end process;

  dv <= dly(7);

  process (clk80) begin

    if rstn = '0' then
      c_count <= "0000000";
      cal_str <= '0';
      evout <= '0';
      dly <= x"00";
    
    elsif rising_edge(clk80) then
      if (evnt_synch(2) = '0' and evnt_synch(1) = '1') then
        c_count <= "0000000";
        cal_str <= '1';
      elsif (clk40 = '1') then
        if c_count = "1111111" then
          cal_str <= '0';
        else
          c_count <= c_count + 1;
        end if;
      end if;

      if (evnt = '0') then
        evout <= '0';
      elsif (c_count = "1111111" and cal_str = '1') then
        evout <= '1';
      end if;

      str_synch(1)   <= str_synch(0);
      evnt_synch <= evnt_synch(1 downto 0) & evnt;
      for i in 0 to 6 loop
        dly(i + 1) <= dly(i);
      end loop;
      dly(0) <= (str_synch(0) xor str_synch(1)) or (cal_str and clk40);
    end if;
  end process;

  process (strb)
  begin
    if (strb'event and strb = '0') then
      if (en = '1') then
        str_div <= not str_div;
      end if;
    end if;
  end process;

end logic;
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity ampl_logic is
  port (
    clk     : in std_logic;
    rstn    : in std_logic;

    mux_in_a: in std_logic_vector (11 downto 0); -- mux latch input
    mux_in_b: in std_logic_vector (11 downto 0); -- mux latch input
    mux_out : out std_logic_vector (12 downto 0); -- mux latch output

    strb    : in std_logic; -- on f edge & enai str_div = !str_div
    enai    : in std_logic; -- enable to activate f edge on strb
    evnt    : in std_logic; -- event flag

    dv      : out std_logic; -- data valid

    cnt_out : out std_logic_vector (1 downto 0); -- cnt2 output
    evout   : out std_logic; -- true when c_count = "1111111" and cal_str = '1'
    cal_str : out std_logic; -- true on 1 cycle after c_count = "1111111"
    c_count : out std_logic_vector (6 downto 0) -- counter inremented every cycle if cnt_out(0) = '1'
  );
end ampl_logic;

architecture logic of ampl_logic is

  signal str_div : std_logic := '0';
  signal str1 : std_logic := '0';
  signal str2 : std_logic := '0';
  signal evnt_i : std_logic_vector (2 downto 0) := (others => '0');
  signal dly : std_logic_vector (7 downto 0) := (others => '0');

  component mux_latch
    port (
      clk        : in std_logic;
      in_a       : in std_logic_vector (11 downto 0);
      in_b       : in std_logic_vector (11 downto 0);
      o          : out std_logic_vector (12 downto 0);
      sel0, sel1 : in std_logic);
  end component;

  component cnt2 is
    port (
      clk : in std_logic;
      o   : out std_logic_vector (1 downto 0)
    );
  end component;

begin

  cnt2_inst : cnt2 port map (
    clk => clk,
    o => cnt_out
  );

  mux_latch_inst : mux_latch port map (
    in_a => mux_in_a,
    in_b => mux_in_b,
    o => mux_out,
    clk => clk,
    sel0 => dly(6),
    sel1 => cnt_out(1)
  );

  process (clk) begin

    if falling_edge(clk) then
      if (cnt_out(0) = '0') then
        str1 <= str_div;
      end if;
    end if;
  end process;

  dv <= dly(7);

  process (clk) begin

    if rstn = '0' then
      dly <= x"00";
      c_count <= "0000000";
      cal_str <= '0';
      evout <= '0';
    
    elsif rising_edge(clk) then
      if (evnt_i(2) = '0' and evnt_i(1) = '1') then
        c_count <= "0000000";
        cal_str <= '1';
      elsif (cnt_out(0) = '1') then
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

      str2   <= str1;
      evnt_i <= evnt_i(1 downto 0) & evnt;
      for i in 0 to 6 loop
        dly(i + 1) <= dly(i);
      end loop;
      dly(0) <= (str1 xor str2) or (cal_str and cnt_out(0));
    end if;
  end process;

  process (strb)
  begin
    if (strb'event and strb = '0') then
      if (enai = '1') then
        str_div <= not str_div;
      end if;
    end if;
  end process;

end logic;
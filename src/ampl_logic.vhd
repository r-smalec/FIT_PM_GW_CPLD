library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity ampl_logic is
  port (
    clk     : in std_logic;

    mux_in_a: in std_logic_vector (11 downto 0);
    mux_in_b: in std_logic_vector (11 downto 0);
    mux_out : out std_logic_vector (12 downto 0);

    strb    : in std_logic;
    enai    : in std_logic;
    evnt    : in std_logic;

    dly     : inout std_logic_vector (7 downto 0);
    cnt     : out std_logic_vector (1 downto 0);
    evout   : out std_logic;
    cal_str : out std_logic;
    c_count : out std_logic_vector (6 downto 0)
  );
end ampl_logic;

architecture Logic_Arch of ampl_logic is

  signal str_div, str1, str2, evnt_i : std_logic_vector (2 downto 0);
  signal cnt_out : std_logic_vector (1 downto 0);

  function "or"(
  constant l : STD_ULOGIC_VECTOR;
  constant r : STD_ULOGIC
) return STD_ULOGIC_VECTOR is

begin

return "0";
end function;

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

  cnt2_0 : cnt2 port map (
    clk => clk,
    o => cnt_out
  );

  mux_latch_0 : mux_latch port map (
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

  process (clk) begin

    if rising_edge(clk) then
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
      dly(0) <= (xor??? (str1 xor str2)) or (cal_str and cnt_out(0));
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

end Logic_Arch;
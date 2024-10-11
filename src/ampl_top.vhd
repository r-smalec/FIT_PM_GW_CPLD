library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
library UNISIM;
use UNISIM.vcomponents.all;

entity ampl_top is
  port (
    CLK80   : in std_logic;
    STR     : in std_logic;
    ENA     : in std_logic;
    DOUT    : out std_logic_vector (12 downto 0);
    ADC0    : in std_logic_vector (11 downto 0);
    ADC1    : in std_logic_vector (11 downto 0);
    CLK40   : out std_logic;
    CLK20_P : out std_logic;
    CLK20_N : out std_logic;
    DV      : out std_logic;
    EV      : in std_logic;
    EV_out  : out std_logic;
    CLK     : out std_logic;
    strb    : out std_logic;
    enai    : out std_logic;
    EVNT    : out std_logic;
    EVOUT   : out std_logic;
    CNT     : out std_logic_vector (1 downto 0);
    dly     : out std_logic_vector (7 downto 0)
  );
end ampl_top;

architecture top of ampl_top is

  signal A, B : std_logic_vector (11 downto 0);
  signal O    : std_logic_vector (12 downto 0);

  component ampl_logic
    port (
      clk : in std_logic;

      in_a    : in std_logic_vector (11 downto 0);
      in_b    : in std_logic_vector (11 downto 0);
      mux_out : out std_logic_vector (12 downto 0);

      strb : in std_logic;
      enai : in std_logic;
      evnt : in std_logic;

      dly     : inout std_logic_vector (7 downto 0);
      cnt     : out std_logic_vector (1 downto 0);
      evout   : out std_logic;
      cal_str : out std_logic;
      c_count : out std_logic_vector (6 downto 0)
    );
  end component;

begin
  INP : for i in 0 to 11 generate
    ADC0_IN : IBUF port map(O => A(i), I => ADC0(i));
    ADC1_IN : IBUF port map(O => B(i), I => ADC1(i));
  end generate;

  OUTP : for i in 0 to 12 generate
    DOUT_OUT : OBUF port map(O => DOUT(i), I => O(i));
  end generate;

  STR_BUF : IBUF port map(O => strb, I => STR);
  ENA_BUF : IBUF port map(O => enai, I => ENA);
  EV_BUF  : IBUF port map(O => EVNT, I => EV);
  EVO_BUF : OBUF port map(O => EV_out, I => EVOUT);
  CL_BUF  : IBUF port map(O => CLK, I => CLK80);

  CL20   : OBUF port map(O => CLK20_P, I => CNT(1));
  CL20_N : OBUF port map(O => CLK20_N, I => not CNT(1));
  CL40   : OBUF port map(O => CLK40, I => CNT(0));
  DV0    : OBUF port map(O => DV, I => dly(7));

end top;
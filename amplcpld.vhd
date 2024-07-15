library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
Library UNISIM;
use UNISIM.vcomponents.all;

entity amplcpld is
	Port ( CLK80 : in  STD_LOGIC;
			 STR : in  STD_LOGIC;
			 ENA : in STD_LOGIC;
          DOUT : out  STD_LOGIC_VECTOR (12 downto 0);
          ADC0 : in  STD_LOGIC_VECTOR (11 downto 0);
          ADC1 : in  STD_LOGIC_VECTOR (11 downto 0);
			 CLK40 : out  STD_LOGIC;
			 CLK20_P : out  STD_LOGIC;
			 CLK20_N : out  STD_LOGIC;
			 DV : out  STD_LOGIC;
			 EV : in  STD_LOGIC;
			 EV_out : out  STD_LOGIC
			 );
end amplcpld;



architecture Frontend of amplcpld is

signal A,B : STD_LOGIC_VECTOR (11 downto 0);
signal O : STD_LOGIC_VECTOR (12 downto 0);
signal CLK, strb,str_div,str1, str2,EVNT, cal_str, enai, EVOUT: STD_LOGIC;
signal CNT : STD_LOGIC_VECTOR (1 downto 0);
signal dly : STD_LOGIC_VECTOR (7 downto 0);
signal evnt_i : STD_LOGIC_VECTOR (2 downto 0);
signal c_count : STD_LOGIC_VECTOR (6 downto 0);

component mux_latch
    Port ( A : in  STD_LOGIC_VECTOR (11 downto 0);
           B : in  STD_LOGIC_VECTOR (11 downto 0);
           O : out  STD_LOGIC_VECTOR (12 downto 0);
           CLK : in  STD_LOGIC;
           S0, S1 : in  STD_LOGIC );
end component;

component cnt2 is
	Port ( CLK : in  STD_LOGIC;
          O : out  STD_LOGIC_VECTOR (1 downto 0)
			 );
end component;

begin
INP: for i in 0 to 11 generate

ADC0_IN: IBUF
   port map (O => A(i), I => ADC0(i) );
ADC1_IN: IBUF
   port map (O => B(i), I => ADC1(i) );
end generate;	

OUTP: for i in 0 to 12 generate

DOUT_OUT: OBUF
   port map (O => DOUT(i), I => O(i) );
end generate;

STR_BUF: IBUF port map (O => strb, I => STR );
ENA_BUF: IBUF port map (O => enai, I => ENA );

EV_BUF:  IBUF port map (O => EVNT, I => EV );
EVO_BUF:  OBUF port map (O => EV_out, I => EVOUT );
CL_BUF: IBUF port map (O => CLK, I => CLK80 );
CL20: OBUF
   port map (O => CLK20_P, I => CNT(1) );
  
CL20_N: OBUF
   port map (O => CLK20_N, I => not CNT(1) );

CL40: OBUF
   port map (O => CLK40, I => CNT(0) );


DV0: OBUF
   port map (O => DV, I => dly(7) );

M_L: mux_latch port map (A=>A, B=>B, O=>O, CLK=>CLK, S0=>dly(6), S1=>CNT(1));

CN_1: cnt2 port map (CLK=>CLK, O=>CNT);


process (CLK)

begin 
if (CLK'event and CLK='0') then 
if (CNT(0)='0') then str1<=str_div; end if;
end if;
end process;

process (CLK)

begin 
if (CLK'event and CLK='1') then 

	
	
	if (evnt_i(2)='0') and (evnt_i(1)='1') then c_count<="0000000"; cal_str<='1';
		else if (CNT(0)='1') then
				if c_count="1111111" then cal_str<='0';
					else c_count<=c_count+1; end if;
			end if;
		end if;
		
	if (EVNT='0') then EVOUT<='0'; 
	  else if (c_count="1111111") and (cal_str='1') then EVOUT<='1';  end if;
	end if;
	
	
	str2<=str1; evnt_i<=evnt_i(1 downto 0) & EVNT;
	for i in 0 to 6 loop dly(i+1)<=dly(i); end loop; dly(0)<= (str1 XOR str2) or (cal_str and CNT(0));
	end if;
end process;


process (strb) begin
if (strb'event and strb='0') then 
	if (enai='1') then str_div <= not str_div; end if;
end if;
end process;

end Frontend;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
								
entity cnt2 is
	Port ( CLK : in  STD_LOGIC;
          O : out  STD_LOGIC_VECTOR (1 downto 0)
			 );
end cnt2;

architecture Behavioral of cnt2 is
signal tmp : STD_LOGIC_VECTOR (1 downto 0);

begin
process (CLK)
begin 
if (CLK'event and CLK='0') then tmp<=tmp+1; end if;
end process;
O<=tmp;
end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_latch is
    Port ( A : in  STD_LOGIC_VECTOR (11 downto 0);
           B : in  STD_LOGIC_VECTOR (11 downto 0);
           O : out  STD_LOGIC_VECTOR (12 downto 0);
           CLK : in  STD_LOGIC;
           S0, S1 : in  STD_LOGIC
			  );
end mux_latch;

architecture Behavioral of mux_latch is

begin
process (CLK)
begin 
if (CLK'event and CLK='1' and S0='1') then
					if (S1='1') then O<='0'& A;
								  else O<='1'& B; 
   				end if;
					end if;

end process;
end Behavioral;

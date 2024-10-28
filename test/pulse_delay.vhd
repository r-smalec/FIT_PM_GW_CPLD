library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pulse_delay is
    generic(
        DELAY_CYCLES : integer := 4
    );
    port(
        clk     : in std_logic;
        sig_in : in std_logic;
        pulse_out : out std_logic
    );
end pulse_delay;

architecture Behavioral of pulse_delay is
    signal pulse : std_logic;
    signal delay_register : std_logic_vector(DELAY_CYCLES-1 downto 0) := (others => '0');
    signal trig : std_logic := '0';
begin
    process(clk)
    begin
        if sig_in = '0' then
            delay_register <= (others => '0');
            pulse <= '0';
            trig <= '1';
        elsif rising_edge(clk) then
            if trig = '1' then
                delay_register <= delay_register(DELAY_CYCLES-2 downto 0) & sig_in;
                pulse <= delay_register(DELAY_CYCLES-1);
            end if;
        end if;

        if pulse = '1' then
            trig <= '0';
            pulse <= '0';
        end if;
    end process;

    pulse_out <= pulse;
end Behavioral;
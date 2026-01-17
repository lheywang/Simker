library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity counter_tb is
-- Testbench has no ports
end counter_tb;

architecture Behavior of counter_tb is
    component counter
        Port ( clk : in STD_LOGIC; rst_n : in STD_LOGIC; en : in STD_LOGIC; count : out STD_LOGIC_VECTOR(3 downto 0));
    end component;

    signal clk : STD_LOGIC := '0';
    signal rst_n, en : STD_LOGIC := '0';
    signal count : STD_LOGIC_VECTOR(3 downto 0);
    constant clk_period : time := 10 ns;
begin
    uut: counter port map (clk => clk, rst_n => rst_n, en => en, count => count);

    -- Clock process
    clk_process : process
    begin
        clk <= '0'; wait for clk_period/2;
        clk <= '1'; wait for clk_period/2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Reset
        rst_n <= '0';
        wait for 20 ns;
        rst_n <= '1';
        en <= '1';
        wait for 1 ms;
    end process;
end Behavior;

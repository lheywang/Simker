library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
  
entity clk_div is
port ( clk,rstn: in std_logic;
clk2: out std_logic);
end clk_div;
  
architecture bhv of clk_div is
  
signal count: integer:=1;
signal tmp : std_logic := '0';
  
begin
  
process(clk,rstn)
begin
if(rstn='0') then
count<=1;
tmp<='0';
elsif(clk'event and clk='1') then
count <=count+1;
if (count = 2) then
tmp <= NOT tmp;
count <= 1;
end if;
end if;
clk2 <= tmp;
end process;
  
end bhv;

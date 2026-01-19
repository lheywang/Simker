# vhdl2verilog

This script is much, much simpler than wrappergen, because it's only charged of one thing : 
Convert a vhdl file into it's verilog equivalent.

And, actually it does not perform anything of it, it just ask ghdl to do it for us.

## Usage 

To convert a file, you type :

```sh
vhdl2verilog file.vhdl
```

and file.v will be created.

As an example, if we convert this file :

```verilog
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
  
entity clk_div is
    port ( 
        clk,rstn: in std_logic;
        clk2: out std_logic
    );
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

```

We'll get something that look like : 

```verilog

module clk_div
  (input  clk,
   input  rstn,
   output clk2);
  reg [31:0] count;
  reg tmp;
  wire n5;
  wire [31:0] n8;
  wire n10;
  wire n11;
  wire [31:0] n13;
  reg [31:0] n22;
  wire n23;
  reg n24;
  assign clk2 = tmp; //(module output)
  /* clk_div.vhd:12:8  */
  always @*
    count = n22; // (isignal)
  initial
    count = 32'b00000000000000000000000000000001;
  /* clk_div.vhd:13:8  */
  always @*
    tmp = n24; // (isignal)
  initial
    tmp = 1'b0;
  /* clk_div.vhd:19:8  */
  assign n5 = ~rstn;
  /* clk_div.vhd:23:14  */
  assign n8 = count + 32'b00000000000000000000000000000001;
  /* clk_div.vhd:24:11  */
  assign n10 = count == 32'b00000000000000000000000000000010;
  /* clk_div.vhd:25:8  */
  assign n11 = ~tmp;
  /* clk_div.vhd:24:1  */
  assign n13 = n10 ? 32'b00000000000000000000000000000001 : n8;
  /* clk_div.vhd:22:1  */
  always @(posedge clk or posedge n5)
    if (n5)
      n22 <= 32'b00000000000000000000000000000001;
    else
      n22 <= n13;
  /* clk_div.vhd:22:1  */
  assign n23 = n10 ? n11 : tmp;
  /* clk_div.vhd:22:1  */
  always @(posedge clk or posedge n5)
    if (n5)
      n24 <= 1'b0;
    else
      n24 <= n23;
endmodule

```

After a first look, that doesn't look like a direct conversion. And, that's normal, because in fact we already passed a synth step,
which explain the signal and output name loss.

That's the same for dimensions of arrays, which seems to be lost. And, that's actually the case, but, we don't really care, because
theses elements are only used in simulation. They we're expanded to 32 bits, which is actually the greatest size of integer in VHDL, so nothing to be afraid of.

> [!NOTE]
> Due to theses changes, there's always the risk of something mis-interpreted. It's very very low, but if something goes wrong, perhaps look here !
> Theses behavior will naturally be more present if you're fan of using weird, undefined behavior constructs :=)
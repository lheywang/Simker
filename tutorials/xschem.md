# XSCHEM

XSCHEM is a schematic capture tool, designed for SPICE usage.
It's job to make easier the creation of netlists, rather than typing it by hand.

## Basic usage : 

1. Create the schematic you want (Right click, place symbol), then W to wire them.

> [!NOTE]
> You can copy elements by selecting them and typing C, and re-place them !

> [!NOTE]
> You can name nets by pressing Alt +  L, placing it and changing name after !

2. Once you're satisfied, press "Netlist" in top of the GUI. XSCHEM will generate the file for you.

3. Then, you can press "Simulate" to launch ngspice. If everything is correctly configured, you may end up with satisfying results !

4. Finally, you can press "Waves" to get the output (require the generation of a .raw file). This can be openned in gaw, or even annotated on the schematic for a .op !
   
## Known behaviors : 

Sometimes, when you re-create a .sym file, XSCHEM won't automatically infer it. You may be needed to delete it, and replace it for XSCHEM to actualize it's own base.
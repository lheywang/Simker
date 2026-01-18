# Mixed_sim

This example was mostly designed as a proof of concept for the whole container, by mixing the highest number of tools.
Thus, it include : 
- GHDL to convert a VHDL file into it's Verilog equivalent
- Verilator, through Vlnggen to compile the digital logic into a logic equivalent
- Openvaf-r to compile the driver.va file into it's .osdi representation
- ngspice to simulate all of them.

The circuit is by itself quite simple : 

That's a clock, followed by a divider (factor 2), and then, a four bit counter. Each output is wired to an RC filter.

![](https://github.com/lheywang/Simker/blob/main/images/mixed_sim_xschem/mixed_sim_xschem.png)

## Running it ?

Just type 

```sh
make prepare
```
to prepare all the different files for the simulation.

Finally, you can open XSCHEM :

```sh
xschem circuit.sch
```
click on netlist and simulate, and you're done.

Rapidly an analog viewer will be openned for you showing the waveforms, in this order :

- RC output, MSB of counter
- RC output, bit 2
- RC output, bit 1
- RC output, LSB of counter
- Clock
- Reset

![](https://github.com/lheywang/Simker/blob/main/images/mixed_sim_xschem/mixed_sim_xschem.gif)

## Foot note : 

As you may see, the signals are larger in this simulations compared to the netlist one, even if the blocks are stricly identical.
That behavior come from the configuration of the ADC / DAC bridges on the simulations.

On the netlist, they expose the default behavior : 1V input / output, where, on this one, I've configured them to expose a 3.3V output 
(configurable by a parameter passed to the script).

And, since the driver is dumb : It does basically input * 3.33, it get a 3.3 * 3.3, which is equal to ~11V. That's the source of the larger
signals compared to the netlist one.


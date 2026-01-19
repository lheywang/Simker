# Examples

In this folder, you can find the most basic examples of spice simulations.
They may be used for testing the container, especially mixed*sim*\* which involve near all of the tools !

They come with Makefile, so don't be afraid to type a Make sim in the folder !

And you still can see the source to understand how that was built !

## List of examples

| Example Name          | Description                                                                   |
| --------------------- | ----------------------------------------------------------------------------- |
| [analog_rc](https://github.com/lheywang/Simker/tree/main/examples/analog_rc)             | Basic SPICE simulation, pure analog                                           |
| [analog_speaker](https://github.com/lheywang/Simker/tree/main/examples/analog_speaker)        | Advanced SPICE simulation, which include VerilogA models. Pure analog engine. |
| [digital_systemverilog](https://github.com/lheywang/Simker/tree/main/examples/digital_systemverilog) | Basic Systemverilog example, purely digital. Include a C++ testbench.         |
| [digital_verilog](https://github.com/lheywang/Simker/tree/main/examples/digital_verilog)       | Basic Verilog example, purely digital.                                        |
| [digital_vhdl](https://github.com/lheywang/Simker/tree/main/examples/digital_vhdl)          | Basic VHDL example, purely digital                                            |
| [mixed_sim_netlist](https://github.com/lheywang/Simker/tree/main/examples/mixed_sim_netlist)     | Mixed simulation example without XSCHEM schematic.                            |
| [mixed_sim_xschem](https://github.com/lheywang/Simker/tree/main/examples/mixed_sim_xschem)      | Mixed simulation example, with XSCHEM schematic integration.                  |

As you may seen, the last one is the more interessting because it include all of the options, and perform a large mixed signals simulation.
If you're familiar with SPICE simulations, you may want to skip others to directly look at it !

For each simulations, you'll get images and videos that show the different steps to proceed !
That make things a bit easier for beginners !

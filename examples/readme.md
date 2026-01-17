# Examples

In this folder, you can find the most basic examples of spice simulations.
They may be used for testing the container, especially mixed*sim*\* which involve near all of the tools !

They come with Makefile, so don't be afraid to type a Make sim in the folder !

And you still can see the source to understand how that was built !

## List of examples

| Example Name          | Description                                                                   |
| --------------------- | ----------------------------------------------------------------------------- |
| analog_rc             | Basic SPICE simulation, pure analog                                           |
| analog_speaker        | Advanced SPICE simulation, which include VerilogA models. Pure analog engine. |
| digital_systemverilog | Basic Systemverilog example, purely digital. Include a C++ testbench.         |
| digital_verilog       | Basic Verilog example, purely digital.                                        |
| digital_vhdl          | Basic VHDL example, purely digital                                            |
| mixed_sim_netlist     | Mixed simulation example without XSCHEM schematic.                            |
| mixed_sim_xschem      | Mixed simulation example, with XSCHEM schematic integration.                  |

As you may seen, the last one is the more interessting because it include all of the options, and perform a large mixed signals simulation.
If you're familiar with SPICE simulations, you may want to skip others to directly look at it !

# analog RC example

This simple example run in pure analog mode.
It does just simulate two RC circuits, one with square input and the other with triangle input.

It's there to show the most basic ways of operation of the XSCHEM + NGSPICE integration.

![](https://github.com/lheywang/Simker/blob/main/images/analog_rc/analog_rc_1.png)
![](https://github.com/lheywang/Simker/blob/main/images/analog_rc/analog_rc_2.png)

## Running it ?

Just type 

```sh
xschem circuit.sch
```

or 
```sh
make sim
```

to open the XSCHEM GUI, and then, click on netlist and simulate.
An analog viewer shall be openned pretty quickly.

![](https://github.com/lheywang/Simker/blob/main/images/analog_rc/analog_rc.gif)
# digital SV example

This example show a simple four bit counter, as any other digital simulation.
The difference with the verilog example is that, this time the testbench is wrote in C++,
using a class to make assertions easier.

## Running it ?

Just type 

```sh
make wave
```

All the commands needed to the elaboration of the binaries are going to be called, and a waveform viewer shall be openned.
And, in the terminal you're going to see some logs, for the C++ class that perform assertion on every loop.


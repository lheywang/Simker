# analog speaker example

This simple example run in pure analog mode.
This is to show more advanced ways of simulations which integrate some verilogA models.

Speakers are complex load, that can't be simplified into a single simple load. 
We need more than one simulation to look at it !

Thus, there's three options here : An AC plot, a Time plot, and a DC plot.
- The AC look at the impedance of the load. It does match real ones !
- The transcient plot look at the position of a speaker when stimulated with a sine wave.
- The DC look at the position versus current of the load.

## Running it ?

Just type 

```sh
xschem ac.sch
xschem dc.sch
xschem tran.sch
```

> [!NOTE]
> You need to choose which simulation you want. You can run them back to back !

to open the XSCHEM GUI, and then, click on netlist and simulate.
An analog viewer shall be openned pretty quickly.

## AC 

![](https://github.com/lheywang/Simker/blob/main/images/analog_speaker/analog_speaker_ac.png)

To run it, proceed as explained in the first part !

![](https://github.com/lheywang/Simker/blob/main/images/analog_speaker/analog_speaker_ac.gif)

This simulation show how the impedance of a speaker vary with frequency, and this simulation get 
results that are near officials ones ! So, pretty real !

## Transcient

![](https://github.com/lheywang/Simker/blob/main/images/analog_speaker/analog_speaker_tran.png)

To run it, proceed as explained in the first part !

![](https://github.com/lheywang/Simker/blob/main/images/analog_speaker/analog_speaker_tran.gif)

This simulation how a speaker respond in the time while being stimulated with a sine at 50 Hz.
We can cleary see that it's response it as it should, sine !

## DC

![](https://github.com/lheywang/Simker/blob/main/images/analog_speaker/analog_speaker_dc.png)

To run it, proceed as explained in the first part !

![](https://github.com/lheywang/Simker/blob/main/images/analog_speaker/analog_speaker_dc.gif)

This last simulation show the position of a speaker over the current through it.
We can see that a speaker is non-linear, as it does not move linearly with the current increase.

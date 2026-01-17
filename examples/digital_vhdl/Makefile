prepare: counter.vhd counter_tb.vhd
	ghdl -a counter.vhd counter_tb.vhd
	ghdl -e counter_tb

sim: prepare
	ghdl -r counter_tb --vcd=wave.vcd --stop-time=180ns

wave: sim
	gtkwave wave.vcd wave.gtkw

clean:
	rm -rf *.o counter_tb e~* *.cf *.vcd

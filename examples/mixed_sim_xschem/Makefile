# Makefile to run the simulation

clk_div.v: clk_div.vhd
	vhdl2verilog clk_div.vhd

top.so: clk_div.v counter.v
	wrappergen clk_div.v counter.v

driver.osdi: driver.va
	wrappergen --analog driver.va

clean:
	rm -rf *.out *.py *.osdi clk_div.v *.so *.sym top.v
	rm -rf top_obj_dir
	rm -rf top.va
	rm -rf simulation/
	rm -rf *.txt *.spice

prepare: top.so driver.osdi circuit.sch

# Makefile to run the simulation

clk_div.v: clk_div.vhd
	vhdl2verilog clk_div.vhd

top.so: clk_div.v counter.v
	wrappergen --no-sym clk_div.v counter.v

driver.osdi: driver.va
	openvaf-r driver.va

sim: top.so driver.osdi
	ngspice top.cir

clean:
	rm -rf *.out *.py *.osdi clk_div.v *.so *.sym top.v
	rm -rf top_obj_dir

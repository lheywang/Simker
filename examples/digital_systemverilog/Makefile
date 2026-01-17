prepare: counter.sv counter_tb.cpp
	verilator --sv --cc counter.sv --exe counter_tb.cpp --trace
	make -C obj_dir -f Vcounter.mk Vcounter

sim: prepare
	./obj_dir/Vcounter

wave: sim
	gtkwave Counter_Test.vcd wave.gtkw

clean:
	rm -rf *.swp *.vcd obj_dir/ 

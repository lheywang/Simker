prepare: counter.v counter_tb.v
	verilator --binary --timing --trace --top tb_counter counter_tb.v counter.v

sim: prepare
	./obj_dir/Vtb_counter

wave: sim
	gtkwave counter.vcd wave.gtkw

clean:
	rm -rf *.swp *.vcd obj_dir/ 

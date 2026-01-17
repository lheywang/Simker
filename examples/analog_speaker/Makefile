speaker.osdi:
	wrappergen --analog speaker.va

prepare: speaker.osdi
	mkdir -p simulation
	cp speaker.osdi simulation/speaker.osdi

clean:
	rm -rf simulation
	rm -rf *.osdi *.sym *.spice

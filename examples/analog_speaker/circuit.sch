v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N -110 -10 -110 20 {lab=spkp}
N -110 -10 30 -10 {lab=spkp}
N -110 80 -110 100 {lab=GND}
N 110 -10 150 -10 {lab=GND}
N 210 70 210 80 {lab=GND}
N 110 10 150 10 {lab=vmon}
N 150 70 150 100 {lab=GND}
N 210 80 210 100 {lab=GND}
N 210 -10 210 70 {lab=GND}
N 150 -10 210 -10 {lab=GND}
C {devices/vsource.sym} -110 50 0 0 {name=V1 
value="0 AC 1" 
savecurrent=false}
C {devices/res.sym} 150 40 0 0 {name=R1
value=1M
footprint=1206
device=resistor
m=1}
C {devices/gnd.sym} 210 100 0 0 {name=l1 lab=GND}
C {devices/gnd.sym} -110 100 0 0 {name=l2 lab=GND}
C {devices/lab_wire.sym} -70 -10 0 0 {name=p1 sig_type=std_logic lab=spkp}
C {devices/gnd.sym} 150 100 0 0 {name=l3 lab=GND}
C {devices/lab_wire.sym} 150 10 0 0 {name=p3 sig_type=std_logic lab=vmon
}
C {devices/simulator_commands_shown.sym} 280 30 0 0 {name=COMMANDS
simulator=ngspice
only_toplevel=false 
value="
.control 
  ac dec 2000 1 40k
  plot -(v(spkp)/i(V1))
.endc
"}
C {speaker.sym} 70 0 0 0 {}

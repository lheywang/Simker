v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 430 1280 430 1290 {lab=GND}
N 540 1160 590 1160 {lab=pos}
N 590 1160 590 1180 {lab=pos}
N 590 1240 590 1280 {lab=GND}
N 430 1180 430 1270 {lab=GND}
N 430 1180 460 1180 {lab=GND}
N 350 1160 460 1160 {lab=spkp}
N 350 1160 350 1180 {lab=spkp}
N 350 1240 350 1280 {lab=GND}
N 430 1270 430 1280 {lab=GND}
N 590 1160 620 1160 {lab=pos}
C {devices/gnd.sym} 350 1280 0 0 {name=l1 lab=GND}
C {devices/gnd.sym} 430 1280 0 0 {name=l2 lab=GND}
C {devices/gnd.sym} 590 1280 0 0 {name=l3 lab=GND}
C {devices/res.sym} 590 1210 0 0 {name=R1
value=1k
footprint=1206
device=resistor
m=1}
C {devices/code_shown.sym} 340 1360 0 0 {name=s1 only_toplevel=false value="
.control
  dc I0 0 10 1m
  plot v(pos)
.endc
"}
C {devices/isource.sym} 350 1210 2 0 {name=I0 value=1}
C {devices/lab_wire.sym} 430 1160 0 0 {name=p1 sig_type=std_logic lab=spkp}
C {devices/lab_wire.sym} 620 1160 0 0 {name=p3 sig_type=std_logic lab=pos}
C {speaker.sym} 500 1170 0 0 {name=Xspeaker1}

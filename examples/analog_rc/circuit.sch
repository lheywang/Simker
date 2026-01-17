v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 30 180 30 190 {lab=GND}
N 30 10 30 20 {lab=GND}
N 30 190 30 200 {lab=GND}
N 30 20 30 30 {lab=GND}
N 320 20 320 30 {lab=GND}
N 320 190 320 200 {lab=GND}
N 290 110 320 110 {lab=out2}
N 320 110 320 130 {lab=out2}
N 30 110 230 110 {lab=in2}
N 30 110 30 120 {lab=in2}
N 30 -60 30 -50 {lab=in1}
N 30 -60 230 -60 {lab=in1}
N 290 -60 320 -60 {lab=out1}
N 320 -60 320 -40 {lab=out1}
N 320 110 350 110 {lab=out2}
N 320 -60 350 -60 {lab=out1}
C {devices/vsource.sym} 30 -20 0 0 {name=V1 value="PULSE(0 3 100u 1n 1n 1m 2m)" savecurrent=false}
C {devices/vsource.sym} 30 150 0 0 {name=V2 value="PULSE(0 3 100u 1m 1m 1n 2m)" savecurrent=false}
C {devices/gnd.sym} 30 30 0 0 {name=l1 lab=GND}
C {devices/gnd.sym} 30 200 0 0 {name=l2 lab=GND}
C {devices/res.sym} 260 -60 1 0 {name=R1
value=2.2k
footprint=1206
device=resistor}
C {devices/res.sym} 260 110 1 0 {name=R2
value=2.2k
footprint=1206
device=resistor}
C {devices/capa.sym} 320 -10 0 0 {name=C1
value=100n
footprint=1206
device="ceramic capacitor"}
C {devices/capa.sym} 320 160 0 0 {name=C2
value=100n
footprint=1206
device="ceramic capacitor"}
C {devices/gnd.sym} 320 30 0 0 {name=l3 lab=GND}
C {devices/gnd.sym} 320 200 0 0 {name=l4 lab=GND}
C {devices/code.sym} 430 10 0 0 {name=s1 only_toplevel=false value="
.control
  tran 100n 10m
  plot v(in1) v(out1)
  plot v(in2) v(out2)
.endc
"}
C {devices/lab_wire.sym} 30 -60 0 0 {name=p3 sig_type=std_logic lab="in1"}
C {devices/lab_wire.sym} 30 110 0 0 {name=p1 sig_type=std_logic lab="in2"}
C {devices/lab_wire.sym} 350 110 0 0 {name=p2 sig_type=std_logic lab="out2"}
C {devices/lab_wire.sym} 350 -60 0 0 {name=p4 sig_type=std_logic lab="out1"}

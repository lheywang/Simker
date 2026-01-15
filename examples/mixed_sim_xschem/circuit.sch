v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N -360 -30 -360 20 {lab=#net1}
N -160 -10 -160 20 {lab=#net2}
N -160 80 -160 120 {lab=GND}
N -360 80 -360 120 {lab=GND}
N 270 -180 310 -180 {lab=#net3}
N 370 -180 400 -180 {lab=#net4}
N 400 -180 400 -170 {lab=#net4}
N 400 -110 400 -100 {lab=GND}
N 270 -70 310 -70 {lab=#net5}
N 370 -70 400 -70 {lab=#net6}
N 400 -70 400 -60 {lab=#net6}
N 400 0 400 10 {lab=GND}
N 270 40 310 40 {lab=#net7}
N 370 40 400 40 {lab=#net8}
N 400 40 400 50 {lab=#net8}
N 400 110 400 120 {lab=GND}
N 370 150 400 150 {lab=#net9}
N 400 150 400 160 {lab=#net9}
N 400 220 400 230 {lab=GND}
N 140 -180 140 -30 {lab=#net10}
N 160 -70 160 -10 {lab=#net11}
N 160 10 160 40 {lab=#net12}
N 140 30 140 150 {lab=#net13}
N 160 -70 190 -70 {lab=#net11}
N 160 40 190 40 {lab=#net12}
N 140 150 190 150 {lab=#net13}
N 270 150 310 150 {lab=#net14}
N 140 -180 190 -180 {lab=#net10}
N 50 30 140 30 {lab=#net13}
N 50 10 160 10 {lab=#net12}
N 50 -10 160 -10 {lab=#net11}
N 50 -30 140 -30 {lab=#net10}
N -160 -10 -30 -10 {lab=#net2}
N -360 -30 -30 -30 {lab=#net1}
C {devices/vsource.sym} -160 50 0 0 {name=V1 value="PULSE(0 3.3 0 1n 1n 100n 200n)" savecurrent=false}
C {devices/vsource.sym} -360 50 0 0 {name=V2 value="PULSE(3.3 0 220n 1n 1n 1n 1)" savecurrent=false}
C {devices/gnd.sym} -360 120 0 0 {name=l1 lab=GND}
C {devices/gnd.sym} -160 120 0 0 {name=l2 lab=GND}
C {devices/res.sym} 340 -180 1 1 {name=R1
value=100
footprint=1206
device=resistor
m=1}
C {devices/capa.sym} 400 -140 0 0 {name=C1
m=1
value=1n
footprint=1206
device="ceramic capacitor"}
C {devices/gnd.sym} 400 -100 0 0 {name=l3 lab=GND}
C {devices/res.sym} 340 -70 1 1 {name=R2
value=100
footprint=1206
device=resistor
m=1}
C {devices/capa.sym} 400 -30 0 0 {name=C2
m=1
value=1n
footprint=1206
device="ceramic capacitor"}
C {devices/gnd.sym} 400 10 0 0 {name=l4 lab=GND}
C {devices/res.sym} 340 40 1 1 {name=R3
value=100
footprint=1206
device=resistor
m=1}
C {devices/capa.sym} 400 80 0 0 {name=C3
m=1
value=1n
footprint=1206
device="ceramic capacitor"}
C {devices/gnd.sym} 400 120 0 0 {name=l5 lab=GND}
C {devices/res.sym} 340 150 1 1 {name=R4
value=100
footprint=1206
device=resistor
m=1}
C {devices/capa.sym} 400 190 0 0 {name=C4
m=1
value=1n
footprint=1206
device="ceramic capacitor"}
C {devices/gnd.sym} 400 230 0 0 {name=l6 lab=GND}
C {top.sym} 10 0 0 0 {}
C {driver.sym} 230 -170 0 0 {v \{xschem version=3.4.4 file_version=1.2\}
K \{\}
V \{\}
S \{\}
E \{\}

L 4 -40.0 20.0 -40.0 -20.0 \{\}
L 4 -40.0 -20.0 40.0 -20.0 \{\}
L 4 40.0 -20.0 40.0 20.0 \{\}
L 4 40.0 20.0 -40.0 20.0 \{\}

B 5 -42.5 -12.5 -37.5 -7.5 \{name=driver_in dir=in seq=0\}
T \{driver_in\} -35.0 -14.0 0 0.1 0.1 \{\}
B 5 37.5 -12.5 42.5 -7.5 \{name=driver_out dir=out seq=1\}
T \{driver_out\} 7.5 -14.0 0 0.1 0.1 \{\}

T \{driver\} -16.5 -16.5 0 0 0.2 0.2

G \{type=subcircuit 
format="@name @pinlist @model"
template="name=X1 model=driver"
spice_sym_def="
.control
  pre_osdi driver.osdi
.endc

.subckt driver driver_in driver_out
  .Model driver_model driver
  N1 driver_in driver_out driver_model
.ends
"
\}

}
C {driver.sym} 230 -60 0 0 {}
C {driver.sym} 230 50 0 0 {}
C {driver.sym} 230 160 0 0 {}
C {devices/code.sym} -360 -210 0 0 {name=s1 only_toplevel=false value="
.control 
  tran 10n 15u
  plot v(net2) v(net4)+24 v(net6)+18 v(net8)+12 v(net9)+6 v(net1)-6
.endc
"}

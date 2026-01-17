v {xschem version=3.1.0 file_version=1.2 }
G {}
K {}
V {}
S {}
E {}
N -360 -30 -360 20 {lab=rst}
N -160 -10 -160 20 {lab=clk}
N -160 80 -160 120 {lab=GND}
N -360 80 -360 120 {lab=GND}
N 270 -180 310 -180 {lab=#net1}
N 370 -180 400 -180 {lab=out3}
N 400 -180 400 -170 {lab=out3}
N 400 -110 400 -100 {lab=GND}
N 270 -70 310 -70 {lab=#net2}
N 370 -70 400 -70 {lab=out2}
N 400 -70 400 -60 {lab=out2}
N 400 0 400 10 {lab=GND}
N 270 40 310 40 {lab=#net3}
N 370 40 400 40 {lab=out2}
N 400 40 400 50 {lab=out2}
N 400 110 400 120 {lab=GND}
N 370 150 400 150 {lab=out1}
N 400 150 400 160 {lab=out1}
N 400 220 400 230 {lab=GND}
N 140 -180 140 -30 {lab=dout3}
N 160 -70 160 -10 {lab=dout2}
N 160 10 160 40 {lab=dout1}
N 140 30 140 150 {lab=dout0}
N 160 -70 190 -70 {lab=dout2}
N 160 40 190 40 {lab=dout1}
N 140 150 190 150 {lab=dout0}
N 270 150 310 150 {lab=#net4}
N 140 -180 190 -180 {lab=dout3}
N 50 30 140 30 {lab=dout0}
N 50 10 160 10 {lab=dout1}
N 50 -10 160 -10 {lab=dout2}
N 50 -30 140 -30 {lab=dout3}
N -160 -10 -30 -10 {lab=clk}
N -360 -30 -30 -30 {lab=rst}
N 400 -180 440 -180 {
lab=out3}
N 400 -70 440 -70 {
lab=out2}
N 400 40 440 40 {
lab=out2}
N 400 150 440 150 {
lab=out1}
N 440 150 480 150 {
lab=out1}
N 440 40 480 40 {
lab=out2}
N 440 -70 480 -70 {
lab=out2}
N 440 -180 480 -180 {
lab=out3}
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
C {devices/code.sym} -360 -210 0 0 {name=s1 only_toplevel=false value="
.control 
  tran 10n 15u
  plot v(clk) v(out3)+24 v(out2)+18 v(out1)+12 v(out0)+6 v(rst)-6
.endc
"}
C {driver.sym} 230 -170 0 0 {name=Xdriver1}
C {driver.sym} 230 -60 0 0 {name=Xdriver2}
C {driver.sym} 230 50 0 0 {name=Xdriver3}
C {driver.sym} 230 160 0 0 {name=Xdriver4}
C {devices/lab_wire.sym} -360 -30 0 0 {name=l7 sig_type=std_logic lab="rst"}
C {devices/lab_wire.sym} -160 -10 0 0 {name=l8 sig_type=std_logic lab="clk"}
C {devices/lab_wire.sym} 90 -30 0 0 {name=l9 sig_type=std_logic lab=dout3}
C {devices/lab_wire.sym} 90 -10 0 0 {name=l10 sig_type=std_logic lab=dout2}
C {devices/lab_wire.sym} 90 10 0 0 {name=l11 sig_type=std_logic lab=dout1}
C {devices/lab_wire.sym} 90 30 0 0 {name=l12 sig_type=std_logic lab=dout0}
C {devices/lab_wire.sym} 480 -180 0 0 {name=l13 sig_type=std_logic lab=out3}
C {devices/lab_wire.sym} 480 -70 0 0 {name=l14 sig_type=std_logic lab=out2}
C {devices/lab_wire.sym} 480 40 0 0 {name=l15 sig_type=std_logic lab=out2}
C {devices/lab_wire.sym} 480 150 0 0 {name=l16 sig_type=std_logic lab=out1}

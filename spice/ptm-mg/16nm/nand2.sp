* NAND2 - case1: A high B pulse

.lib '../modelfiles/models' ptm16lstp
.include '../modelfiles/lstp/16nfet.pm'
.include '../modelfiles/lstp/16pfet.pm'

.PARAM vd=0.85
.PARAM var=2
.OPTION POST=2
.GLOBAL gnd! vdd!


****************************************************
************** INVERTER
****************************************************
.SUBCKT inv vi vo
Mn0 vo vi gnd! gnd! nfet
Mp0 vo vi vdd! vdd! pfet
.ENDS

****************************************************
************** BUFFER
****************************************************
.SUBCKT buf vi vo
XINV0 vi _vo inv
XINV1 _vo vo inv
.ENDS

****************************************************
************** NAND2
****************************************************
.SUBCKT nand2 in0 in1 out
Mn0 out in0 nnode gnd! nfet
Mn1 nnode in1 gnd! gnd! nfet
Mp0 out in0 vdd! vdd! pfet
Mp1 out in1 vdd! vdd! pfet
.ENDS

****************************************************
************** INSTANCES
****************************************************
* INPUTS THROUGH BUFFER
XBUF0 A AA buf
XBUF1 B BB buf

XNAND2 AA BB F nand2

XBUF2 F FF buf

* CAPS
C0 FF gnd! 1fF

****************************************************
************** SUPPLY
****************************************************
Vvdd vdd! 0 0.85v
Vgnd gnd! 0 0v


****************************************************
************** STIMULUS - use alter to change
****************************************************
VINA A 0 dc=0.85v
VIN1 B 0 0 pulse 0 0.85 0 50p 50p 2n 4n

.tran 10p 100n sweep var 2 15 1

****************************************************
************** MEASUREMENTS
****************************************************
.meas tran trise_nand2 trig v(F) val='vd*0.1' rise='var'
+                      targ v(F) val='vd*0.9' rise='var'

.meas tran tfall_nand2 trig v(F) val='vd*0.9' fall='var'
+                      targ v(F) val='vd*0.1' fall='var'

.meas tran tphl_nand2 trig v(BB) val='vd/2' rise='var'
+                     targ v(F) val='vd/2' fall='var'

.meas tran tplh_nand2 trig v(BB) val='vd/2' rise='var'
+                     targ v(F) val='vd/2' fall='var'

.meas tran avgpower AVG power from=1n to=100n


.alter case2: A pulse B high
VINA A 0 0 pulse 0 0.85 0 50p 50p 2n 4n
VIN1 B 0 dc=0.85v

.meas tran trise_nand2 trig v(F) val='vd*0.1' rise='var'
+                      targ v(F) val='vd*0.9' rise='var'

.meas tran tfall_nand2 trig v(F) val='vd*0.9' fall='var'
+                      targ v(F) val='vd*0.1' fall='var'

.meas tran tphl_nand2 trig v(AA) val='vd/2' rise='var'
+                     targ v(F) val='vd/2' fall='var'

.meas tran tplh_nand2 trig v(AA) val='vd/2' rise='var'
+                     targ v(F) val='vd/2' fall='var'

.meas tran avgpower AVG power from=1n to=100n


.alter case3: A pulse B pulse
VINA A 0 0 pulse 0 0.85 0 50p 50p 2n 4n
VIN1 B 0 0 pulse 0 0.85 0 50p 50p 6n 12n

.meas tran trise_nand2 trig v(F) val='vd*0.1' rise='var'
+                      targ v(F) val='vd*0.9' rise='var'

.meas tran tfall_nand2 trig v(F) val='vd*0.9' fall='var'
+                      targ v(F) val='vd*0.1' fall='var'

* .meas tran tphl_nand2 trig v(AA) val='vd/2' rise='var'
* +                     targ v(F) val='vd/2' fall='var'

* .meas tran tplh_nand2 trig v(AA) val='vd/2' rise='var'
* +                     targ v(F) val='vd/2' fall='var'

.meas tran avgpower AVG power from=1n to=100n

.END
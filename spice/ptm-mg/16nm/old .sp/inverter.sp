* finfet testbench

simulator lang=spice

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
************** INSTANCES
****************************************************
XBUF0 A B buf
XINV0 B C inv
XBUF1 C D buf

* CAPACITOR
C0 D gnd! 1fF

****************************************************
************** SUPPLY
****************************************************
Vvdd vdd! 0 0.85v
Vgnd gnd! 0 0v


****************************************************
************** STIMULUS
****************************************************
VIN0 A 0 0 pulse 0 vdd 0 50p 50p 2n 4n 

* .DC VIN0 0 0.85 0.01 

.tran 10p 100n sweep var 2 15 1

****************************************************
************** MEASUREMENTS
****************************************************
.meas tran trise_inv trig v(C) val='vd*0.1' rise='var'
+                    targ v(C) val='vd*0.9' rise='var'

.meas tran tfall_inv trig v(C) val='vd*0.9' fall='var'
+                    targ v(C) val='vd*0.1' fall='var'

.meas tran tphl_inv trig v(B) val='vd/2' cross='var'
+                   targ v(C) val='vd/2' cross='var'

.meas tran tplh_inv trig v(B) val='vd/2' cross='var'
+                   targ v(C) val='vd/2' cross='var'

.meas tran avgpower AVG power from=1n to=100n


.alter case2: 7nm

.lib '../modelfiles/models' ptm7lstp
.include '../modelfiles/lstp/7nfet.pm'
.include '../modelfiles/lstp/7pfet.pm'

.END
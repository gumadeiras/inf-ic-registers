* finfet testbench

.lib '../modelfiles/models' ptm16lstp
.include '../modelfiles/lstp/16nfet.pm'
.include '../modelfiles/lstp/16pfet.pm'

.PARAM vdd=0.85
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

* .param cicle
.tran 10p 50n sweep cicle 2 10 2 

****************************************************
************** MEASUREMENTS
****************************************************
.meas tran trise_inv trig v(C)val='vdd*0.1' rise=2
+                    targ v(C) val='vdd*0.9' rise=2

.meas tran tfall_inv trig v(C) val='vdd*0.9' fall=2
+                    targ v(C) val='vdd*0.1' fall=2

.meas tran tphl_inv trig v(B) val='vdd/2' td=5n cross=1
+                   targ v(C) val='vdd/2' td=5n cross=1

.meas tran tplh_inv trig v(B) val='vdd/2' td=5n cross=2
+                   targ v(C) val='vdd/2' td=5n cross=2

.meas tran avgpower AVG power from=1n to=50n


.END
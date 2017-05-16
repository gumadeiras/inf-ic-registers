* finfet testbench

simulator lang=spice

.lib '../modelfiles/models' ptm16lstp
.include '../modelfiles/lstp/16nfet.pm'
.include '../modelfiles/lstp/16pfet.pm'

.PARAM vd=0.85
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
************** XOR2
****************************************************
.SUBCKT tgxor2 in0 in1 out
XINV0 in1 nin1 inv
Mn0 out nin1 in0 gnd! nfet
Mp0 out in1 in0 vdd! pfet
Mn1 out in0 nin1 gnd! nfet
Mp1 out in0 in1 vdd! pfet
.ENDS

****************************************************
************** INSTANCES
****************************************************
XBUF0 A AA buf
XBUF1 B BB buf

XTGXOR2 AA BB W tgxor2

XBUF2 W WW buf

* CAPS
C1 WW gnd! 1fF

****************************************************
************** SUPPLY
****************************************************
Vvdd vdd! 0 0.85v
Vgnd gnd! 0 0v


****************************************************
************** STIMULUS
****************************************************
VIN0 A 0 0 pulse 0 0.85 0 5p 5p 2n 4n
VIN1 B 0 0 pulse 0 0.85 0 5p 5p 6n 12n

* .DC VIN 0 1.8 0.01 

.tran 10p 50n $ sweep var 2 10 1


****************************************************
************** MEASUREMENTS
****************************************************
.meas tran tphl_inv trig v(aa) td=6n val='vdd/2' cross=1
+                   targ v(w) td=6n val='vdd/2' cross=1

.meas tran tplh_inv trig v(aa) td=8n val='vdd/2' cross=1
+                   targ v(w) td=8n val='vdd/2' cross=1

.meas tran trise_inv trig v(w) val=0.085 rise=2
+                    targ v(w) val='vdd*0.9' rise=2

.meas tran tfall_inv trig v(w) val='vdd*0.9' fall=2
+                    targ v(w) val='vdd*0.1' fall=2


.meas tran avgpower AVG power from=1n to=50n


.END

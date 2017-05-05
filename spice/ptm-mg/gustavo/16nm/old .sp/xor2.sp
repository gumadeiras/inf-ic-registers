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
************** XOR2
****************************************************
.SUBCKT xor2 in0 in1 out
XINV0 in0 nin0 inv
XINV1 in1 nin1 inv
Mn00 out nin0 nnode0 gnd! nfet
Mn10 nnode0 nin1 gnd! gnd! nfet
Mn01 out in0 nnode1 gnd! nfet
Mn11 nnode1 in1 gnd! gnd! nfet
Mp00 pnode0 nin0 vdd! vdd! pfet
Mp10 out in1 pnode0 vdd! pfet
Mp01 pnode1 in0 vdd! vdd! pfet
Mp11 out nin1 pnode1 vdd! pfet
.ENDS

****************************************************
************** INSTANCES
****************************************************
XBUF0 A AA buf
XBUF1 B BB buf

XXOR2 AA BB W xor2

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
VIN0 A 0 0 pulse 0 0.85 0 1p 1p 2n 4n 
VIN1 B 0 0 pulse 0 0.85 0 1p 1p 6n 12n

* .DC VIN 0 1.8 0.01 

.tran 10p 50n 


****************************************************
************** MEASUREMENTS
****************************************************
.meas tran tphl_inv trig v(aa) td=6n val='vdd/2' cross=1
+                   targ v(w) td=6n val='vdd/2' cross=1

.meas tran tplh_inv trig v(aa) td=8n val='vdd/2' cross=1
+                   targ v(w) td=8n val='vdd/2' cross=1

.meas tran trise_inv trig v(w) val='vdd*0.1' rise=2
+                    targ v(w) val='vdd*0.9' rise=2

.meas tran tfall_inv trig v(w) val='vdd*0.9' fall=2
+                    targ v(w) val='vdd*0.1' fall=2


.meas tran avgpower AVG power from=1n to=50n


.END

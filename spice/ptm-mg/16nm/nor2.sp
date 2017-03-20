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
************** NOR2
****************************************************
.SUBCKT nor2 in0 in1 out
Mn0 out in0 gnd! gnd! nfet
Mn1 out in1 gnd! gnd! nfet
Mp0 out in0 pnode vdd! pfet
Mp1 pnode in1 vdd! vdd! pfet
.ENDS

****************************************************
************** INSTANCES
****************************************************
* INPUTS THROUGH BUFFER
XBUF0 A AA buf
XBUF1 B BB buf

XNOR2 AA BB F nor2

XBUF2 F FF buf

* CAPS
C0 FF gnd! 2fF

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

.tran 10p 60n 


****************************************************
************** MEASUREMENTS
****************************************************
.meas tran tphl_nor2 trig v(aa1) td=10n val='vdd/2' cross=1
+             targ v(l)  td=10n val='vdd/2' cross=1

.meas tran tplh_nor2 trig v(aa1) td=8n val='vdd/2' cross=1
+             targ v(l) td=8n val='vdd/2' cross=1

.meas tran trise_nor2 trig v(l) td=8n val='vdd*0.1' cross=1
+              targ v(l) td=8n val='vdd*0.9' cross=1

.meas tran tfall_nor2 trig v(l) td=10n val='vdd*0.9' cross=1
+              targ v(l) td=10n val='vdd*0.1' cross=1

.meas tran avgpower AVG power from=1n to=60n


.END
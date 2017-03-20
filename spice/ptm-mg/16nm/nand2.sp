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
XBUF1 B BB buf

XNAND2 AA BB F nand2

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
VINA A 0 dc=0v
VIN1 B 0 0 pulse 0 0.85 0 50p 50p 2n 4n

.tran 10p 50n 


****************************************************
************** MEASUREMENTS
****************************************************
.meas tran trise_nand2 trig v(w) td=16n val='vdd*0.1' cross=1
+ 		 	targ v(w) td=16n val='vdd*0.9' cross=1

.meas tran tfall_nand2 trig v(w) td=14n val='vdd*0.9' cross=1
+ 			targ v(w) td=14n val='vdd*0.1' cross=1

.meas tran tphl_nand2 trig v(aa0) td=14n val='vdd/2' cross=1
+              targ v(w)  td=14n val='vdd/2' cross=1

.meas tran tplh_nand2 trig v(aa0) td=16n val='vdd/2' cross=1
+              targ v(w) td=16n val='vdd/2' cross=1

.meas tran avgpower AVG power from=1n to=50n


.END
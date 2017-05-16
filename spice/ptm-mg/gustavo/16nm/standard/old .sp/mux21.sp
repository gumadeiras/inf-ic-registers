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
************** TRANSMISSION GATE
****************************************************
.SUBCKT tgn drain gate source
XINV0 gate ngate inv
Mn0 drain ngate source gnd! nfet
Mp0 drain gate source vdd! pfet
.ENDS
.SUBCKT tgp drain gate source
XINV0 gate ngate inv
Mn0 drain gate source gnd! nfet
Mp0 drain ngate source vdd! pfet
.ENDS

****************************************************
************** MUX 2:1
****************************************************
.SUBCKT mux21 in0 in1 sel out
* XINV sel nsel inv
* * SEL = 0
* Mn0 out nsel in0 gnd! nfet
* Mp0 out sel in0 vdd! pfet
* * SEL = 1
* Mn1 out sel in1 gnd! nfet
* Mp1 out nsel in1 vdd! pfet
XTG0 out sel in0 tgn
XTG1 out sel in1 tgp
.ENDS


****************************************************
************** INSTANCES
****************************************************
XBUF0 A AA buf
XBUF1 B BB buf
XBUF2 C CC buf

XMUX0 AA BB CC M mux21
XMUX1 M AA CC W mux21

* OUTPUT ~> INV
XBUF3 W E buf

* CAPS
C0 E gnd! 1fF

****************************************************
************** SUPPLY
****************************************************
Vvdd vdd! 0 0.85v
Vgnd gnd! 0 0v


****************************************************
************** STIMULUS
****************************************************
VIN0 A 0 dc=0v
VIN1 B 0 dc=0.85v
VIN2 C 0 0 pulse 0 0.85 0 5p 5p 4n 8n 

* .DC VIN 0 1.8 0.01 

.tran 10p 60n 

************************** INV
.meas tran tphl_inv trig v(aa) td=6n val='vdd/2' cross=1
+            targ v(aaa) td=6n val='vdd/2' cross=1

.meas tran tplh_inv trig v(aa) td=8n val='vdd/2' cross=1
+            targ v(aaa) td=8n val='vdd/2' cross=1

.meas tran trise_inv trig v(aaa) td=8n val='vdd*0.1' cross=1
+             targ v(aaa) td=8n val='vdd*0.9' cross=1

.meas tran tfall_inv trig v(aaa) td=6n val='vdd*0.9' cross=1
+             targ v(aaa) td=6n val='vdd*0.1' cross=1


.meas tran avgpower AVG power from=1n to=60n



.END

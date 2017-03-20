* Basic Inverter with finfet
.lib '../modelfiles/models' ptm16lstp
.include '../modelfiles/lstp/16nfet.pm'
.include '../modelfiles/lstp/16pfet.pm'

.PARAM vdd=0.85
.OPTION POST=2
.GLOBAL gnd! vdd!

.SUBCKT inv vi vo
MM1 vo vi gnd! gnd! nfet
MM0 vo vi vdd! vdd! pfet
.ENDS

.SUBCKT buf vi vo
XINV0 vi _vo inv
XINV1 _vo vo inv
.ENDS

XBUF0 a a1 buf

XINV0 a1 a11 INV
XINV1 a11 a22 INV
XINV2 a22 W INV

XBUF1 w B buf


C0 B gnd! 2fF

Vvdd vdd! 0 0.85v
Vgnd gnd! 0 0v

*VIN A 0 

VIN A 0 0 pulse 0 0.85 0 50p 50p 2n 4n 

*DC VIN 0 1.8 0.01 


.tran 10p 10n 


.meas tran trise_nand2 trig v(w) td=16n val='vdd*0.1' cross=1
+           targ v(w) td=16n val='vdd*0.9' cross=1

.meas tran tfall_nand2 trig v(w) td=14n val='vdd*0.9' cross=1
+           targ v(w) td=14n val='vdd*0.1' cross=1

.meas tran tphl_nand2 trig v(aa0) td=14n val='vdd/2' cross=1
+              targ v(w)  td=14n val='vdd/2' cross=1

.meas tran tplh_nand2 trig v(aa0) td=16n val='vdd/2' cross=1
+              targ v(w) td=16n val='vdd/2' cross=1

.meas tran avgpower AVG power from=1n to=10n

.END
* finfet testbench

.lib '../modelfiles/models' ptm16lstp
.include '../modelfiles/lstp/16nfet.pm'
.include '../modelfiles/lstp/16pfet.pm'

.OPTION POST=2
.GLOBAL gnd! vdd!

****************************************************
************** INV
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
************** NOR2
****************************************************
.SUBCKT nor2 in0 in1 out
Mn0 out in0 gnd! gnd! nfet
Mn1 out in1 gnd! gnd! nfet
Mp0 out in0 pnode vdd! pfet
Mp1 pnode in1 vdd! vdd! pfet
.ENDS

****************************************************
************** MUX 2:1
****************************************************
.SUBCKT mux21 in0 in1 sel0 out
XINV sel nsel inv
* SEL = 0
Mn0 out nsel in0 gnd! nfet
Mp0 out sel in0 vdd! pfet
* SEL = 1
Mn1 out sel in1 gnd! nfet
Mp1 out nsel in1 vdd! pfet
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

***************************************************
************** REGISTER (MUX BASED)
****************************************************
.SUBCKT regmux data out clk
XINV0 clk nclk inv
XINV1 data ndata inv
XINV2 out0 out inv
XINV3 out keeper inv
* CLK = 0
Mn0 out0 nclk keeper gnd! nfet
Mp0 out0 clk keeper vdd! pfet
* CLK = 1
Mn1 out0 clk ndata gnd! nfet
Mp1 out0 nclk ndata vdd! pfet
.ENDS

****************************************************
************** REGISTER (TSPC)
****************************************************
.SUBCKT regtspc data out clk
*FIRST STAGE
Mp0 pnode0 data vdd! vdd! pfet
Mp1 out0 clk pnode0 vdd! pfet
Mn0 out0 data gnd! gnd! nfet
*SECOND STAGE
Mp2 out1 clk vdd! vdd! pfet
Mn1 out1 out0 nnode0 gnd! nfet
Mn2 nnode0 clk gnd! gnd! nfet
*THIRD STAGE
Mp3 out2 out1 vdd! vdd! pfet
Mn3 out2 clk nnode1 gnd! nfet
Mn4 nnode1 out1 gnd! gnd! nfet
XINV out2 out inv
.ENDS

****************************************************
************** HALF-ADDER
****************************************************
.SUBCKT ha in0 in1 cout sum
XXOR in0 in1 sum
XNAND in0 in1 ncout
XINV ncout cout
.ENDS

****************************************************
************** FULL-ADDER
****************************************************
.SUBCKT fa in0 in1 cin cout sum 
XHA0 in0 in1 hasum hacout ha
XHA1 cin hasum sum cout ha
.ENDS


****************************************************
************** INSTANCES
****************************************************
XINV00 A00 AA0 inv $ A00 = 0V
XINV01 A01 AA1 inv $ A01 = 0.85V
XINV0 A AA inv
XINV1 B BB inv
XINV2 C CC inv
XINV3 D DD inv

*** INV EVAL

XINV4 AA AAA inv
XINB5 AAA AAAA inv

****************************************************
************************** NAND2 & NOR2
****************************************************

XNAND20 AA0 BB W nand2
XNOR20 AA1 BB L nor2

* OUTPUT ~> INV
XINV6 W E inv
XINV7 L R inv

* CAPS
CINV gnd! 2fF
C0 E gnd! 2fF
C1 R gnd! 2fF

****************************************************
************************** 1-BIT FULL ADDER
****************************************************


****************************************************
************************** 4-BIT FULL ADDER
****************************************************


****************************************************
************** SUPPLY
****************************************************
Vvdd vdd! 0 0.85v
Vgnd gnd! 0 0v


****************************************************
************** STIMULUS
****************************************************
VIN00 A00 0 dc=0v
VIN01 A01 0 dc=0.85v
VIN0 A 0 0 pulse 0 0.85 0 50p 50p 2n 4n 
VIN1 B 0 0 pulse 0 0.85 0 50p 50p 4n 8n

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


************************** NOR2
.meas tran tphl_nor2 trig v(aa1) td=10n val='vdd/2' cross=1
+             targ v(l)  td=10n val='vdd/2' cross=1

.meas tran tplh_nor2 trig v(aa1) td=8n val='vdd/2' cross=1
+             targ v(l) td=8n val='vdd/2' cross=1

.meas tran trise_nor2 trig v(l) td=8n val='vdd*0.1' cross=1
+              targ v(l) td=8n val='vdd*0.9' cross=1

.meas tran tfall_nor2 trig v(l) td=10n val='vdd*0.9' cross=1
+              targ v(l) td=10n val='vdd*0.1' cross=1


************************** NAND2
.meas tran tphl_nand2 trig v(aa0) td=14n val='vdd/2' cross=1
+              targ v(w)  td=14n val='vdd/2' cross=1

.meas tran tplh_nand2 trig v(aa0) td=16n val='vdd/2' cross=1
+              targ v(w) td=16n val='vdd/2' cross=1

.meas tran trise_nand2 trig v(w) td=16n val='vdd*0.1' cross=1
+           targ v(w) td=16n val='vdd*0.9' cross=1

.meas tran tfall_nand2 trig v(w) td=14n val='vdd*0.9' cross=1
+           targ v(w) td=14n val='vdd*0.1' cross=1

.meas tran avgpower AVG power from=1n to=60n



.END

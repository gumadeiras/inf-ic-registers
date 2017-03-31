* cell lib

simulator lang=spectre
simulator lang=spice

.OPTION POST=2
.GLOBAL gnd! vdd!

****************************************************
************ ** INVERTER
****************************************************
.SUBCKT inv vi vo
Mn0 vo vi gnd! gnd! nfet
Mp0 vo vi vdd! vdd! pfet
.ENDS 

****************************************************
************** TRI-STATE INVERTER
****************************************************
.SUBCKT tsinv vi vo nclk pclk
Mn0 nnode vi gnd! gnd! nfet
Mn1 vo nclk nnode gnd! nfet
Mp0 pnode vi vdd! vdd! pfet
Mp1 vo pclk pnode vdd! pfet
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
.SUBCKT tgn drain gate ngate source
Mn0 drain gate source gnd! nfet
Mp0 drain ngate source vdd! pfet
.ENDS
.SUBCKT tgp drain gate ngate source
Mn0 drain ngate source gnd! nfet
Mp0 drain gate source vdd! pfet
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
************** TG XOR2
****************************************************
.SUBCKT tgxor2 in0 in1 out
XINV0 in1 nin1 inv
Mn0 out nin1 in0 gnd! nfet
Mp0 out in1 in0 vdd! pfet
Mn1 out in0 nin1 gnd! nfet
Mp1 out in0 in1 vdd! pfet
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
************** REGISTER - TSPC
****************************************************
.SUBCKT tspc data out clk
* FIRST STAGE
Mp0 pnode0 data vdd! vdd! pfet
Mp1 out0 clk pnode0 vdd! pfet
Mn0 out0 data gnd! gnd! nfet
* SECOND STAGE
Mp2 out1 clk vdd! vdd! pfet
Mn1 out1 out0 nnode0 gnd! nfet
Mn2 nnode0 clk gnd! gnd! nfet
* THIRD STAGE
Mp3 out2 out1 vdd! vdd! pfet
Mn3 out2 clk nnode1 gnd! nfet
Mn4 nnode1 out1 gnd! gnd! nfet
XINV out2 out inv
.ENDS

****************************************************
************** REGISTER - CLOCKED CMOS DFF
****************************************************
.SUBCKT ccmos data out clk
XINV0 clk nclk inv
XTSINV1 data out1 nclk clk tsinv
XINV3 out1 out3 inv
XTSINV2 out3 out1 clk nclk tsinv
XTSINV4 out1 out clk nclk tsinv
XINV6 out out6 inv
XTSINV5 out6 out nclk clk tsinv
.ENDS

****************************************************
************** REGISTER - MUX NAND INV DFF
****************************************************
.SUBCKT muxnand data out clk
* SLAVE
XNAND1 data clk  out1 nand2
XINV2  clk  out2      inv
XNAND3 out2 out4 out3 nand2
XNAND4 out1 out3 out4 nand2
* MASTER
XNAND5 out  clk  out5 nand2
*XINV6  clk  out6      inv
XNAND7 out2 out4 out7 nand2
XNAND8 out5 out7 out  nand2
.ENDS

****************************************************
************** REGISTER - NAND INV DFF
****************************************************
.SUBCKT nandinv data out clk
XNAND1 out4 out2 out1 nand2
XNAND2 out1 clk  out2 nand2
XNAND3 out2 out4 out3 nand2
XNAND4 out6 data out4 nand2
XINV5  out3 out5 inv
XNAND6 clk  out5 out6 nand2
XNAND7 out2 out8 out  nand2
XNAND8 out  out6 out8 nand2
.ENDS

****************************************************
************** REGISTER - POWERPC DFF
****************************************************
.SUBCKT powerpc data out clk
XINV0 clk nclk inv
XTG1 out1 clk nclk data tgp
XINV2 out1 out2 inv
XTSINV3 out2 out3 clk nclk tsinv
XTG4 out2 clk nclk out4 tgn
XINV5 out4 out inv
XTSINV6 out out4 nclk clk tsinv
.ENDS

****************************************************
************** REGISTER - RACEFREE NAND INV DFF
****************************************************
.SUBCKT racefreenand data out clk
XNAND1 out4  out2  out1 nand2
XNAND2 data  out5  out2 nand2
XINV3  out1  nout1      inv
XNAND4 out1  clk   out4 nand2
XNAND5 nout1 clk   out5 nand2
XNAND6 out4  out7  out  nand2
XNAND7 out   out5  out7 nand2
.ENDS

****************************************************
************** REGISTER - SINGLEPASS DFF
****************************************************
.SUBCKT singlepass data out clk
Mn1 out1 clk data pfet
Mn2 out1 clk out4 nfet
XINV3 out1 out3 inv
XINV4 out3 out4 inv
Mn5 out5 clk out3 nfet
Mn6 out5 clk out8 pfet
XINV7 out5 out inv
XINV8 out out8 inv
.ENDS

****************************************************
************** REGISTER - TG INV DFF
****************************************************
.SUBCKT tgregister data out clk
XINV0 clk nclk inv
XTG1 out1 clk nclk data tgp
XTG2 out1 clk nclk out4 tgn
XINV3 out1 out3 inv
XINV4 out3 out4 inv
XTG5 out3 clk nclk out5 tgn
XTG6 out8 clk nclk out6 tgp
XINV7 out5 out inv
XINV8 out out8 inv
.ENDS


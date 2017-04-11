* cell lib

simulator lang=spectre
simulator lang=spice

.OPTION POST=2
.GLOBAL cgnd cvdd

****************************************************
************ ** INVERTER
****************************************************
.SUBCKT inv vi vo cvdd cgnd
Mn0 vo vi cgnd cgnd nfet
Mp0 vo vi cvdd cvdd pfet
.ENDS 

****************************************************
************** TRI-STATE INVERTER
****************************************************
.SUBCKT tsinv vi vo nclk pclk cvdd cgnd
Mn0 nnode vi cgnd cgnd nfet
Mn1 vo nclk nnode cgnd nfet
Mp0 pnode vi cvdd cvdd pfet
Mp1 vo pclk pnode cvdd pfet
.ENDS 

****************************************************
************** BUFFER
****************************************************
.SUBCKT buf vi vo cvdd cgnd
XINV0 vi _vo cvdd cgnd inv
XINV1 _vo vo cvdd cgnd inv
.ENDS

****************************************************
************** TRANSMISSION GATE
****************************************************
.SUBCKT tgn drain gate ngate source cvdd cgnd
Mn0 drain gate source cgnd nfet
Mp0 drain ngate source cvdd pfet
.ENDS
.SUBCKT tgp drain gate ngate source cvdd cgnd
Mn0 drain ngate source cgnd nfet
Mp0 drain gate source cvdd pfet
.ENDS

****************************************************
************** NAND2
****************************************************
.SUBCKT nand2 in0 in1 out cvdd cgnd
Mn0 out in0 nnode cgnd nfet
Mn1 nnode in1 cgnd cgnd nfet
Mp0 out in0 cvdd cvdd pfet
Mp1 out in1 cvdd cvdd pfet
.ENDS

****************************************************
************** NOR2
****************************************************
.SUBCKT nor2 in0 in1 out cvdd cgnd
Mn0 out in0 cgnd cgnd nfet
Mn1 out in1 cgnd cgnd nfet
Mp0 out in0 pnode cvdd pfet
Mp1 pnode in1 cvdd cvdd pfet
.ENDS

****************************************************
************** XOR2
****************************************************
.SUBCKT xor2 in0 in1 out cvdd cgnd
XINV0 in0 nin0 cvdd cgnd inv
XINV1 in1 nin1 cvdd cgnd inv
Mn00 out nin0 nnode0 cgnd nfet
Mn10 nnode0 nin1 cgnd cgnd nfet
Mn01 out in0 nnode1 cgnd nfet
Mn11 nnode1 in1 cgnd cgnd nfet
Mp00 pnode0 nin0 cvdd cvdd pfet
Mp10 out in1 pnode0 cvdd pfet
Mp01 pnode1 in0 cvdd cvdd pfet
Mp11 out nin1 pnode1 cvdd pfet
.ENDS

****************************************************
************** TG XOR2
****************************************************
.SUBCKT tgxor2 in0 in1 out cvdd cgnd
XINV0 in1 nin1 cvdd cgnd inv
Mn0 out nin1 in0 cgnd nfet
Mp0 out in1 in0 cvdd pfet
Mn1 out in0 nin1 cgnd nfet
Mp1 out in0 in1 cvdd pfet
.ENDS

****************************************************
************** MUX 2:1
****************************************************
.SUBCKT mux21 in0 in1 sel out cvdd cgnd
* XINV sel nsel inv
* * SEL = 0
* Mn0 out nsel in0 cgnd nfet
* Mp0 out sel in0 cvdd pfet
* * SEL = 1
* Mn1 out sel in1 cgnd nfet
* Mp1 out nsel in1 cvdd pfet
XTG0 out sel in0 cvdd cgnd tgn
XTG1 out sel in1 cvdd cgnd tgp
.ENDS

****************************************************
************** REGISTER - TSPC
****************************************************
.SUBCKT tspc data out clk cvdd cgnd
* FIRST STAGE
Mp0 pnode0 data cvdd cvdd pfet
Mp1 out0 clk pnode0 cvdd pfet
Mn0 out0 data cgnd cgnd nfet
* SECOND STAGE
Mp2 out1 clk cvdd cvdd pfet
Mn1 out1 out0 nnode0 cgnd nfet
Mn2 nnode0 clk cgnd cgnd nfet
* THIRD STAGE
Mp3 out2 out1 cvdd cvdd pfet
Mn3 out2 clk nnode1 cgnd nfet
Mn4 nnode1 out1 cgnd cgnd nfet
XINV out2 out cvdd cgnd inv
.ENDS

****************************************************
************** REGISTER - CLOCKED CMOS DFF
****************************************************
.SUBCKT ccmos data out clk cvdd cgnd
XINV0 clk nclk cvdd cgnd inv
XTSINV1 data out1 nclk clk cvdd cgnd tsinv
XINV3 out1 out3 cvdd cgnd inv
XTSINV2 out3 out1 clk nclk cvdd cgnd tsinv
XTSINV4 out1 out clk nclk cvdd cgnd tsinv
XINV6 out out6 cvdd cgnd inv
XTSINV5 out6 out nclk clk cvdd cgnd tsinv
.ENDS

****************************************************
************** REGISTER - MUX NAND INV DFF
****************************************************
.SUBCKT muxnand data out clk cvdd cgnd
* SLAVE
XNAND1 data clk  out1 cvdd cgnd nand2
XINV2  clk  out2      cvdd cgnd inv
XNAND3 out2 out4 out3 cvdd cgnd nand2
XNAND4 out1 out3 out4 cvdd cgnd nand2
* MASTER
XNAND5 out  clk  out5 cvdd cgnd nand2
*XINV6  clk  out6      inv
XNAND7 out2 out4 out7 cvdd cgnd nand2
XNAND8 out5 out7 out  cvdd cgnd nand2
.ENDS

****************************************************
************** REGISTER - NAND INV DFF
****************************************************
.SUBCKT nandinv data out clk cvdd cgnd
XNAND1 out4 out2 out1 cvdd cgnd nand2
XNAND2 out1 clk  out2 cvdd cgnd nand2
XNAND3 out2 out4 out3 cvdd cgnd nand2
XNAND4 out6 data out4 cvdd cgnd nand2
XINV5  out3 out5 cvdd cgnd inv
XNAND6 clk  out5 out6 cvdd cgnd nand2
XNAND7 out2 out8 out cvdd cgnd  nand2
XNAND8 out  out6 out8 cvdd cgnd nand2
.ENDS

****************************************************
************** REGISTER - POWERPC DFF
****************************************************
.SUBCKT powerpc data out clk cvdd cgnd
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
.SUBCKT racefreenand data out clk cvdd cgnd
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
.SUBCKT singlepass data out clk cvdd cgnd
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
.SUBCKT tgregister data out clk cvdd cgnd
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

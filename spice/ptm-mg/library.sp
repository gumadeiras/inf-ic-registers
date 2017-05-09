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
Mp0 vo vi cvdd cvdd pfet nfin=2
.ENDS 
**************************************************
*********** 	INVERTER X2 (Luiz)
************************************************
.SUBCKT invx2 vi vo cvdd cgnd
MP0 vo vi cvdd cvdd pfet nfin = 4
MN0 vo vi cgnd cgnd nfet nfin = 2
.ENDS
****************************************************
************** TRI-STATE INVERTER
****************************************************
.SUBCKT tsinv vi vo nclk pclk cvdd cgnd
Mn0 nnode vi cgnd cgnd nfet
Mn1 vo nclk nnode cgnd nfet
Mp0 pnode vi cvdd cvdd pfet nfin=2
Mp1 vo pclk pnode cvdd pfet nfin=2
.ENDS 

****************************************************
************** BUFFER
****************************************************
.SUBCKT buf vi vo cvdd cgnd
XINV0 vi _vo cvdd cgnd inv
XINV1 _vo vo cvdd cgnd inv
.ENDS

**************************************************
*************** BUFFER X2
***********************************************
.SUBCKT buffx2 vi vo cvdd cgnd
xInv0 vi _vo cvdd cgnd inv
xInv1 _vo vo cvdd cgnd invx2
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
Mp0 out in0 cvdd cvdd pfet nfin=2
Mp1 out in1 cvdd cvdd pfet nfin=2
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
************** TG MUX 2:1
****************************************************
.SUBCKT mux21 in0 in1 sel out cvdd cgnd
MP0 selinv sel cvdd cvdd pfet
MN0 selinv sel cgnd cgnd nfet

MP1 in0 sel out cvdd pfet
MN1 in0 selinv out cgnd nfet

MP2 in1 selinv out cvdd pfet
MN2 in1 sel out cgnd nfet
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
Mn1 out1 out0 nnode0 cgnd nfet nfin=2
Mn2 nnode0 clk cgnd cgnd nfet nfin=2
* THIRD STAGE
Mp3 out2 out1 cvdd cvdd pfet
Mn3 out2 clk nnode1 cgnd nfet
Mn4 nnode1 out1 cgnd cgnd nfet
XINV out2 out cvdd cgnd inv
.ENDS

*************************************************
************** REGISTER - TSPCR  (Luiz)
************************************************
.SUBCKT TSPCR D CLK Q cvdd cgnd
MP0 1 D cvdd cvdd pfet
MP1 nodeX CLK 1 cvdd pfet
MN0 nodeX D cgnd cgnd nfet

MP2 nodeY CLK cvdd cvdd pfet
MN1 nodeY nodeX 2 cgnd nfet $ utilizando duas fins, nodeX cai a VDD/2 na subida do CLK e D=0
MN2 2 CLK cgnd cgnd nfet

MP3 notQ nodeY cvdd cvdd pfet
MN3 notQ CLK 3 cgnd nfet
MN4 3 nodeY cgnd cgnd nfet

xINV Q notQ cvdd cgnd inv
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

**********************************************
********** REGISTER - C2MOS Rabaey (Luiz)
*********************************************
.SUBCKT c2mos D CLK Q cvdd cgnd
MP0 1 D cvdd cvdd pfet
MP1 nodeX CLK 1 cvdd pfet

MN0 nodeX CLKinv 2 cgnd nfet
MN1 2 D cgnd cgnd nfet

MP2 3 nodeX cvdd cvdd pfet
MP3 Q CLKinv 3 cvdd pfet

MN2 Q CLK 4 cgnd nfet
MN3 4 nodeX cgnd cgnd nfet

xInv CLK CLKinv cvdd cgnd inv
.ENDS
 
*************************************************
************ REGISTER - TG MUX  (Luiz)
***********************************************
.SUBCKT tgmuxreg D CLK Q cvdd cgnd
xInvCLK CLK CLKinv cvdd cgnd inv
xInvD D Dinv cvdd cgnd inv

MP0 Qminv CLKinv 1 cvdd pfet
MN0 Qminv CLK 1 cgnd nfet

MP1 Dinv CLK 1 cvdd pfet
MN1 Dinv CLKinv 1 cgnd nfet

xInv1 1 Qm cvdd cgnd inv
xInvQm Qm Qminv cvdd cgnd inv

xInv2 Qm 2 cvdd cgnd inv
xInvQ Q Qinv cvdd cgnd inv
xInv3 3 Q cvdd cgnd inv

MP2 Qinv CLK 3 cvdd pfet
MN2 Qinv CLKinv 3 cgnd nfet

MP3 2 CLKinv 3 cvdd pfet
MN3 2 CLK 3 cgnd nfet
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
XINV6  clk  out6      cvdd cgnd inv
XNAND7 out6 out4 out7 cvdd cgnd nand2
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
XINV0 clk nclk cvdd cgnd inv
XTG1 out1 clk nclk data cvdd cgnd tgp
XINV2 out1 out2 cvdd cgnd inv
XTSINV3 out2 out3 clk nclk cvdd cgnd tsinv
XTG4 out2 clk nclk out4 cvdd cgnd tgn
XINV5 out4 out cvdd cgnd inv
XTSINV6 out out4 nclk clk cvdd cgn tsinv
.ENDS

****************************************************
************** REGISTER - RACEFREE NAND INV DFF
****************************************************
.SUBCKT racefreenand data out clk cvdd cgnd
XNAND1 out4  out2  out1 cvdd cgnd nand2
XNAND2 data  out5  out2 cvdd cgnd nand2
XINV3  out1  nout1      cvdd cgnd inv
XNAND4 out1  clk   out4 cvdd cgnd nand2
XNAND5 nout1 clk   out5 cvdd cgnd nand2
XNAND6 out4  out7  out  cvdd cgnd nand2
XNAND7 out   out5  out7 cvdd cgnd nand2
.ENDS

****************************************************
************** REGISTER - SINGLEPASS DFF
****************************************************
.SUBCKT singlepass data out clk cvdd cgnd
Mn1 out1 clk data cvdd pfet nfin=3
Mn2 out1 clk out4 cgnd nfet
XINV3 out1 out3 cvdd cgnd inv
XINV4 out3 out4 cvdd cgnd inv
Mn5 out5 clk out3 cgnd nfet nfin=3
Mn6 out5 clk out8 cvdd pfet
XINV7 out5 out cvdd cgnd inv
XINV8 out out8 cvdd cgnd inv
.ENDS

****************************************************
************** REGISTER - TG INV DFF
****************************************************
.SUBCKT tgregister data out clk cvdd cgnd
XINV0 clk nclk cvdd cgnd inv
XTG1 out1 clk nclk data cvdd cgnd tgp
XTG2 out1 clk nclk out4 cvdd cgnd tgn
XINV3 out1 out3 cvdd cgnd inv
XINV4 out3 out4 cvdd cgnd inv
XTG5 out5 clk nclk out3 cvdd cgnd tgn
XTG6 out6 clk nclk out8 cvdd cgnd tgp
XINV7 out5 out cvdd cgnd inv
XINV8 out out8 cvdd cgnd inv
.ENDS

****************************************************
************** REGISTER - MUX XNOR DFF
****************************************************
.SUBCKT xnormux data out clk cvdd cgnd
XINV5 clk nclk cvdd cgnd inv
Mp11 pnode10 nclk cvdd cvdd pfet nfin=2
Mp12 out1 data pnode10 cvdd pfet nfin=2
Mp13 pnode11 clk cvdd cvdd pfet nfin=2
Mp14 out1 out6 pnode11 cvdd pfet nfin=2
Mn21 out1 data nnode20 cgnd nfet
Mn22 nnode20 clk cgnd cgnd nfet
Mn23 out1 out6 nnode21 cgnd nfet
Mn24 nnode21 nclk cgnd cgnd nfet
XINV6 out1 out6 cvdd cgnd inv
* SECOND MUX
Mp211 pnode01 clk cvdd cvdd pfet nfin=2
Mp212 in8 out pnode01 cvdd pfet nfin=2
Mp213 pnode12 nclk cvdd cvdd pfet nfin=2
Mp214 in8 out6 pnode12 cvdd pfet nfin=2
Mn221 in8 out nnode02 cgnd nfet
Mn222 nnode02 nclk cgnd cgnd nfet
Mn223 in8 out6 nnode22 cgnd nfet
Mn224 nnode22 clk cgnd cgnd nfet
XINV7 in8 out cvdd cgnd inv
.ENDS

* finfet testbench

simulator lang=spice

.lib '../../modelfiles/models' ptm16lstp
.include '../../modelfiles/lstp/16nfet.pm'
.include '../../modelfiles/lstp/16pfet.pm'

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
************** NAND2
****************************************************
.SUBCKT nand2 in0 in1 out
Mn0 out in0 nnode gnd! nfet
Mn1 nnode in1 gnd! gnd! nfet
Mp0 out in0 vdd! vdd! pfet
Mp1 out in1 vdd! vdd! pfet
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
************** INSTANCES
****************************************************
XBUF0 databuffer data0 buf

XNANDIV0 data0 rdata0 CLK nandinv
XNANDIV1 rdata0 rdata1 CLK nandinv
XNANDIV2 rdata1 rdata2 CLK nandinv

XBUF1 rdata2 E buf

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
VIN0 CLK 0 0 pulse 0 0.85 0 50p 50p 2n 4n 
VIN1 databuffer 0 0 pulse 0 0.85 3n 50p 50p 4n 8n 

* .DC VIN 0 1.8 0.01 

.tran 10p 40n 

.meas tran avgpower AVG power from=1n to=60n



.END

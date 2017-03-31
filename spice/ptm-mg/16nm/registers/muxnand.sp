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
************** INSTANCES
****************************************************
XBUF0 databuffer data0 buf

XMUXNAND0 data0 rdata0 CLK muxnand
XMUXNAND1 rdata0 rdata1 CLK muxnand
XMUXNAND2 rdata1 rdata2 CLK muxnand

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

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
************** REGISTER - MUX NAND INV DFF
****************************************************
.SUBCKT xnormux data out clk
XINV5 clk nclk inv
Mp11 pnode10 nclk vdd! vdd! pfet
Mp12 out1 data pnode10 vdd! pfet
Mp13 pnode11 clk vdd! vdd! pfet
Mp14 out1 out6 pnode11 vdd! pfet
Mn21 out1 data nnode20 gnd! nfet
Mn22 nnode20 clk gnd! gnd! nfet
Mn23 out1 out6 nnode21 gnd! nfet
Mn24 nnode21 nclk gnd! gnd! nfet
XINV6 out1 out6 inv
* SECOND MUX



.ENDS

****************************************************
************** INSTANCES
****************************************************
XBUF0 databuffer data0 buf

XXNORMUX0 data0 rdata0 CLK xnormux
XXNORMUX1 rdata0 rdata1 CLK xnormux
XXNORMUX2 rdata1 rdata2 CLK xnormux

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

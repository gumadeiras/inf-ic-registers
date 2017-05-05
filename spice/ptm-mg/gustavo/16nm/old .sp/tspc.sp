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
************** REGISTER (TSPC)
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
************** INSTANCES
****************************************************
XBUF0 datain data0 buf

XTSPC0 data0 rdata0 CLK tspc
XTSPC1 rdata0 rdata1 CLK tspc
XTSPC2 rdata1 rdata2 CLK tspc

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
VIN1 datain 0 0 pulse 0 0.85 3n 50p 50p 4n 8n 

* .DC VIN 0 1.8 0.01 

.tran 10p 40n 

.meas tran avgpower AVG power from=1n to=60n



.END

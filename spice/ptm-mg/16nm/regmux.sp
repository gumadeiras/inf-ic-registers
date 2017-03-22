* finfet testbench

.lib '../modelfiles/models' ptm16lstp
.include '../modelfiles/lstp/16nfet.pm'
.include '../modelfiles/lstp/16pfet.pm'

.PARAM vdd=0.85
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
************** INSTANCES
****************************************************
XBUF0 datain data0 buf

XREG0 data0 rdata0 CLK regmux

XBUF1 rdata0 E buf

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

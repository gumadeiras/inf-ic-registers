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
************** MUX 2:1
****************************************************
.SUBCKT mux21 in0 in1 sel out
XINV sel nsel inv
* SEL = 0
Mn0 out nsel in0 gnd! nfet
Mp0 out sel in0 vdd! pfet
* SEL = 1
Mn1 out sel in1 gnd! nfet
Mp1 out nsel in1 vdd! pfet
.ENDS

***************************************************
************** REGISTER (MUX BASED)
****************************************************
.SUBCKT regmux data out clk
XINV0 clk nclk inv
XMUX0 keeper data clk keeper mux21
XMUX1 keeper out clk out mux21

* XINV0 clk nclk inv
* XINV1 data ndata inv
* XINV2 out0 out inv
* XINV3 out keeper inv
* * CLK = 0
* Mn0 out0 nclk keeper gnd! nfet
* Mp0 out0 clk keeper vdd! pfet
* * CLK = 1
* Mn1 out0 clk ndata gnd! nfet
* Mp1 out0 nclk ndata vdd! pfet
.ENDS

****************************************************
************** INSTANCES
****************************************************
XBUF0 datain data0 buf

XREG0 data0 rdata0 CLK regmux
XREG1 rdata0 rdata1 CLK regmux
XREG2 rdata1 rdata2 CLK regmux

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
VIN0 CLK 0 0 pulse 0 0.85 0 5p 5p 2n 4n 
VIN1 datain 0 0 pulse 0 0.85 3n 5p 5p 4n 8n 

* .DC VIN 0 1.8 0.01 

.tran 10p 40n 

.meas tran avgpower AVG power from=1n to=60n

.END
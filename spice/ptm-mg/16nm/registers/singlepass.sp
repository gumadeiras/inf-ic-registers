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
************** INSTANCES
****************************************************
XBUF0 databuffer data0 buf

XSINGLEPASS0 data0 rdata0 CLK singlepass
XSINGLEPASS1 rdata0 rdata1 CLK singlepass
XSINGLEPASS2 rdata1 rdata2 CLK singlepass

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

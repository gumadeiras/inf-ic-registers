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
************** INSTANCES
****************************************************
XBUF0 databuffer data0 buf

XCCMOS0 data0 rdata0 CLK ccmos
XCCMOS1 rdata0 rdata1 CLK ccmos
XCCMOS2 rdata1 rdata2 CLK ccmos

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

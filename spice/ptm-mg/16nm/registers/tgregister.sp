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
.SUBCKT tgregister data out clk
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

****************************************************
************** INSTANCES
****************************************************
XBUF0 databuffer data0 buf

XTGREGISTER0 data0 rdata0 CLK tgregister
XTGREGISTER1 rdata0 rdata1 CLK tgregister
XTGREGISTER2 rdata1 rdata2 CLK tgregister

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

* finfet testbench

.simulator lang=spice

.lib '../../modelfiles/models' ptm16lstp
.include '../../modelfiles/lstp/16nfet.pm'
.include '../../modelfiles/lstp/16pfet.pm'

.PARAM vd=0.85
.PARAM DelayTime=0
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
*VIN0 CLK 0 0 pulse 0 0.85 0 50p 50p 2n 4n 
*VIN1 databuffer 0 0 pulse 0 0.85 3n 50p 50p 4n 8n 

*.DC VIN 0 1.8 0.01 

*.tran 10p 40n 

*.meas tran avgpower AVG power from=1n to=60n

.IC v(rdata0)=0
****************
* PWL Stimulus *
****************
vdata databuffer gnd PWL
+ 0n                   0v 
+ 1n                   0v 
+ 2n                   0.85v
+ Td = 'DelayTime'
***********
*  CLOCK  *
***********
vclk CLK gnd PWL
+ 0s        0v
+ 3n        0v
+ 4n        0.85v


*
* Specify DelayTime as the search parameter and provide 
* the lower and upper limits.
*
.Param DelayTime = Opt1 ( 0.0p, 0.0p, 5.0n )

*
* Transient simulation with Bisection Optimization
*
.Tran 1n 10n Sweep Optimize = Opt1
+                 Result   = MaxVout    $ Look at measure
+                 Model    = OptMod

*
* This measure finds the transition
*
.param vih=0.85v

.MEASURE Tran MaxVout Max v(rdata0) Goal = '0.85'

* .Measure Tran pushout When v(rdata0)='vih/2' rise=1 
* * Relative pushout time
* + pushout_per=0.01
* * Absolute pushout time
* *+ pushout = 0.01n

*Comment the above and Uncomment the below for regular passfail run or for pessimistic setup time value
* .Measure Tran pushout Trig v(rdata0)  Val = '0.425' cross=1
* +                       Targ v(CLK) Val = '0.425' cross=1
*
* This measure calculates the setup time value
*
.Measure Tran SetupTime Trig v(data0)  Val = '0.425' cross=1
+                       Targ v(CLK) Val = '0.425' cross=1

*
* Optimization Model
*
.Model OptMod Opt Method = Bisection


.END
 
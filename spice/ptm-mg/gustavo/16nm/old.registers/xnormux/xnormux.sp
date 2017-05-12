* finfet testbench

.simulator lang=spice

.lib '../../modelfiles/models' ptm16lstp
.include '../../modelfiles/lstp/16nfet.pm'
.include '../../modelfiles/lstp/16pfet.pm'

.PARAM vd=0.85
+      DelayTime=0
.OPTION POST=2
+       OPTLST=1 ; display bisec info
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
Mp211 pnode01 clk vdd! vdd! pfet
Mp212 in8 out pnode01 vdd! pfet
Mp213 pnode12 nclk vdd! vdd! pfet
Mp214 in8 out6 pnode12 vdd! pfet
Mn221 in8 out nnode02 gnd! nfet
Mn222 nnode02 nclk gnd! gnd! nfet
Mn223 in8 out6 nnode22 gnd! nfet
Mn224 nnode22 clk gnd! gnd! nfet
XINV7 in8 out inv
.ENDS

****************************************************
************** INSTANCES
****************************************************
XBUF0 databuffer0 data0 buf

XXNORMUX0 data0 rdata0 CLK xnormux

XBUF1 rdata0 E0 buf

C0 E0 gnd! 1fF

****************************************************
************** SUPPLY
****************************************************
Vvdd vdd! 0 'vd'
Vgnd gnd! 0 0v


****************************************************
************** STIMULUS
****************************************************
* clock
vclk CLK gnd PWL
+ 0s          0v 
+ 3.0n        0v
+ 3.05n       'vd'
+ 6.0n        'vd'
+ 6.05n       0v

* initial data value on register out
.IC v(rdata0) = 0
+   v(rdata1) = 0

* data
vdata0 databuffer0 gnd PWL
+ 0ns                      0v 
+ '2.0ns+DelayTime'        0v 
+ '2.05ns+DelayTime'       'vd'
+ '5.0ns+DelayTime'        'vd'
+ '5.05ns+DelayTime'       0v

* search parameter, lower and upper limits.
.Param DelayTime = Opt1 ( 0n, 0n, 5n )

* Transient simulation with Bisection Optimization
.Tran 10p 7n Sweep Optimize = Opt1
+                 Result = pushout
* +                Result = MaxVout
+                 Model = OptMod

* max(vout), ~vdd
.MEASURE Tran MaxVout Max v(rdata0) Goal = 'vd'

* optimistic setup time value
* .Measure Tran pushout When v(rdata0)='vd/2' rise=1 
* * Relative pushout time
* + pushout_per=0.01
* * Absolute pushout time
* *+ pushout = 0.01n

* pessimistic setup time value
.Measure Tran pushout Trig v(CLK)      Val = 'vd/2' cross=1
+                     Targ v(rdata0)   Val = 'vd/2' cross=1

* setup time value
.Measure Tran SetupTime Trig v(data0)  Val = 'vd/2' cross=1
+                       Targ v(CLK)    Val = 'vd/2' cross=1

* Optimization Model
.Model OptMod Opt 
+      Method = passfail 
+      relin = 0.0001 
+      relout = 0.001 



.END

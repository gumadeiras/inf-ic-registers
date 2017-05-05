* finfet testbench

.simulator lang=spice

.lib '../../modelfiles/models' ptm16lstp
.include '../../modelfiles/lstp/16nfet.pm'
.include '../../modelfiles/lstp/16pfet.pm'

.PARAM vd=0.85
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
XBUF0 databuffer0 data0 buf

XNANDIV0 data0 rdata0 CLK nandinv

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

.alter case2: setup time data high low

vdata0 databuffer0 gnd PWL
+ 0ns                      'vd'
+ '2.0ns+DelayTime'        'vd'
+ '2.05ns+DelayTime'       0v
+ '5.0ns+DelayTime'        0v

* .alter case2: hold time: data fixed, clock as variable
* * clock
* vclk CLK gnd PWL
* + 0n                      0v 
* + '3.0n+DelayTime'        0v
* + '3.05n+DelayTime'       'vd'
* + '6.0n+DelayTime'        'vd'
* + '6.05n+DelayTime'       0v

* * initial data value on register out
* .IC v(rdata0) = 0

* * data
* vdata0 databuffer0 gnd PWL
* + 0n            'vd'
* + 5.0n          'vd'
* + 5.05n         0v

* .Measure Tran HoldTime Trig v(CLK)    Val = 'vd/2' cross=1
* +                      Targ v(data0)  Val = 'vd/2' cross=1

.END
 
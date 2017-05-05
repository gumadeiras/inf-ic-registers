* finfet testbench

.simulator lang=spice

.lib '../../modelfiles/models' ptm16lstp
.include '../../modelfiles/lstp/16nfet.pm'
.include '../../modelfiles/lstp/16pfet.pm'

.PARAM  vd=0.85
+       DelayTime=0
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
************** REGISTER - MUX NAND INV DFF
****************************************************
.SUBCKT muxnand data out clk
* SLAVE
XNAND1 data clk  out1 nand2
XINV2  clk  out2      inv
XNAND3 out2 out4 out3 nand2
XNAND4 out1 out3 out4 nand2
* MASTER
XNAND5 out  clk  out5 nand2
*XINV6  clk  out6      inv
XNAND7 out2 out4 out7 nand2
XNAND8 out5 out7 out  nand2
.ENDS

****************************************************
************** INSTANCES
****************************************************
XBUF0 databuffer0 data0 buf

XMUXNAND0 data0 rdata0 CLK muxnand

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
.Tran 10p 10n Sweep Optimize = Opt1
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
* +   v(rdata1) = 0

* * data
* vdata0 databuffer0 gnd PWL
* + 0n            'vd'
* + 5.0n          'vd'
* + 5.05n         0v

* .Measure Tran HoldTime Trig v(CLK)    Val = 'vd/2' cross=1
* +                      Targ v(data0)  Val = 'vd/2' cross=1

.END
 
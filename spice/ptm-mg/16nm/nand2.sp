* NAND2 - case1: A high B pulse

simulator lang=spice

.lib '../modelfiles/models' ptm16lstp
.include '../modelfiles/lstp/16nfet.pm'
.include '../modelfiles/lstp/16pfet.pm'
.include '../library.sp'

.PARAM vd=0.85
.PARAM var=2
.OPTION POST=2
.GLOBAL gnd! vdd!

****************************************************
************** INSTANCES
****************************************************
* INPUTS THROUGH BUFFER
XBUF0 A AA vdd! gnd! buf
XBUF1 B BB vdd! gnd! buf

XNAND2 AA BB F X gnd! nand2

XBUF2 F FF vdd! gnd! buf

* CAPS
C0 FF gnd! 1fF

****************************************************
************** SUPPLY
****************************************************
Vvdd vdd! 0 0.85v
Vgnd gnd! 0 0v


****************************************************
************** STIMULUS - use alter to change
****************************************************
VINA A 0 dc=0.85v
Vdummy vdd! X dc=0v
VIN1 B 0 0 pulse 0 0.85 0 50p 50p 2n 4n

.tran 10p 100n sweep var 2 5 1

.print 3.3*mean(abs(i(Vdummy)))

****************************************************
************** MEASUREMENTS
****************************************************
* .meas tran trise_nand2 trig v(F) val='vd*0.1' rise='var'
* +                      targ v(F) val='vd*0.9' rise='var'

* .meas tran tfall_nand2 trig v(F) val='vd*0.9' fall='var'
* +                      targ v(F) val='vd*0.1' fall='var'

* .meas tran tphl_nand2 trig v(BB) val='vd/2' rise='var'
* +                     targ v(F) val='vd/2' fall='var'

* .meas tran tplh_nand2 trig v(BB) val='vd/2' rise='var'
* +                     targ v(F) val='vd/2' fall='var'

* .meas tran avgpower AVG power from=1n to=100n


* .alter case2: A pulse B high
* VINA A 0 0 pulse 0 0.85 0 50p 50p 2n 4n
* VIN1 B 0 dc=0.85v

* .meas tran trise_nand2 trig v(F) val='vd*0.1' rise='var'
* +                      targ v(F) val='vd*0.9' rise='var'

* .meas tran tfall_nand2 trig v(F) val='vd*0.9' fall='var'
* +                      targ v(F) val='vd*0.1' fall='var'

* .meas tran tphl_nand2 trig v(AA) val='vd/2' rise='var'
* +                     targ v(F) val='vd/2' fall='var'

* .meas tran tplh_nand2 trig v(AA) val='vd/2' rise='var'
* +                     targ v(F) val='vd/2' fall='var'

* .meas tran avgpower AVG power from=1n to=100n


* .alter case3: A pulse B pulse
* VINA A 0 0 pulse 0 0.85 0 50p 50p 2n 4n
* VIN1 B 0 0 pulse 0 0.85 0 50p 50p 6n 12n

* .meas tran trise_nand2 trig v(F) val='vd*0.1' rise='var'
* +                      targ v(F) val='vd*0.9' rise='var'

* .meas tran tfall_nand2 trig v(F) val='vd*0.9' fall='var'
* +                      targ v(F) val='vd*0.1' fall='var'

* .meas tran tphl_nand2 trig v(AA) val='vd/2' rise='var'
* +                     targ v(F) val='vd/2' fall='var'

* .meas tran tplh_nand2 trig v(AA) val='vd/2' rise='var'
* +                     targ v(F) val='vd/2' fall='var'

.meas tran avgpower AVG power from=1n to=100n

.END
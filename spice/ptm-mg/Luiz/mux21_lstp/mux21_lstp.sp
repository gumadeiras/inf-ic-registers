mux 2 pra 1 com transmission gate

.lib '../PTM-MG/modelfiles/models' ptm16lstp
.include '../PTM-MG/modelfiles/lstp/16nfet.pm'
.include '../PTM-MG/modelfiles/lstp/16pfet.pm' 

.simulator lang=spice
.param
.param tensao11 = 0.0 tensao12 = 0.85
.param tensao21 = 0.0 tensao22 = 0.85
.param Tsel1 = 0.0 Tsel2 = 0.0 $seletor entrada 2
.param ciclo = 2
.option post=2
.global gnd! vdd!

********************define subckts****************
.subckt inv vi vo
MM1 vo vi gnd! gnd! nfet nfin = 1
MM0 vo vi vdd! vdd! pfet nfin = 1
.ends

.subckt mux21 In1 In2 Sel Out

MM0 SelInv Sel vdd! vdd! pfet nfin = 1
MM1 SelInv Sel gnd! gnd! nfet nfin = 1

MM2 In1 Sel Out vdd! pfet nfin = 1
MM3 In1 SelInv Out gnd! nfet nfin = 1

MM4 In2 SelInv Out vdd! pfet nfin = 1
MM5 In2 Sel Out gnd! nfet nfin = 1

.ends
*a ordem das conexoes dos mosfets eh drain, gate, source, body
*******************************define  circuit****************************************

xInv1 inv1 1 inv
xInv2 inv2 2 inv
xInvSel invSel sel inv

xMux21 1 2 sel out mux21

xInvOut out invout inv

c0 invout gnd! 2f

*****************************define stimuli************************

Va inv1 0 0 pulse 'tensao11' 'tensao12' 0n 50p 50p 3n 6n
Vb inv2 0 0 pulse 'tensao21' 'tensao22' 0 50p 50p 2n 4n $frequencia 500MHz
Vsel invSel 0 DC=0 pulse 'Tsel1' 'Tsel2' 0n 50p 50p 5n 10n 

vvdd vdd! 0 0.85V
vgnd gnd! 0 0V

*********************Analysis********************************
.tran STEP=5p STOP=80n $sweep ciclo 2 10 1

.meas tran TPhl trig v(1) val=0.425 rise='ciclo'
		+targ v(out) val=0.425 rise='ciclo'

.meas tran TPlh trig v(1) val=0.425 fall='ciclo'
		+targ v(out) val=0.425 fall='ciclo'

.meas tran Trise1 trig v(out) val=0.085 rise='ciclo'
		+targ v(out) val=0.765 rise='ciclo'

.meas tran Tfall1 trig v(out) val=0.765 fall='ciclo'
		+targ v(out) val=0.085 fall='ciclo'

************************************alters******************************
.alter case 2: seletor fixo na entrada 1
.param Tsel1 = 0.85 Tsel2 = 0.85

.alter case 3: seletor variando
.param Tsel1 = 0.0
.end

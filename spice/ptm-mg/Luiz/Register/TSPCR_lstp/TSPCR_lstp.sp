True Single Phase Clock Register 

.lib '../PTM-MG/modelfiles/models' ptm16lstp
.lib '../library_16nmlstp' standardCells

.simulator lang=spice
.param
.param tensaoB1 = 0.0 tensaoB2 = 0.85
.param ciclo = 2
.option post=2
.global gnd! vdd!
*********DEFINE CIRCUIT************

xInv0 Dinv D vdd! gnd! inv

xReg D CLK Q vdd gnd! TSPCR

xInv1 Q Qinv vdd! gnd! inv

c0 Qinv gnd! 2f


************DEFINE SOURCES***********
vvdd vdd! 0 0.85V
vgnd gnd! 0 0V
Vaux vdd vdd! 0V

Vclock CLK gnd! DC = 0 pulse 0 0.85 0 25p 25p 1n 2n
Vd D gnd! DC = 0 pulse 0 0.85 0 50p 50p 2n 4n

*************ANALYSIS******************
.tran STEP=2p STOP=50n

.alter case 2: clock com dobro de frequencia
Vclock CLK gnd! DC = 0 pulse 0 0.85 0 25p 25p 0.5n 1n

.end


Full Adder (nada de carry skip)

.lib '../PTM-MG/modelfiles/models' ptm16lstp
.lib '../library_16nmlstp' standardCells

.simulator lang = spice
.param
.param ciclo = 2
.option post=2
.global gnd! vdd!

*************MAIN CIRCUIT**************

xInvA ainv A vdd! gnd! inv
xInvB binv B vdd! gnd! inv
xInvCin cinv Cin vdd! gnd! inv

xFA0 A B Cin S Cout vdd gnd! FullAdder

xInvS S Sinv vdd! gnd! inv
XCout Cout Coutinv vdd! gnd! inv

c0 Sinv gnd! 2fF
c1 Coutinv gnd! 2fF

****************************************

**********SOURCES*****************
vvdd vdd! 0 0.85V
vgnd gnd! 0 0V

Vaux vdd vdd! DC=0V $consumo do FA

Va ainv 0 DC=0 pulse 0 0.85 0 50p 50p 1n 2n

Vb binv 0 DC=0 pulse 0 0.85 0 50p 50p 1.5n 3n

Vcin cinv 0 DC=0 pulse 0 0.85 0 50p 50p 2n 4n
****************************************
***********ANALYSIS***************

.tran STEP=5p STOP=50n

.measure tran Iint INTEG i(Vaux) FROM=0n TO=50n
.measure tran Iavg AVG abs(i(Vaux)) FROM=0n TO=50n

.measure tran Pint PARAM='Iint*0.85/50n'
.measure tran Pavg PARAM='Iavg*0.85'

.end 

XOR com transmission gate
*utiliza seis tramsistores e a saida carrega ate Vdd

.lib '../PTM-MG/modelfiles/models' ptm16lstp
.lib '../library_16nmlstp' standardCells

.simulator lang=spice
.param
.param ciclo = 2
.option post=2
.global gnd! vdd!


***************************** define circuit *******************
xInvA invA A vdd! gnd! inv
xInvB invB B vdd! gnd! inv

xXor A B out vdd gnd! xor  $entrada A fixa em VDD e B pulsando

xInvO out outinv vdd! gnd! inv

c1 outinv gnd! 2f

******************************define stimuli********************
Va invA 0 DC=0.85  $entrada A em GND
Vb invB 0 0 pulse 0 0.85 0 50p 50p 1n 2n $frequencia 500MHz


vvdd vdd! 0 0.85V
vgnd gnd! 0 0V
Vaux vdd vdd! 0V

*************************Analysis*********************************

.tran STEP=5p STOP=50n sweep ciclo 2 20 1

.meas tran TPhl_B trig v(B) val=0.425 rise='ciclo'
		+targ v(out) val=0.425 fall='ciclo'

.meas tran TPlh_B trig v(b) val=0.425 fall='ciclo'
		+targ v(out) val=0.425 rise='ciclo'

.meas tran Trise trig v(out) val=0.085 rise='ciclo'
		+targ v(out) val=0.765 rise='ciclo'

.meas tran Tfall trig v(out) val=0.765 fall='ciclo'
		+targ v(out) val=0.085 fall='ciclo'

.meas tran TPhl_A trig v(A) val=0.425 rise='ciclo'
		+targ v(out) val=0.425 fall='ciclo'

.meas tran TPlh_A trig v(a) val=0.425 rise='ciclo'
		+targ v(out) val=0.425 fall='ciclo'

.measure tran Itotal INTEG i(Vaux) FROM=0n TO=50n

***************************alter***************************
.alter case 2: entrada A em VDD
Va invA 0 DC=0.0V
Vb invB 0 DC=0.0 pulse 0 0.85 0 50p 50p 1n 2n

.alter case 3: entrada B em GND
Va invA 0 DC=0.0 pulse 0 0.85 0 50p 50p 1n 2n
Vb invB 0 DC=0.85

.alter case 4: entrada B em VDD
Va invA 0 DC=0.0 pulse 0 0.85 0 50p 50p 1n 2n
Vb invB 0 DC=0.0

.alter case 5: ambas entradas oscilando
Va invA 0 DC=0.0 pulse 0 0.85 0 50p 50p 1n 2n
Vb invB 0 DC=0.0 pulse 0 0.85 0 50p 50p 1.5n 3n
.end

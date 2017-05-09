teste de nand com finfet 16nm
.lib '../PTM-MG/modelfiles/models' ptm16lstp
.lib '../library_16nmlstp' standardCells

.simulator lang = spice
.param
.param ciclo = 2
.option post=2
.global gnd! vdd!


*criar instancia do subcircuito
*****************define main circuit****************************
xInvA ainv a vdd! gnd! inv
xInvB binv b vdd! gnd! inv

xNand a b out vdd gnd! nand

xInvO out outinv vdd! gnd! inv

c0 outinv gnd! 2f $load capacitance, como saber o valor da carga?

***********************define stimuli*************************
*agora ligar os nodes globais vdd! e gnd!
vvdd vdd! 0 0.85V
vgnd gnd! 0 0V
Vaux vdd vdd! 0V

*agora criar os sinais em A e B
va ainv 0 DC=0.0 $ pulse 'a1' 'a2' 0 50p 50p 1n 2n $primeiro mantem entrada A fixa
vb binv 0 0 pulse 0 0.85 0 50p 50p 1.5n 3n $alterando entrada B em pulsos de 0 a 0.85
*com rise e fall de 50p e periodo de 4n

*****************************Analysis options***********************************
.tran STEP=5p STOP=50n $ sweep ciclo 2 20 1


.measure tran Itotal INTEG i(Vaux) FROM=0n TO=50n
.measure Etotal Param='Itotal*0.85'

*.meas tran tplh_b trig v(b) val=0.425 fall='ciclo'$trigger na segunda descida de B
$		     +targ v(out) val=0.425 rise='ciclo' $targ na segunda subida da saida

*.meas tran tphl_b trig v(b) val=0.425 rise='ciclo' $trigger na segunda subida de B
$		       +targ v(out) val=0.425 fall='ciclo' $targ na segunda descida saida



*.meas tran Trise trig v(out) val=0.085 rise ='ciclo'$trig no inicio da subida
$		+targ v(out) val=0.765 rise ='ciclo'$targ no final da subida

*.meas tran Tfall trig v(out) val=0.765 fall ='ciclo' $trig inicio descida
$		+targ v(out) val=0.085 fall ='ciclo'$targ final descida

*.meas tran tplh_a trig v(a) val = 0.425 fall='ciclo'
$	+targ v(out) val = 0.425 rise='ciclo'

*.meas tran tphl_a trig v(a) val=0.425 rise='ciclo'
$		+targ v(out) val=0.425 fall='ciclo'



**************************ALTER*****************************
.alter case 2: entrada a oscilando
va ainv 0 DC=0.0 pulse 0 0.85 0 50p 50p 1.5n 3n
vb binv 0 DC=0.0

.alter case 3: ambas entradas oscilando
va ainv 0 DC=0.0 pulse 0 0.85 0 50p 50p 1.5n 3n
vb binv 0 DC=0.0 pulse 0 0.85 0 50p 50p 2n 4n
.end

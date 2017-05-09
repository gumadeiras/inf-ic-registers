Somador 4 bits sem aceleracao

.lib '../PTM-MG/modelfiles/models' ptm16lstp
.lib '../library_16nmlstp' standardCells

.simulator lang = spice
.param
.param ciclo = 2
.option post=2
.global vdd! gnd!

*******MAIN CIRCUIT***************
*inversores
xA0inv A0inv A0_in vdd! gnd! inv
xA1inv A1inv A1_in vdd! gnd! inv
xA2inv A2inv A2_in vdd! gnd! inv
xA3inv A3inv A3_in vdd! gnd! inv

xB0inv B0inv B0_in vdd! gnd! inv
xB1inv B1inv B1_in vdd! gnd! inv
xB2inv B2inv B2_in vdd! gnd! inv
xB3inv B3inv B3_in vdd! gnd! inv

xCininv Cininv Cin_in vdd! gnd! inv

xCLKinv CLKinv clk vdd! gnd! inv
*registradores de entrada

xA0 A0_in clk A0_out vdd gnd! TSPCR
xA1 A1_in clk A1_out vdd gnd! TSPCR
xA2 A2_in clk A2_out vdd gnd! TSPCR
xA3 A3_in clk A3_out vdd gnd! TSPCR

xB0 B0_in clk B0_out vdd gnd! TSPCR
xB1 B1_in clk B1_out vdd gnd! TSPCR
xB2 B2_in clk B2_out vdd gnd! TSPCR
xB3 B3_in clk B3_out vdd gnd! TSPCR

xCin Cin_in clk Cin_out vdd gnd! TSPCR

xFA0 A0_out B0_out Cin_out S0_in Cout0 vdd gnd! FullAdder
xFA1 A1_out B1_out Cout0 S1_in Cout1 vdd gnd! FullAdder
xFA2 A2_out B2_out Cout1 S2_in Cout2 vdd gnd! FullAdder
xFA3 A3_out B3_out Cout2 S3_in Cout_in vdd gnd! FullAdder

xS0 S0_in clk S0_out vdd gnd! TSPCR
xS1 S1_in clk S1_out vdd gnd! TSPCR
xS2 S2_in clk S2_out vdd gnd! TSPCR
xS3 S3_in clk S3_out vdd gnd! TSPCR

xCout Cout_in clk Cout_out vdd gnd! TSPCR

c0 S0_out 0 2fF
c1 S1_out 0 2fF
c2 S2_out 0 2fF
c3 S3_out 0 2fF
c4 Cout_out 0 2fF

*******************************************

*********SOURCES*****************
Vdd vdd 0 DC=0.85V

Vvdd vdd! 0 DC=0.85V
Vgnd gnd! 0 0V


Vclk CLKinv 0 DC=0 pulse 0 0.85 0 20p 20p 1n 2n

VA0 A0inv 0 DC=0 pulse 0 0.85 0 50p 50p 1.1n 2.2n
VB0 B0inv 0 DC=0 pulse 0 0.85 0 50p 50p 1.2n 2.4n

VA1 A1inv 0 DC=0 pulse 0 0.85 0 50p 50p 1.3n 2.6n
VB1 B1inv 0 DC=0 pulse 0 0.85 0 50p 50p 1.4n 2.8n

VA2 A2inv 0 DC=0 pulse 0 0.85 0 50p 50p 1.5n 3.0n
VB2 B2inv 0 DC=0 pulse 0 0.85 0 50p 50p 1.6n 3.2n

VA3 A3inv 0 DC=0 pulse 0 0.85 0 50p 50p 1.7n 3.4n
VB3 B3inv 0 DC=0 pulse 0 0.85 0 50p 50p 1.8n 3.6n

VCin Cininv 0 DC=0 pulse 0 0.85 0 50p 50p 1.9n 3.8n
************************************************

*********ANALYSIS********************

.tran STEP=2p STOP=80n

.measure tran Iint INTEG i(Vdd) FROM=0n TO=80n
.measure tran Iavg AVG abs(i(Vdd)) FROM=0n TO=80n

.measure tran Pint PARAM='Iint*0.85/80n'
.measure tran Pavg PARAM='Iavg*0.85'

.end

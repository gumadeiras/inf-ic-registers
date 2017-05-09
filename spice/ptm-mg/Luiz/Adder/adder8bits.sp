Somador 8 bits sem aceleracao

.lib '../PTM-MG/modelfiles/models' ptm16lstp
.lib '../library_16nmlstp' standardCells

.simulator lang = spice
.param
.param ciclo = 2
.option post=2
.global gnd! vdd!

*******MAIN CIRCUIT***************

*registradores de entrada

xA0 A0 clk A0_in vdd! gnd! TSPCR
xA1 A1 clk A1_in vdd! gnd! TSPCR

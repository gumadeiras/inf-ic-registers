 
* This is sub 45nm FinFET prdictive model 
.options post=2 brief


** subckt for NMOS **

.subckt DGNMOS NVd NVgf NVgb NVs

.include './soinmos1.pm'  * front soi model card
.include './soinmos2.pm'  * back soi model card

.param pnch = 2e16
.param len = 45e-9
.param ptox = 1.5e-9
.param ptsi = 8.4e-9
.param ptbox = 1.5e-9
.param npvthf0 = 0.31
.param npvthb0 = 0.31
.param esi = 11.7
.param eox = 3.9
.param nlambda1 ='(-1)*(ptox/(ptbox+ptsi/(esi/eox)))'
.param nlambda2 ='(-1)*(ptbox/(ptox+ptsi/(esi/eox)))'

.param delta1 = 0.008
.param delta2 = 0.008

.param Voff2=-0.09
.param N = 0.2
.param Vt = 0.0259
.param Voff1 = 0.0

mn1  NVd  NVgf1 NVs  0  nmos1 w=60e-9 l='len'
mn2  NVd  NVgb1 NVs  0  nmos2 w=60e-9 l='len'

En1 NVgf NVgf1 VOL = 'nlambda1*(-1*N*Vt*log(1+exp((((nlambda2*(npvthb0-(v(NVd)-v(NVs))*delta2)+(npvthf0-(v(NVd)-v(NVs))*delta1))/(1-(nlambda1*nlambda2))+Voff2)-(v(NVgb)-v(NVs))-Voff1)/N/Vt))+N*Vt*log(1+exp((((nlambda2*(npvthb0-(v(NVd)-v(NVs))*delta2)+(npvthf0-(v(NVd)-v(NVs))*delta1))/(1-(nlambda1*nlambda2))+Voff2)-Voff1)/N/Vt))-1*N*Vt*log(1+exp(((-1)*((nlambda2*(npvthb0-(v(NVd)-v(NVs))*delta2)+(npvthf0-(v(NVd)-v(NVs))*delta1))/(1-(nlambda1*nlambda2))+Voff2)-Voff1)/N/Vt))+N*Vt*log(1+exp((-Voff1)/N/Vt)))'
En2 NVgb NVgb1 VOL = 'nlambda2*(-1*N*Vt*log(1+exp((((nlambda1*(npvthf0-(v(NVd)-v(NVs))*delta1)+(npvthb0-(v(NVd)-v(NVs))*delta2))/(1-(nlambda1*nlambda2))+Voff2)-(v(NVgf)-v(NVs))-Voff1)/N/Vt))+N*Vt*log(1+exp((((nlambda1*(npvthf0-(v(NVd)-v(NVs))*delta1)+(npvthb0-(v(NVd)-v(NVs))*delta2))/(1-(nlambda1*nlambda2))+Voff2)-Voff1)/N/Vt))-1*N*Vt*log(1+exp(((-1)*((nlambda1*(npvthf0-(v(NVd)-v(NVs))*delta1)+(npvthb0-(v(NVd)-v(NVs))*delta2))/(1-(nlambda1*nlambda2))+Voff2)-Voff1)/N/Vt))+N*Vt*log(1+exp((-Voff1)/N/Vt)))'
.ends

** sub ckt for PMOS **

.subckt DGPMOS PVd PVgf PVgb PVs

.include './soipmos1.pm' * front soi model card
.include './soipmos2.pm' * back soi model card

.param pnch =2e16
.param len = 45e-9
.param ptox = 1.5e-9
.param ptsi = 8.4e-9
.param ptbox = 1.5e-9
.param ppvthf0 = -0.25
.param ppvthb0 = -0.25
.param esi = 11.7
.param eox = 3.9
.param plambda1 ='(-1)*(ptox/(ptbox+ptsi/(esi/eox)))'
.param plambda2 ='(-1)*(ptbox/(ptox+ptsi/(esi/eox)))'

.param pdelta1 = 0.008
.param pdelta2 = 0.008

.param Voff2 = 0.12
.param N = 0.2
.param Vt = 0.0259
.param Voff1 = 0.0

mp1  PVd  PVgf1 PVs  n1  pmos1 w=60e-9 l='len'
mp2  PVd  PVgb1 PVs  n1  pmos2 w=60e-9 l='len'

vvdd n1 0 1

Ep1 PVgf PVgf1 VOL = 'plambda1*(-1*(-1*N*Vt*log(1+exp((-1*((plambda2*(ppvthb0-(v(PVd)-v(PVs))*pdelta2)+(ppvthf0-(v(PVd)-v(PVs))*pdelta1))/(1-(plambda1*plambda2))+Voff2)+(v(PVgb)-v(PVs))+Voff1)/N/Vt))+N*Vt*log(1+exp((-1*((plambda2*(ppvthb0-(v(PVd)-v(PVs))*pdelta2)+(ppvthf0-(v(PVd)-v(PVs))*pdelta1))/(1-(plambda1*plambda2))+Voff2)+Voff1)/N/Vt))-1*N*Vt*log(1+exp((((plambda2*(ppvthb0-(v(PVd)-v(PVs))*pdelta2)+(ppvthf0-(v(PVd)-v(PVs))*pdelta1))/(1-(plambda1*plambda2))+Voff2)+Voff1)/N/Vt))+N*Vt*log(1+exp((Voff1)/N/Vt))))' 
Ep2 PVgb PVgb1 VOL = 'plambda2*(-1*(-1*N*Vt*log(1+exp((-1*((plambda1*(ppvthf0-(v(PVd)-v(PVs))*pdelta1)+(ppvthb0-(v(PVd)-v(PVs))*pdelta2))/(1-(plambda1*plambda2))+Voff2)+(v(PVgf)-v(PVs))+Voff1)/N/Vt))+N*Vt*log(1+exp((-1*((plambda1*(ppvthf0-(v(PVd)-v(PVs))*pdelta1)+(ppvthb0-(v(PVd)-v(PVs))*pdelta2))/(1-(plambda1*plambda2))+Voff2)+Voff1)/N/Vt))-1*N*Vt*log(1+exp((((plambda1*(ppvthf0-(v(PVd)-v(PVs))*pdelta1)+(ppvthb0-(v(PVd)-v(PVs))*pdelta2))/(1-(plambda1*plambda2))+Voff2)+Voff1)/N/Vt))+N*Vt*log(1+exp((Voff1)/N/Vt))))'
.ends


.subckt inverter vin vout vvdd ggnd

xpmos0 (vout vin vvdd vvdd) DGPMOS
xnmos0 (vout vin ggnd ggnd) DGNMOS

.ends inverter

.subckt mux21 out in0 in1 sel vdd gnd

XINV1 (sel nsel vvdd ggnd) inverter

XS11 (out sel in0 vvdd) DGPMOS
XS12 (out nsel in0 ggnd) DGNMOS
XS21 (out nsel in1 vvdd) DGPMOS
XS22 (out sel in1 ggnd) DGNMOS

.ends mux21


.subckt ffd data out clk vvdd ggnd
.ends


* inv
X1 nd vg1 vg1 0 DGNMOS
X2 nd vg1 vg1 nvdd DGPMOS

vfg vg1 0 0.1
vvdd nvdd 0 1

vdd (vdd 0) dc=1V
vdrive (vin 0) DC=0 pulse=(0 1 0 50p 50p 2.5n 5n)

XINVT vout vdrive vdd 0 inverter

.op
.dc vfg 0 1 0.1
.tran 0.1n 5n 
.print v(nd)
.print v(vout)
.end

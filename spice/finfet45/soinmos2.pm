* bsimsoi3.2 model card
.model  nmos2 nmos  level = 57 
+mobmod  = 0    capmod  = 2    shmod   = 1 
+soimod  = 2    igcmod  = 0    igbmod  = 0
+dtoxcv  = 0    llc     = 0    lwc     = 0    lwlc    = 0
+wlc = 0        wwc     = 0    wwlc    = 0    tsi     = 'ptsi/2'
+tox = ptbox     toxref  = 1.5e-9 tbox    = 5e-7 tnom  = 27
+rbody = 1	rbsh = 0	rsh = 0       rhalo = 1e+015
+wint = 0	lint = 1.35e-8	wth0 = 0	ll = 0
+wl = 0		lln  = 1	wln = 1		lw = 0
+ww = 0		lwn  = 1	wwn = 1		lwl = 0 
+wwl = 0	ln = 2e-006	xpart = 1	xj = 1e-008
+k1b = 0	k2b = 0		dk2b = 0	vbsa = 0.10         
+aigc = 1  bigc = 1  cigc = 1  aigsd = 1 
+bigsd = 1    cigsd = 1  nigc = 1   poxedge = 1  pigcd = 1 


+vth0 = npvthf0	k1 = 0.00001	k1w1 = 0 
+k1w2 = 0	k2 = 0.001		k3 = 0	k3b = 0             
+kb1 = 1	w0 = 2.5e-6          nlx = 0                          
+nch = pnch 	nsub = 1e+015   ngate = 2e+020     

+dvt0  = 0.002     dvt1   = 0.55   	dvt2 = -0.032             
+dvt0w = 0	dvt1w  = 0        dvt2w = 0	eta0    = 0.02
+etab  = 0      dsub    = 1          voff    = -0.15          nfactor = 2           


+cdsc   = 0.0005           cdscb   = 0               cdscd   = 0.001           cit     = 0.00             
+u0 = 680	               ua = 1e-010		     ub = 2e-018               uc      = 0             

+prwg = 0                  prwb = 0                  wr      = 1               rdsw    = 330        
+a0 = 1		         ags = 0                   a1      = 0               a2      = 0.99       
+b0      = 0               b1      = 0               vsat    = 200000          keta    = 0             
+ketas   = 0               dwg     = 0               dwb     = 0               dwbc    = 0             

+pclm    = 0.12            pdiblc1 = 0.06            pdiblc2 = 0.06            pdiblcb = -0.005             
+drout   = 0.6             pvag    = 0               delta   = 0.001           alpha0  = 8e-009        

+beta0   = 0               beta1   = 0               beta2   = 0.05            fbjtii  = 0             
+vdsatii0= 0.8             tii     = -0.2            lii     = 5e-008          esatii  = 1e+008        
+sii0    = 0.5             sii1    = 0               sii2    = 0               siid    = 0             
+agidl   = 2e-009          bgidl   = 2e+009          ngidl   = 0.5             ebg     = 1.2           
+vgb1    = 300             vgb2    = 17           
+voxh    = 5               deltavox= 0.005         
+ntox    = 1               ntun    = 3.6             ndiode  = 1               nrecf0  = 1.8           
+nrecr0  = 1               isbjt   = 3e-007          isdif   = 3e-008          isrec   = 0.0005        
+istun   = 1e-008          vrec0   = 0.05            vtun0   = 5               nbjt    = 1             
+lbjt0   = 2e-007          vabjt   = 10              aely    = 0               ahli    = 1e-015        
+vevb    = 0.075           vecb    = 0.026         
+cjswg  = 5e-010       	   mjswg = 0.5	           pbswg = 0.8	             tt = 5e-010        
+ldif0   = 0.001           cgeo    = 0               cgso    = 6.238e-010      cgdo    = 6.238e-010      
+dlc     = 0               dwc     = 0               dlcb    = 0               dlbg    = 0             
+fbody   = 1               clc     = 1e-007          cle     = 0.6             cf      = 0             
+csdmin  = 2.5e-005        asd     = 0.5             csdesw  = 0               vsdfb   = -0.8          
+vsdth   = -0.3            delvt   = 0               acde    = 0               moin    = 15            
+ckappa  = 0.6             cgdl    = 0               cgsl    = 0               ndif    = -1            
+rth0    = 0               cth0    = 1e-005    
+tpbswg = 0  
+tcjswg = 0

+kt1 = -0.2	               kt1l = 0                  kt2 = -0.042     ute = -1.5        
+ua1 = 1e-009              ub1 = -3.5e-019           uc1 = 0          prt = 0         
+at = 53000	               ntrecf  = 0	           ntrecr = 0       xbjt    = 1    
+xdif    = 1               xrec    = 1               xtun    = 0
*+fnoimod = 1 tnoimod = 1   tnoia = 1  tnoib = 2.5   rnoia = 0.577 rnoib = 0.37
*+ntnoi = 1.0	em = 41000000  af = 1	ef = 1      kf = 0
*+noif = 1.0	
+rgateMod = 2 rshg = 0.1 xrcrg1 = 12 xrcrG2 = 1


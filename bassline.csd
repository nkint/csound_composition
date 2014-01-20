<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>

sr         =         44100
kr         =         4410
ksmps     =         10
nchnls     =         2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; additive bass
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; 4 oscil with two different f GEN sounds (06 and 03).
; additive synthesis with line envelope
; very effective as melodic bass line.

instr 10
    i_note    =    cpspch(p5)                        
                                                ; cpspch (pitch) 
                                                ; Converts a pitch-class value to cycles-per-second.
                                                ; The conversion from pch into cps is not a linear operation but involves an exponential process.
                                                ; 5 --> Fa (349 hertz)
                                                ; 6 --> Fa diesis (369.994 hertz)

    a1    oscil    p4*0.30, i_note*0.998-.12, 06
    a2    oscil    p4*0.30, i_note*1.002-.12, 03
    a3    oscil    p4*0.30, i_note*1.002-.12, 06
    a4    oscil    p4,      i_note      +.24, 03
                                                ; oscil xamp, xcps, ifn
                                                ; Reads table ifn sequentially and repeatedly at a frequency xcps. The amplitude is scaled by xamp.

    amix    = a1+a2+a3+a4
                                                ; additive synthesis

    aenv linen 1, 0, p3, p3/10
                                                ; lineen xamp, irise, idur, idec
                                                ; Applies a straight line rise and decay pattern to an input amp signal.

    outs aenv*amix, aenv*amix
endin

</CsInstruments>
<CsScore>

f03 0 1024 10 1    
f06 0 2048 10 1 1 1 1 .7 .5 .3 .1

;;;;;;;;;;;;;;;;;;;
; bassline
;;;;;;;;;;;;;;;;;;;

;  instr  start     dur   ampl   freq
;         time           

i    10    12.8      .4   5500    5
i    10     +        .    .       .
i    10     +        .2   .       .
i    10     +        .2   .       .
i    10     +        .2   .       .
    
i    10     +        .4   .       5
i    10     +        .    .       .
i    10     +        .    .       .
i    10     +        .2   .       6
i    10     +        .2   .       .
     
i    10     +        .4   .       5
i    10     +        .    .       .
i    10     +        .2   .       .
i    10     +        .2   .       .
i    10     +        .2   .       .
    
i    10     +        .4   .       5
i    10     +        .    .       .
i    10     +        .    .       .
i    10     +        .    .       .

; 4 = 6 sec

i    10     +        .4   9900     5
i    10     +        .    .       .
i    10     +        .2   .       .
i    10     +        .    .       .
i    10     +        .    .       .
    
i    10     +        .4   .       5
i    10     +        .    .       .
i    10     +        .    .       .
i    10     +        .2   .       6
i    10     +        .    .       .
     
i    10     +        .4   .       5
i    10     +        .    .       .
i    10     +        .2   .       .
i    10     +        .    .       .
i    10     +        .    .       .
    
i    10     +        .4   .       5
i    10     +        .    .       .
i    10     +        .    .       .
i    10     +        .    .       .

; 8

i    10     +        .4    9900     5
i    10     +        .     .       .
i    10     +        .2    .       .
i    10     +        .     .       .
i    10     +        .     .       .
    
i    10     +        .4    .       5
i    10     +        .     .       .
i    10     +        .     .       .
i    10     +        .     .       6
i    10     +        .     .       .
     
i    10     +        .4    .       5
i    10     +        .     .       .
i    10     +        .2    .       .
i    10     +        .     .       .
i    10     +        .     .       .
    
i    10     +        .4    .       5
i    10     +        .     .       .
i    10     +        .     .       .
i    10     +        .     .       .

; 12

i    10     +        .4    9900     5
i    10     +        .     .       .
i    10     +        .2    .       .
i    10     +        .     .       .
i    10     +        .     .       .
    
i    10     +        .4    .       5
i    10     +        .     .       .
i    10     +        .     .       .
i    10     +        .2    .       6
i    10     +        .     .       .
     
i    10     +        .4    .       5
i    10     +        .     .       .
i    10     +        .2    .       .
i    10     +        .     .       .
i    10     +        .     .       .
    
i    10     +        .4    .       5
i    10     +        .     .       .
i    10     +        .     .       .
i    10     +        .     .       .
    
;    16
    
i    10     +        .4    9900     5
i    10     +        .     .       .
i    10     +        .2    .       .
i    10     +        .     .       .
i    10     +        .     .       .
    
i    10     +        .4    .       5
i    10     +        .     .       .
i    10     +        .     .       .
i    10     +        .2    .       6
i    10     +        .     .       .
     
i    10     +        .4    .       5
i    10     +        .     .       .
i    10     +        .2    .       .
i    10     +        .     .       .
i    10     +        .     .       .     
    
i    10     +        .4    .       5
i    10     +        .     .       .
i    10     +        .     .       .
i    10     +        .     .       .
    
;    20
    
i    10     +        .4    9900     5
i    10     +        .     .       .
i    10     +        .2    .       .
i    10     +        .     .       .
i    10     +        .     .       .
    
i    10     +        .4    .       5
i    10     +        .     .       .
i    10     +        .     .       .
i    10     +        .2    .       6
i    10     +        .     .       .
     
i    10     +        .4    .       5
i    10     +        .     .       .
i    10     +        .2    .       .
i    10     +        .     .       .
i    10     +        .     .       .
    
i    10     +        .4    .       5
i    10     +        .     .       .
i    10     +        .     .       .
i    10     +        .     .       .

; 24 

i    10     +        .4    9900     5
i    10     +        .     .       .
i    10     +        .2    .       .
i    10     +        .     .       .
i    10     +        .     .       .
    
i    10     +        .4    .       5
i    10     +        .     .       .
i    10     +        .     .       .
i    10     +        .2    .       6
i    10     +        .     .       .
     
i    10     +        .4    .       5
i    10     +        .     .       .
i    10     +        .2    .       .
i    10     +        .     .       .
i    10     +        .     .       .
    
i    10     +        .4    .       5
i    10     +        .     .       .
i    10     +        .     .       .
i    10     +        .     .       .

; 28

i    10      +       .4     .      6
i    10      +       .      .      5
i    10      +       .2     .      .
i    10      +       .      .      .       
i    10      +       .      .      .   
    
i    10      +       .4     .      5
i    10      +       .      .      .   
i    10      +       .      .      .   
i    10      +       .2     .      6
i    10      +       .      .      .   

</CsScore>
</CsoundSynthesizer>
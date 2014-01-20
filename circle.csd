<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>

sr         =         44100
kr         =         4410
ksmps      =         10
nchnls     =         2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; oscili foscili circle 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; fm synthesis
; envelope is done with an oscil with a period equals to the duration of the note
; and an increasing f-table (not sinusoidal) giving a strage attack to the note
; then panning in a circle (gived by trigonometry function) between the 2 stereo outs

instr 5
    k_cps    =    p4
    k_car    =    p5
    k_mod    =    p6
    k_ndx    =    p8
    k_amp    =    p9

    afm      foscili   k_amp, k_cps, k_car, k_mod, k_ndx, 11
                                                    ; foscili 
                                                    ; Basic frequency modulated oscillator with linear interpolation.

    afm1     oscil     afm, 1/p3, 18                
                                                    ; here an envelope trick! the frequency of the sound is the reciprocal of the note duration: this oscil has the period equals to the note duration. this makes this instrument to have an envelope equal to the sound table (f18 for instance here). see the csound output to see f18!

    afm2     =    afm1*400

    k_pan    =    p7
    k_rtl    =    cos(k_pan)*2
    k_rtr    =    sin(k_pan)*2

    al       =    afm2*k_rtl
    ar       =    afm2*k_rtr

    outs al, ar
endin

</CsInstruments>
<CsScore>

f11 0 2048 10 1                                    
f18 0 512  5  1 512 256     

;;;;;;;;;;;;;;;;;;;
; oscili foscili circle 
;;;;;;;;;;;;;;;;;;;

;  instr  start     dur   fm      fm carrier   fm modulat   pan     modul    fm
;         time            ratio     freq         freq      factor   index    amp

i    5    47.8      .8    4500     3.24         1.10         0       7.9      4   
i    5    48.85     .     5040     2.24         2.25         >       8.6      5   
i    5    50        1     6340     3.23         1.35         >       8.2      4   
i    5    51.65     .     2600     3.63         1.26         >       3.3      3.5   
i    5    52.35     .     2750     2.24         1.33         >       2.2      3.25  
i    5    53        .     5000     4            2.14         >       7.5      3   
i    5    54        1.5   6000     5.25         3.6          3       8.9      3   


</CsScore>
</CsoundSynthesizer>
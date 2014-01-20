<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>

sr         =         44100
kr         =         4410
ksmps     =         10
nchnls     =         2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; bordone.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; let's start with a central note. 
; deviate from it with some random and 
; use it to modulate the frequency of an oscil.
; then, subtractive synthesis, filter it!

instr 21
    i_central_note = octpch(p4) 
                                                ; octpch
                                                ; Converts a pitch-class value to octave-point-decimal.

    k_deviation    randh 10, 10, .5            
                                                ; random value from -10 to 10 wach 10Hz with 0.5 seed

    a1             oscil p5, cpsoct(i_central_note+k_deviation), 10
                                                ; cpsoct
                                                ; Converts an octave-point-decimal value to cycles-per-second.

    a2             reson a1,1000,50
                                                ; reson asig kcf kbw
                                                ; A second-order resonant filter.
                                                ; asig -- the input signal at audio rate.
                                                ; kcf -- the center frequency of the filter, or frequency position of the peak response.
                                                ; kbw -- bandwidth of the filter (the Hz difference between the upper and lower half-power points). 

    a3             butterlp a2*.4+a1,2500
                                                ; butterlp asig, kreq
                                                ; Implementation of a second-order low-pass Butterworth filter. 
                                                ; asig -- Input signal to be filtered.
                                                ; kfreq -- Cutoff or center frequency for each of the filters.

    a4             butterlp a3,2500
    a5             butterhp a4,950
    a6             butterhp a5,950

    aenv           linen a6, p3*.2, p3, p3*2

    a7             oscil 1, .4, 03              ; oscil to pan

    outs aenv*a7, aenv*(0.4-a7)                    
    
endin

</CsInstruments>
<CsScore>

f03 0 1024 10  1                    
f10 0 1024 21  1                    

;;;;;;;;;;;;;;;;;;;
; bordone
;;;;;;;;;;;;;;;;;;;

;  instr  start     dur     central   oscil
;         time               note     ampl

i   21     0        25.6     8.00     200
i   21     44.8     18.8     8.00     200

</CsScore>
</CsoundSynthesizer>

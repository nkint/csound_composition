<CsoundSynthesizer>
<CsInstruments>

sr         =         44100
kr         =         4410
ksmps      =         10
nchnls     =         2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; panning fm instrument
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; exhuberta use of fm.
; modulator amp driven by an exponential interpolation
; carrier and modulator frequencies waved by an lfo oscillator
; with a final ADSR like envelope

instr   81 
    ; great resources for foscil
    ; http://bigwinky.com/blog/?p=72 - Seven things I've learned about FM synthesis

    i_dur               =        p3
    i_amp               =        ampdb(p4)
    i_note              =        cpspch(p5)
    i_carrier_freq      =        p6
    i_modulator_freq    =        p7
    i_atk               =        0.01  ; very fast attack
    i_rel               =        0.1   ; quite fast decacy
    indx1               =        p8
    indx2               =        p9
    indxtim             =        p10    
    i_lfo_amp           =        p11
    i_lfo_freq          =        p12        
    ipan                =        p13

    ; ADSR like envelope
    k_amplitude_final    expseg .01, 
                                i_atk, 
                                i_amp, 
                                i_dur/8, 
                                i_amp*.6, 
                                i_dur-(i_atk+i_rel+i_dur/8), 
                                i_amp*.7, 
                                i_rel,
                                .01

    k_lfo                oscil  i_lfo_amp, 
                                i_lfo_freq, 
                                1

    ; this is the modulation degree
    k_modulator_amp      expon indx1, 
                               indxtim, 
                               indx2         

    ; FM instrument here
    asig                 foscil k_amplitude_final, 
                                i_note+k_lfo, 
                                i_carrier_freq, 
                                i_modulator_freq, 
                                k_modulator_amp, 
                                1 					; f-table

    outs asig*ipan, asig*(1-ipan)

endin

</CsInstruments>
<CsScore>

f1  0 4096 10  1

;;;;;;;;;;;;;;;;;;;
; fm instrument
;;;;;;;;;;;;;;;;;;;

;  instr  start     dur   final  fm     carrier   modulat  modulation  modulation  modulation  lfo    lfo      pan
;         time            ampl   freq   freq      freq     exp start   exp end     exp dur     amp    freq     factor

i    81     37.8     .2   79     6.09   2         1            30         1           .01      9       4        1
i    81     +        .    79     .      2         1            <          <           <        <       <        <
i    81     +        .    78     .      1         3            <          <           <        <       <        <
i    81     +        .    77     .      3         1            <          <           <        <       <        <
i    81     +        .    76     .      1         4            <          <           <        <       <        <
i    81     +        .    75     .      4         1            <          <           <        <       <        <
i    81     +        .    74     .      1         5            <          <           <        <       <        <
i    81     +        1    73     .      5         1            10         3           .2       4       10       0

</CsScore>
</CsoundSynthesizer>

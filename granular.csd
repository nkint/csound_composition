<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>

sr         =         44100
kr         =         4410
ksmps      =         10
nchnls     =         2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; echo pan grain
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; granular synthesis as it is
; all parameters are quite a hell but with nice variable names i think it is a little bit easier to follow
; anyway.
; some random clouds of grains are generated
; and some delay is applied.

instr 7
    i_dur                    =    p3
    i_amp                    =    ampdb(p4)    			
    													; ampdb
    													; returns  the amplitude equivalent of the decibel value x.

    i_central_freq           =    p5                    ; central frequency
    i_amplitude_variation    =    ampdb(p7)             ; amplitude variation range
    i_frequency_variation    =    p8                    ; frequency variation range
    
    i_grain_density          =    p6    
    i_grain_dur              =    p9                    ; grain duration
    
    k_amplitude_rnd          rand    i_amplitude_variation/2    ; variation of amplitude
    k_freq_rnd               rand    i_frequency_variation/2    ; variation of frequency
    i_grain_gen              =    1                             ; gen function for grains
    i_grain_inv              =    3                     ; gen function for inv
    i_max_gran_dur           =    .1                    ; max grain duration
    
    i_pan                    =    p10                                  
    k_pan_left               =    sqrt(i_pan)
    k_pan_right              =    sqrt(1-i_pan)
    
    k_envelope_amplitude     expseg i_amp, i_dur, 0.001
    
    ; granular synthesis black magic here
    agrain                   grain    k_envelope_amplitude, 
                                      i_central_freq, 
                                      i_grain_density, 
                                      k_amplitude_rnd, 
                                      k_freq_rnd, 
                                      i_grain_dur, 
                                      i_grain_gen, 
                                      i_grain_inv, 
                                      i_max_gran_dur
    
    aeco                     delay    agrain, .005
    aeco2                    delay    agrain, .05

    outs (agrain+ aeco+aeco2) * k_pan_left , (agrain+aeco+aeco2) * k_pan_right
endin

</CsInstruments>
<CsScore>

f1  0 4096 10  1                    
f03 0 1024 10  1                    

;;;;;;;;;;;;;;;;;;;
; echo pan granular
;;;;;;;;;;;;;;;;;;;

;  instr  start     dur  ampl   central   grain      ampl      freq      grain     pan
;         time                   freq    density  variation  variation  duration  factor

i    7     33.8     .35   60     2000      80        55        400        .007     .61
i    7     +        .35   >      4500      60        70        400        .007     .625
i    7     +        .7    70     2000      100       80        400        .007     .51
i    7     +        .35   60     4500      100       55        400        .007     .61
i    7     +        .35   >      2000      60        70        400        .007     .625
i    7     +        .7    70     4500      80        80        400        .007     .51

</CsScore>
</CsoundSynthesizer>
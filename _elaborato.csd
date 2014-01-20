<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>



; Alberto Massa, 772900
; Universita' degli Studi di Milano
; Elaborato di programmazione timbrica
; Professor Ludovico Luca Andrea



sr 		= 		44100
kr 		= 		4410
ksmps 	= 		10
nchnls 	= 		2



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; instument 21: bordone.
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

    k_deviation    randh 10,10, .5            
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



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; instrument 10: additive bass
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
    a3    oscil    p4*0.30, i_note*1.006-.12, 06
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



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; instrument 5: circle 
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



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; instrument 81: fm instrument
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



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; instrument 7: echo pan grain
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
    agrain                   grain    k_envelope_amplitude, ; grain ampl
                                      i_central_freq,       ; grain pitch
                                      i_grain_density,      ; grain per second
                                      k_amplitude_rnd, 
                                      k_freq_rnd, 
                                      i_grain_dur, 
                                      i_grain_gen, 
                                      i_grain_inv,          ; envelope for grains
                                      i_max_gran_dur
    
    aeco                     delay    agrain, .005
    aeco2                    delay    agrain, .05

    outs (agrain+ aeco+aeco2) * k_pan_left , (agrain+aeco+aeco2) * k_pan_right
endin



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; instrument 22: hithat 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; attempt to cymbal sound with subtractive synthesis

instr 22
	i_balance	=	p4
	
	k1	expon		10000, .1, 2500
	a0	expon		p5+150, .1, 10
	a1	rand		a0
	a3	butterlp	a1,k1
	a4	butterlp	a3,k1
	a5	butterhp	a4,3500
	a6	butterhp	a5,3500
	a8	linen		(a6+a1)*6, 0, p3, .05  

	outs a8*i_balance, a8*(1-i_balance)
endin



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 135: elastic sample sound
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; play a sound distorting the pitch in a sinusoidal way, reverberate it,
; and output the distorted plus the reverberated

instr 135
	i_dur		=		p3
	i_amp		=		p4
	i_gain	    =		p5
	i_loopt	    =		p6

	k_vel		oscili	0.4, 0.2, 1 							
																; oscili - interpolated version of oscil
																; amplitude, frequency, f-table

	k_env		linen	i_amp, .01, i_dur, .01
	ain 		diskin2  "ah_ah.wav", 1+k_vel
																; diskin2 namefile pitch

	acomb 	    comb	ain*k_env, i_gain, i_loopt
																; comb asig, rvt, ilpt
																; Reverberates an input signal with a “colored” frequency response.
																; asig: input signal
																; rvt: reverberation time
																; ilpt: loop time in second, the "echo density"

	out		    (ain+acomb), (ain+acomb)
endin



</CsInstruments>
<CsScore>


f1  0 4096 10  1                                    ; sinwave for fm instrument, granular, and sample sound
f03 0 1024 10  1                                    ; sinwave for bassline, bordone and granular
f06 0 2048 10 1 1 1 1 .7 .5 .3 .1                   ; sinewave for bassline
f10 0 1024 21  1                                    ; uniform random distribution (white noise) for bordone
f11 0 2048 10 1                                     ; sinewave for circle
f18 0 512  5 1 512 256                              ; draw segment (from 1 to 256 in 512 step) exponential



;;;;;;;;;;;;;;;;;;;
; bordone
;;;;;;;;;;;;;;;;;;;

;  instr  start     dur     central   oscil
;         time               note     ampl

i   21     0        25.6     8.00     200
i   21     44.8     15.2     8.00     200



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



;;;;;;;;;;;;;;;;;;;
; hithat drum
;;;;;;;;;;;;;;;;;;;

;   P1            P2      P3        P4       P5
;  instr         start   dur     stereo    attack
;                                balance

i   22            19.2    .2       .2        50
i   22            +       .        .         200
i   22            +       .        .         50 
i   22            +       .        .         200
i   22            +       .        .         50 
i   22            +       .        .         200
i   22            +       .        .         50 
i   22            +       .        .         200
                                                          
i   22            +       .        .8        50 
i   22            +       .        <         200
i   22            +       .        <         50 
i   22            +       .        <         200
i   22            +       .        <         50 
i   22            +       .        <         200
i   22            +       .        <         50 
i   22            +       .        .2        200

i   22            +       .        .5        50
i   22            +       .        .         200
i   22            +       .        .         50
i   22            +       .        .         200
i   22            +       .        .         50
i   22            +       .        .         200
i   22            +       .        .         50
i   22            +       .        .         200

i   22            +       .        .8        50
i   22            +       .        <         200
i   22            +       .        <         50
i   22            +       .        <         200
i   22            +       .        <         50
i   22            +       .        <         200
i   22            +       .        <         50
i   22            +       .        .2        200

;4

i   22            +       .        .5        50
i   22            +       .        .         200
i   22            +       .        .         50
i   22            +       .        .         200
i   22            +       .        .         50
i   22            +       .        .         200
i   22            +       .        .         50
i   22            +       .        .         200

i   22            +       .        .8        50
i   22            +       .        <         200
i   22            +       .        <         50
i   22            +       .        <         200
i   22            +       .        <         50
i   22            +       .        <         200
i   22            +       .        <         50
i   22            +       .        .2        200

;6

i   22            +       .        .5        50
i   22            +       .        .         200
i   22            +       .        .         50
i   22            +       .        .         200
i   22            +       .        .         50
i   22            +       .        .         200
i   22            +       .        .         50
i   22            +       .        .         200

i   22            +       .        .8        50
i   22            +       .        <         200
i   22            +       .        <         50
i   22            +       .        <         200
i   22            +       .        <         50
i   22            +       .        <         200
i   22            +       .        <         50
i   22            +       .        .2        200

;8

i   22            +       .        .5        50
i   22            +       .        .         200
i   22            +       .        .         50
i   22            +       .        .         200
i   22            +       .        .         50
i   22            +       .        .         200
i   22            +       .        .         50
i   22            +       .        .         200

i   22            +       .        .8        50
i   22            +       .        <         200
i   22            +       .        <         50
i   22            +       .        <         200
i   22            +       .        <         50
i   22            +       .        <         200
i   22            +       .        <         50
i   22            +       .        .2        200

;10

i   22            +       .        .5        50
i   22            +       .        .         200
i   22            +       .        .         50
i   22            +       .        .         200
i   22            +       .        .         50
i   22            +       .        .         200
i   22            +       .        .         50
i   22            +       .        .         200

i   22            +       .        .8        50
i   22            +       .        <         200
i   22            +       .        <         50
i   22            +       .        <         200
i   22            +       .        <         50
i   22            +       .        <         200
i   22            +       .        <         50
i   22            +       .        .2        200

;12

i   22            +       .        .5        50
i   22            +       .        .         200
i   22            +       .        .         50
i   22            +       .        .         200
i   22            +       .        .         50
i   22            +       .        .         200
i   22            +       .        .         50
i   22            +       .        .         200

i   22            +       .        .8        50
i   22            +       .        <         200
i   22            +       .        <         50
i   22            +       .        <         200
i   22            +       .        <         50
i   22            +       .        <         200
i   22            +       .        <         50
i   22            +       .        .2        200

;14

i   22            +       .        .5        50
i   22            +       .        .         200
i   22            +       .        .         50
i   22            +       .        .         200
i   22            +       .        .         50
i   22            +       .        .         200
i   22            +       .        .         50
i   22            +       .        .         200

i   22            +       .        .8        50
i   22            +       .        <         200
i   22            +       .        <         50
i   22            +       .        <         200
i   22            +       .        <         50
i   22            +       .        <         200
i   22            +       .        <         50
i   22            +       .        .2        200

;16

i   22            +       .        .5        50
i   22            +       .        .         200
i   22            +       .        .         50
i   22            +       .        .         200
i   22            +       .        .         50
i   22            +       .        .         200
i   22            +       .        .         50
i   22            +       .        .         200

i   22            +       .        .8        50
i   22            +       .        <         200
i   22            +       .        <         50
i   22            +       .        <         200
i   22            +       .        <         50
i   22            +       .        <         200
i   22            +       .        <         50
i   22            +       .        .2        200

;18
;Ends at 48


i   22            48      .1       0         30
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        1         .

i   22            +       .1       1         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        0         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .05      0         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        1         .

;2

i   22            +       .1       2.00      .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        1         .

i   22            +       .1       2.00      .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .05      <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        1         .

;4

i   22            +       .1       2.00      .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        1         .

i   22            +       .1       2.00      .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .05      <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        <         .
i   22            +       .        1         .


;;;;;;;;;;;;;;;;;;;
; elastic sample sound
;;;;;;;;;;;;;;;;;;;

;   instrument   start    duration    effect       reverb     echo
;                time                amplitude      gain     intensity 

i       135      25.8         5         .4           10        .5 
i       135      26.2         5         .3           5         .25   
i       135      27.7         5         .3           5         .125 


</CsScore>
</CsoundSynthesizer>

<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>

sr 		= 		44100
kr 		= 		4410
ksmps 	= 		10
nchnls 	= 		2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; elastic sample sound
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

f1  0 4096 10  1

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
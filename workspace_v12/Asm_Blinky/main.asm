;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file
            
;-------------------------------------------------------------------------------
            .def    RESET                   ; Export program entry-point to
                                            ; make it known to linker.
;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory.
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section.
            .retainrefs                     ; And retain any sections that have
                                            ; references to current section.

;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer


;-------------------------------------------------------------------------------
; Main loop here
;-------------------------------------------------------------------------------

init:
			bic.w 	#0001h, &PM5CTL0		; disable the GPIO power-on HighZ [16bit]
			bis.b 	#01h, &P1DIR			; setting the P1.0 as an output (P1.0=LED1) [8bit]

main:
			xor.b 	#01h, &P1OUT			; toggle P1.0 (LED1) [8bit]

			mov.w 	#0FFFFh, R4				; puts a big number in R4 [16bit]

delay:
			dec.w 	R4						; decrease by 1 in R4 [16bit]
			jnz 	delay					; repeat until R4=0

			jmp		main					; repeate main loop forever

                                            

;-------------------------------------------------------------------------------
; Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect   .stack
            
;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
            

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
			bis.b	#BIT0, &P1DIR; Setup P1.0 as output
			bic.b	#BIT0, &P1OUT; inital value LED

			bic.b 	#BIT1, &P4DIR; Setup P4.1 as input
			bis.b 	#BIT1, &P4REN; enable pull down/up resistor on
			bis.b 	#BIT1, &P4OUT;conf R as pull up

			bic.b	#LOCKLPM5, &PM5CTL0;enabled digital I/O

main:

poll_S1:
			bit.b	#BIT1, &P4IN; test P4.1
			jnz		poll_S1;stay in polling

toggle_LED1:
			xor.b	#BIT0, &P1OUT;toggle

;-------------------------------------------
			mov.w   #0FFFFh, R4
delay:
			dec.w	R4
			jnz		delay
;-------------------------------------------
			jmp 	main
			nop
                                            

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
            

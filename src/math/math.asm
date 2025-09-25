.importzp tmp1

.code
; Multiply 2 numbers
; -- Vars --
;   X: multiplicand
;   tmp1: multiplier
; -- Return --
;   A: product
.proc multiply
    LDA #$00
    INX
@add:
    DEX
    BEQ @done    ; if (X != 0) { @done }

    CLC
    ADC tmp1
    JMP @add

@done:
    RTS
.endproc

.export multiply

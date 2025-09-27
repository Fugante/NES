.importzp tmp1
.importzp tmp2
.importzp seed

.code
; Brad Smith's optimized 16-bit galois linear-feedback shift register PRNG
; implementation. @see https://github.com/bbbradsmith/prng_6502
; -- Vars --
;   seed: any number except 0
; -- Returns --
;   A: a random number
.proc galois16o
    LDA seed + 1
    TAY
    LSR
    LSR
    LSR
    STA seed + 1
    LSR
    EOR seed + 1
    LSR
    EOR seed + 1
    EOR seed + 0
    STA seed + 1
    TYA
    STA seed + 0
    ASL
    EOR seed + 0
    ASL
    EOR seed + 0
    ASL
    ASL
    ASL
    EOR seed + 0
    STA seed + 0

    RTS
.endproc

; Calculate the correct bit mask for the rejection sampling algorithm
.proc _find_mask
    LDA #%00000001
@loop:
    CMP tmp1
    BCC @shift_left        ; if (lda < tmp1) { shift left }

    RTS

@shift_left:
    SEC
    ROL
    JMP @loop
.endproc

; Generate a random number from 0 to n using LFSRs and rejection sampling
; algorithms. Code taken from NesHacker, https://github.com/NesHacker/NES-RNG
; -- Vars --
;   tmp1: n, upper bound
; -- Returns --
;   A: number between 0 and n
.proc random_int
@loop:
    JSR _find_mask
    STA tmp2
    ; Generate a random byte
    JSR galois16o
    ; Cut off the bits we don't need with an and operation
    AND tmp2
    ; Compare the result to 20 and retry if it's out of bounds
    CMP tmp1
    BPL @loop
    ; Add one (since the result is from 0 through 19)
    CLC
    ADC #1

    RTS
.endproc

.export galois16o
.export random_int

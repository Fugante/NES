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

.export galois16o

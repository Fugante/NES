.include "io.asm"

.importzp joy1

.code
.proc poll_controller
    PHA
    TXA
    PHA
    PHP

    ; write a 1, then a 0, to CONTROLLER1 to latch button states
    LDA #$01
    STA JOY1
    LDA #$00
    STA JOY1

    LDA #%00000001
    STA joy1
@poll:
    LDA JOY1        ; read next button's state
    LSR A           ; shift button state right, into carry flag
    ROL joy1        ; rotate button state from carry flag onto right side of pad1 
                    ; and leftmost 0 of pad1 into carry flag
    BCC @poll       ; continue until original "1" is in carry flag

    PLP
    PLA
    TAX
    PLA

    RTS
.endproc

.export poll_controller

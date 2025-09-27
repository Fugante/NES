.include "../io.asm"

.importzp joy1_down
.importzp joy1_sus

.code
.proc update_controller
    lda joy1_down
    tay
    lda #%00000001
    sta JOY1
    sta joy1_down
    lsr             ; now %00000000
    sta JOY1
@poll:
    lda JOY1        ; read next button's state
    lsr             ; shift button state right, into carry flag
    rol joy1_down   ; rotate byte from carry flag onto right side of joy1_down and left-most 0 into carry flag
    bcc @poll       ; continue until original "1" is in carry flag

    tya
    eor joy1_down
    and joy1_down
    sta joy1_sus

    rts
.endproc

.export update_controller

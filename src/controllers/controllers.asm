.include "../io.asm"

.importzp joy1_press
.importzp joy1_down

.code
; Read controller and store input.
; The routine reads the controller input ans stores it into two variables, joy_down
; and joy_press. The first one stores the buttons that are pressed down; the other 
; the buttons that were just pressed. Posible combinations:
; down pressed
;  X    X       button has not been pressed
;  O    O       button has just been pressed
;  O    X       button is being pressed down
;  X    O       button has been released
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
    eor joy1_down   ; check if the button was just pressed and store the result
    and joy1_down
    sta joy1_press

    rts
.endproc

.export update_controller

.include "../constants.asm"
.include "../io.asm"

.importzp tmp1
.importzp player_x
.importzp player_y
.importzp target_velocity_x
.importzp target_velocity_y
.importzp player_velocity_x
.importzp player_velocity_y
.importzp player_sprite_attrs
.importzp joy1_down

.import player_sprites

.code
.scope Player
    .scope Initial
        player_x = SCREEN_WIDTH / 2
        player_y = SCREEN_HEIGHT - 10
        player_sprite_attrs = $00
    .endscope

    .enum Heading
        Right = 0
        Left = 1
    .endenum

    .enum MotionState
        Still = 0
        Move = 1
        Pivot = 3
    .endenum

    .proc init_player
        jsr init_x
        jsr init_y
        jsr init_sprites
    .endproc

    .proc init_x
        lda #Initial::player_x
        sta player_x
        rts
    .endproc

    .proc init_y
        lda #Initial::player_y
        sta player_y
        rts
    .endproc

    .proc init_sprites
        lda #Initial::player_sprite_attrs
        sta player_sprite_attrs
        rts
    .endproc

    .scope Movement
        .proc update
            jsr set_target_velocity
            jsr accelerate
            jsr move
            rts
        .endproc

        .proc set_target_velocity
            ldx #$00
            lda #BTN_B
            and joy1_down
            beq @no_direction
            inx
        @no_direction:
            lda #$00
            sta target_velocity_x
            sta target_velocity_y
        @check_right:
            lda #BTN_RIGHT
            and joy1_down
            beq @check_left
            lda positive_velocity, x
            sta target_velocity_x
            jmp @check_up
        @check_left:
            lda #BTN_LEFT
            and joy1_down
            beq @check_up
            lda negative_velocity, x
            sta target_velocity_x
        @check_up:
            lda #BTN_UP
            and joy1_down
            beq @check_down
            lda negative_velocity, x
            sta target_velocity_y
            jmp @done
        @check_down:
            lda #BTN_DOWN
            and joy1_down
            beq @done
            lda positive_velocity, x
            sta target_velocity_y
        @done:
            rts

        positive_velocity:
            .byte %00000001, %00000100
        negative_velocity:
            .byte %11111111, %11111100   ; 2's complement of positive_velocity
        .endproc

        .proc accelerate
            lda target_velocity_x
            bmi @negative
        @positive:
            cmp player_velocity_x
            bcc @done
            beq @done
            inc player_velocity_x
            jmp @done
        @negative:
            cmp player_velocity_x
            bcc @done
            beq @done
            dec player_velocity_x
        @done:
            rts
        .endproc

; positive:
; pv<tv  zc   pv=tv  zc  pv>tv  zc
;   0100        0100       0100
;   0001        0100       0111
; - ----      - ----     - ----
;   0011 00     0000 11    1101 01
; 
; negative:
;   1100       1100        1100
;   1111       1100        1001
; - ----     - ----      - ----
;   1101 01    0000 11     0011 00
; 
; 0010 (2)
; 1110 (2 two's complement)
; 
; -1
; 
; 1101 (x two's complement)
; 0011 (3)

;             lda player_velocity_x
;             bmi @negative
;         @positive:
;             ; if moving right only accelerate if the target velocity is higher
;             cmp target_velocity_x
;             bcc @accelerate
;             jmp @done
;         @negative:
;             ; similarly , if moving left only accelerate if target velocity is lower
;             cmp target_velocity_x
;             bcs @accelerate
;             jmp @done
;         @accelerate:
;             lda target_velocity_x
;             sta player_velocity_x
;         @accelerate:
;             ; Subtract the current velocity from the target velocity to compare the
;             ; two values.
;             ; If V - T == 0:
;             ;   Then the current velocity is at the target and we are done.
;             ; If V - T < 0:
;             ;   Then the velocity is greater than the target and should be decreased.
;             ; Otherwise, if V - T > 0:
;             ;   Then the velocity is less than the target and should be increased.
;             lda player_velocity_x
;             sec
;             sbc target_velocity_x
;             bne @check_greater
;             jmp @done
;         @check_greater:
;             bmi @lesser
;             dec player_velocity_x
;         @lesser:
;             inc player_velocity_x
;         @done:
;             rts
;         .endproc

        .proc move
            lda player_velocity_x
            clc
            adc player_x
            sta player_x
            lda player_velocity_y
            clc
            adc player_y
            sta player_y
            rts
        .endproc

;         .proc update
;             jsr set_target_velocity
;             jsr accelerate
;             jsr move
;             jsr update_motion
;             rts
;         .endproc
; 
;         .proc set_target_velocity
;             ; check if the B button is being pressed down and save the state in the X
;             ; register
;             ldx #$00
;             lda #BTN_B
;             and joy1_down
;             beq @check_right
;             inx
;         @check_right:
;             lda #btn_right
;             and joy1_down
;             beq @check_left
;             lda positive_velocity, x
;             sta target_velocity_x
;             jmp @check_up
;         @check_left:
;             lda #BTN_LEFT
;             and joy1_down
;             beq @check_up
;             lda negative_velocity, x
;             sta target_velocity_x
;         @check_up:
;             lda #BTN_UP
;             and joy1_down
;             beq @check_down
;             lda negative_velocity, x
;             sta target_velocity_y
;             jpm @done
;         @check_down:
;             lda #BTN_DOWN
;             and joy1_down
;             beq @no_direction
;             lda positive_velocity, x
;             sta target_velocity_y
;             jmp @done
;         @no_direction:
;             lda #$00
;             sta target_velocity_x
;             sta target_velocity_y
;         @done:
;             rts
; 
;         positive_velocity:
;             .byte $18, $28
;         negative_velocity:
;             .byte $e8, $d8
;         .endproc
; 
;         .proc accelerate_x
;             lda player_velocity_x
;             bmi @negative
;         @positive:
;             cmp target_velocity_x
;             bcc @accelerate
;             jmp @done
;         @negative:
;             cmp target_velocity_x
;             bcs @accelerate
;             jmp @done
;         @accelerate:
;             lda player_velocity_x
;             sec
;             sbc target_velocity_x
;             bne @check_greater
;         @check_greater:
;             bmi @lesser
;             dec player_velocity_x
;             jmp @done
;         @lesser:
;             inc player_velocity_x
;         @done:
;             rts
;         .endproc
; 
;         .proc accelerate_y
;             lda player_velocity_y
;             bmi @negative
;         @positive:
;             cmp target_velocity_y
;             bcc @accelerate
;             jmp @done
;         @negative:
;             cmp target_velocity_y
;             bcs @accelerate
;             jmp @done
;         @accelerate:
;             lda player_velocity_y
;             sec
;             sbc target_velocity_y
;             bne @check_greater
;         @check_greater:
;             bmi @lesser
;             dec player_velocity_y
;             jmp @done
;         @lesser:
;             inc player_velocity_y
;         @done:
;             rts
;         .endproc
; 
;         .proc update_position
;             ; Check to see if we're moving to the right (positive) or the left (negative)
;             lda player_velocity_x
;             bmi @negative
;         @positive:
;             ; Positive velocity is easy: just add the 4.4 fixed point velocity to the
;             ; 12.4 fixed point position.
;             clc
;             adc player_x
;             sta player_x
;             lda #$00
;             adc player_x + 1
;             sta player_x + 1
;             jmp @done
;         @negative:
;             lda #0
;             sec
;             sbc player_velocity_x
;             sta 
; 
; 
;             @negative:
;             ; There's probably a really clever way to do this just with ADC but I am
;             ; lazy and conceptually it made things easier in my head to invert the
;             ; negative velocity and use SBC.
;             lda #0
;             sec
;             sbc velocityX
;             sta $00
;             lda positionX
;             sec
;             sbc $00
;             sta positionX
;             lda positionX+1
;             sbc #0
;             sta positionX+1
;             rts
;         .endproc
; 
;         .proc update_motion
;             ; check left direction
;             lda joy1_down           ; load button presses
;             and #BTN_LEFT           ; filter out all but left;
;             beq @check_right        ; if (A == 0) { @check_right } (left is not pressed)
; 
;             dec player_x
;             jmp @check_up
; 
;         @check_right:
;             lda joy1_down
;             and #BTN_RIGHT
;             beq @check_up           ; if (A == 0) { @check_up } (right is not pressed)
; 
;             inc player_x
; 
;         @check_up:
;             lda joy1_down
;             and #BTN_UP
;             beq @check_down         ; if (A == 0) { @check_down } (up is not pressed)
; 
;             dec player_y
;             jmp @done
; 
;         @check_down:
;             lda joy1_down
;             and #BTN_DOWN
;             beq @done               ; if (A != 0) { @done } (down is not pressed)
; 
;             inc player_y
; 
;         @done:
;             rts
;         .endproc
; 
        .proc check_limits
            ; check left
            lda player_x
            cmp #SCREEN_LEFT_LIMIT
            bcs @check_right        ; if (player_x > left limit) { @check_right }

            ldx #SCREEN_LEFT_LIMIT - 1
            stx player_x
            jmp @check_up

        @check_right:
            cmp #SCREEN_RIGHT_LIMIT
            BCC @check_up           ; if (player_x < right limit) { @check_up }

            ldx #SCREEN_RIGHT_LIMIT
            stx player_x

        @check_up:
            lda player_y
            cmp #SCREEN_UPPER_LIMIT
            bcs @check_down         ; if (player_y > upper limit) { @check_down }

            ldx #SCREEN_UPPER_LIMIT
            stx player_y
            jmp @done

        @check_down:
            cmp #SCREEN_LOWER_LIMIT
            BCC @done               ; if (player_y < lower limit) { @done }

            ldx #SCREEN_LOWER_LIMIT
            stx player_y

        @done:
            rts
        .endproc
    .endscope

    .scope Sprite
        .proc update
            ; top left tile (x - OFFSET_2x2, y - OFFSET_2x2)
            ldx #$00
            lda player_y
            sec
            sbc #OFFSET_2x2             ; byte 0: y position
            sta $0204                   ; store player info in the 2nd spot of OAM RAM
            lda player_sprites,x
            sta $0205                   ; byte 1: sprite number
            lda player_sprite_attrs
            sta $0206                   ; byte 2: attributes
            lda player_x
            sec
            sbc #OFFSET_2x2
            sta $0207                   ; byte 3: x position
            ; top right tile (x, y - OFFSET_2x2)
            lda player_y
            sec
            sbc #OFFSET_2x2
            sta $0208
            lda player_sprites,x        ; same tile as before
            sta $0209
            lda player_sprite_attrs
            eor #%01000000              ; flip sprite horizontally
            sta $020a
            lda player_x
            sta $020b
            ; bottom left tile (x - 7, y)
            inx
            lda player_y
            sta $020c
            lda player_sprites,X        ; next tile
            sta $020d
            lda player_sprite_attrs
            sta $020e
            lda player_x
            sec
            sbc #OFFSET_2x2
            sta $020f
            ; bottom right tile (x, y)
            lda player_y                ; same tile as before
            sta $0210
            lda player_sprites,X
            sta $0211
            lda player_sprite_attrs
            eor #%01000000              ; flip sprite horizontally
            sta $0212
            lda player_x
            sta $0213

            rts
        .endproc
    .endscope

    .proc update_player
        jsr Movement::update
        jsr Movement::check_limits
        jsr Sprite::update
        rts
    .endproc

.export init_player
.export update_player
.endscope

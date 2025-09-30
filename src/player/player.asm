.include "../constants.asm"
.include "../io.asm"

.importzp tmp1
.importzp tmp2
.importzp player_x
.importzp player_y
.importzp target_velocity_x
.importzp target_velocity_y
.importzp player_velocity_x
.importzp player_velocity_y
.importzp player_sprite_x
.importzp player_sprite_y
.importzp player_sprite_attrs
.importzp joy1_down

.import player_sprites

.code
.scope Player
    .scope Initial
        player_x0 = %00001000
        player_x1 = %00000000
        player_y = SCREEN_HEIGHT - 16
        player_sprite_attrs = $00
    .endscope

    ; Velocities expressed in fixed point values 4.4
    .scope Velocities
        positive:
            .byte %00010000, %01000000  ; 1.0 and 4.0 pixels per frame
        negative:
            .byte %11110000, %11000000  ; 2's complement of positive velocities
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
        lda #Initial::player_x0
        sta player_x
        lda #Initial::player_x1
        sta player_x + 1
    @done:
        rts
    .endproc

    .proc init_y
        lda #Initial::player_y
        sta player_y
    @done:
        rts
    .endproc

    .proc init_sprites
        lda #Initial::player_sprite_attrs
        sta player_sprite_attrs
    @done:
        rts
    .endproc

    .scope Movement
        .proc update
            jsr set_target_velocity_x
            jsr accelerate
            jsr move
            jsr bound_position_x
        @done:
            rts
        .endproc

        .proc set_target_velocity_x
            ldx #$00
            lda #BTN_B
            and joy1_down
            beq @check_right
            inx
        @check_right:
            lda #BTN_RIGHT
            and joy1_down
            beq @check_left
            lda Velocities::positive, x
            sta target_velocity_x
            jmp @done
        @check_left:
            lda #BTN_LEFT
            and joy1_down
            beq @no_direction
            lda Velocities::negative, x
            sta target_velocity_x
            jmp @done
        @no_direction:
            lda #$00
            sta target_velocity_x
        @done:
            rts
        .endproc

        .proc accelerate
            lda player_velocity_x
            sec
            sbc target_velocity_x
            bne @check_greater
            jmp @done
        @check_greater:
            bmi @lesser
            dec player_velocity_x
            jmp @done
        @lesser:
            inc player_velocity_x
        @done:
            rts
        .endproc

        .proc move
            lda player_velocity_x
            bmi @negative
        @positive:
            clc
            adc player_x + 1
            sta player_x + 1
            lda #$00
            adc player_x
            sta player_x
            jmp @done
        @negative:
            lda #$00
            sec
            sbc player_velocity_x
            sta tmp1
            lda player_x + 1
            sec
            sbc tmp1
            sta player_x + 1
            lda player_x
            sbc #$00
            sta player_x
        @done:
            rts
        .endproc

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

        .proc bound_position_x
            lda player_x
            sta tmp1
            lda player_x + 1
            sta tmp2
            asl tmp2
            rol tmp1
            asl tmp2
            rol tmp1
            asl tmp2
            rol tmp1
            asl tmp2
            rol tmp1
            lda tmp1
            sta player_sprite_x
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
            lda player_sprite_x
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
            lda player_sprite_x
            sta $020b
            ; bottom left tile (x - 7, y)
            inx
            lda player_y
            sta $020c
            lda player_sprites,X        ; next tile
            sta $020d
            lda player_sprite_attrs
            sta $020e
            lda player_sprite_x
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
            lda player_sprite_x
            sta $0213
        @done:
            rts
        .endproc
    .endscope

    .proc update_player
        jsr Movement::update
        nop
        ;jsr Movement::check_limits
        jsr Sprite::update
    @done:
        rts
    .endproc

.export init_player
.export update_player
.endscope

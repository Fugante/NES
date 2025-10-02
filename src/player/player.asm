.include "../constants.asm"
.include "../io.asm"

.importzp tmp1
.importzp tmp2
.importzp addr1
.importzp addr2
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
        player_y0 = %00001110
        player_y1 = %00000000
        player_sprite_attrs = $00
    .endscope

    ; Velocities expressed in fixed point values 4.4
    .scope Velocities
        positive:
            .byte %00010000, %01000000  ; 1.0 and 4.0 pixels per frame
        negative:
            .byte %11110000, %11000000  ; 2's complement of positive velocities
    .endscope

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
        lda #Initial::player_y0
        sta player_y
        lda #Initial::player_y1
        sta player_y + 1
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
            jsr set_target_velocities
            jsr accelerate
            jsr move
            jsr bound_position
        @done:
            rts
        .endproc

        .proc set_target_velocities
        @x_axis:
            lda #BTN_RIGHT
            sta tmp1
            lda #BTN_LEFT
            sta tmp2
            lda #<target_velocity_x
            sta addr1
            lda #>target_velocity_x
            sta addr1 + 1
            jsr set_target_velocity
        @y_axis:
            lda #BTN_DOWN
            sta tmp1
            lda #BTN_UP
            sta tmp2
            lda #<target_velocity_y
            sta addr1
            lda #>target_velocity_y
            sta addr1 + 1
            jsr set_target_velocity
        @done:
            rts
        .endproc

        .proc accelerate
        @x_axis:
            lda #<player_velocity_x
            sta addr1
            lda #>player_velocity_x
            sta addr1 + 1
            lda target_velocity_x
            sta tmp1
            jsr update_velocity
        @y_axis:
            lda #<player_velocity_y
            sta addr1
            lda #>player_velocity_y
            sta addr1 + 1
            lda target_velocity_y
            sta tmp1
            jsr update_velocity
        @done:
            rts
        .endproc

        .proc move
        @x_axis:
            lda player_velocity_x
            sta tmp1
            lda #<player_x
            sta addr1
            lda #>player_x
            sta addr1 + 1
            jsr update_position
        @y_axis:
            lda player_velocity_y
            sta tmp1
            lda #<player_y
            sta addr1
            lda #>player_y
            sta addr1 + 1
            jsr update_position
        @done:
            rts
        .endproc

        .proc bound_position
        @x_axis:
            lda #<player_x
            sta addr1
            lda #>player_x
            sta addr1 + 1
            lda #<player_sprite_x
            sta addr2
            lda #>player_sprite_x
            sta addr2 + 1
            jsr set_screen_position
        @y_axis:
            lda #<player_y
            sta addr1
            lda #>player_y
            sta addr1 + 1
            lda #<player_sprite_y
            sta addr2
            lda #>player_sprite_y
            sta addr2 + 1
            jsr set_screen_position
        @done:
            rts
        .endproc

        .proc set_target_velocity
            ldy #$00
            ldx #$00
            lda #BTN_B
            and joy1_down
            beq @check_positive             ; if (button B is pressed) { x++ }
            inx
        @check_positive:
            lda tmp1                        ; positive direction button mask
            and joy1_down
            beq @check_negative
            lda Velocities::positive, x
            sta (addr1), y                  ; pointer to the velocity variable
            jmp @done
        @check_negative:
            lda tmp2                        ; negative direction button mask
            and joy1_down
            beq @no_direction
            lda Velocities::negative, x
            sta (addr1), y
            jmp @done
        @no_direction:
            lda #$00
            sta (addr1), y
        @done:
            rts
        .endproc

        .proc update_velocity
            ldy #$00
            lda (addr1), y                  ; pointer to current velocity
            tax
            sec
            sbc tmp1                        ; target velocity
            bne @check_greater
            jmp @done
        @check_greater:
            bmi @lesser
            dex
            jmp @done
        @lesser:
            inx
        @done:
            txa
            sta (addr1), y
            rts
        .endproc

        .proc update_position
            ldy #$01
            lda tmp1                ; current_velocity
            bmi @negative
        @positive:
            clc
            adc (addr1), y          ; pointer to current position
            sta (addr1), y
            dey
            lda #$00
            adc (addr1), y
            sta (addr1), y
            jmp @done
        @negative:
            lda #$00
            sec
            sbc tmp1
            sta tmp2
            lda (addr1), y
            sec
            sbc tmp2
            sta (addr1), y
            dey
            lda (addr1), y
            sbc #$00
            sta (addr1), y
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

        .proc set_screen_position
            ldy #$00
            lda (addr1), y          ; pointer to current position
            sta tmp1
            iny
            lda (addr1), y
            sta tmp2
            asl tmp2
            rol tmp1
            asl tmp2
            rol tmp1
            asl tmp2
            rol tmp1
            asl tmp2
            rol tmp1
            dey
            lda tmp1
            sta (addr2), y          ; pointer to sprite position
        @done:
            rts
        .endproc
    .endscope

    .scope Sprite
        .proc update
            ; top left tile (x - OFFSET_2x2, y - OFFSET_2x2)
            ldx #$00
            lda player_sprite_y
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
            lda player_sprite_y
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
            lda player_sprite_y
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
            lda player_sprite_y                ; same tile as before
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

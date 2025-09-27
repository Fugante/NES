.include "../constants.asm"
.include "../io.asm"

.importzp tmp1
.importzp player_x
.importzp player_y
.importzp player_sprite_attrs
.importzp joy1_down

.import player_sprites

.code
.scope Player
    .scope Initial
        player_x = SCREEN_WIDTH / 2
        player_y = SCREEN_HEIGHT - 10
    .endscope

    .proc init
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

    .proc draw
        ; top left tile (x - OFFSET_2x2, y - OFFSET_2x2)
        ldx #$00
        lda player_y
        sec
        sbc #OFFSET_2x2             ; byte 0: y position
        sta $0204                   ; store player info in the 2nd spot of OAM RAM
        lda player_sprites,X
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
        lda player_sprites,X        ; same tile as before
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

    .proc move_player
        ; check left direction
        lda joy1_down           ; load button presses
        and #BTN_LEFT           ; filter out all but left;
        beq @check_right        ; if (A == 0) { @check_right } (left is not pressed)

        dec player_x
        jmp @check_up

    @check_right:
        lda joy1_down
        and #BTN_RIGHT
        beq @check_up           ; if (A == 0) { @check_up } (right is not pressed)

        inc player_x

    @check_up:
        lda joy1_down
        and #BTN_UP
        beq @check_down         ; if (A == 0) { @check_down } (up is not pressed)

        dec player_y
        jmp @done

    @check_down:
        lda joy1_down
        and #BTN_DOWN
        beq @done               ; if (A != 0) { @done } (down is not pressed)

        inc player_y

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
.endscope

.export draw_player
.export move_player
.export check_limits

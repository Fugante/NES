.include "../constants.asm"
.include "../io.asm"

.importzp tmp1
.importzp player_x
.importzp player_y
.importzp player_sprite_attrs
.importzp joy1

.import player_sprites

.code
.proc draw_player
    ; top left tile (x - OFFSET_2x2, y - OFFSET_2x2)
    LDX #$00
    LDA player_y
    SEC
    SBC #OFFSET_2x2             ; byte 0: y position
    STA $0204                   ; store player info in the 2nd spot of OAM RAM
    LDA player_sprites,X
    STA $0205                   ; byte 1: sprite number
    LDA player_sprite_attrs
    STA $0206                   ; byte 2: attributes
    LDA player_x
    SEC
    SBC #OFFSET_2x2
    STA $0207                   ; byte 3: x position
    ; top right tile (x, y - OFFSET_2x2)
    LDA player_y
    SEC
    SBC #OFFSET_2x2
    STA $0208
    LDA player_sprites,X        ; same tile as before
    STA $0209
    LDA player_sprite_attrs
    EOR #%01000000              ; flip sprite horizontally
    STA $020a
    LDA player_x
    STA $020b
    ; bottom left tile (x - 7, y)
    INX
    LDA player_y
    STA $020c
    LDA player_sprites,X        ; next tile
    STA $020d
    LDA player_sprite_attrs
    STA $020e
    LDA player_x
    SEC
    SBC #OFFSET_2x2
    STA $020f
    ; bottom right tile (x, y)
    LDA player_y                ; same tile as before
    STA $0210
    LDA player_sprites,X
    STA $0211
    LDA player_sprite_attrs
    EOR #%01000000              ; flip sprite horizontally
    STA $0212
    LDA player_x
    STA $0213

    RTS
.endproc

.proc move_player
    ; check left direction
    LDA joy1                ; load button presses
    AND #BTN_LEFT           ; filter out all but left;
    BEQ @check_right        ; if (A == 0) { @check_right } (left is not pressed)

    DEC player_x
    JMP @check_up

@check_right:
    LDA joy1
    AND #BTN_RIGHT
    BEQ @check_up           ; if (A == 0) { @check_up } (right is not pressed)

    INC player_x

@check_up:
    LDA joy1
    AND #BTN_UP
    BEQ @check_down         ; if (A == 0) { @check_down } (up is not pressed)

    DEC player_y
    JMP @done

@check_down:
    LDA joy1
    AND #BTN_DOWN
    BEQ @done               ; if (A != 0) { @done } (down is not pressed)

    INC player_y

@done:
    RTS
.endproc

.proc check_limits
    ; check left
    LDA player_x
    CMP #SCREEN_LEFT_LIMIT
    BCS @check_right        ; if (player_x > left limit) { @check_right }

    LDX #SCREEN_LEFT_LIMIT - 1
    STX player_x
    JMP @check_up

@check_right:
    CMP #SCREEN_RIGHT_LIMIT
    BCC @check_up           ; if (player_x < right limit) { @check_up }

    LDX #SCREEN_RIGHT_LIMIT
    STX player_x

@check_up:
    LDA player_y
    CMP #SCREEN_UPPER_LIMIT
    BCS @check_down         ; if (player_y > upper limit) { @check_down }

    LDX #SCREEN_UPPER_LIMIT
    STX player_y
    JMP @done

@check_down:
    CMP #SCREEN_LOWER_LIMIT
    BCC @done               ; if (player_y < lower limit) { @done }

    LDX #SCREEN_LOWER_LIMIT
    STX player_y

@done:
    RTS
.endproc

.export draw_player
.export move_player
.export check_limits

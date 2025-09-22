.include "io.asm"

.importzp tmp1
.importzp player_x
.importzp player_y
.importzp player_sprite_attrs
.importzp joy1

.import player

.code
.proc draw_player
    ; top left tile (x - 7, y - 7)
    LDX #$00
    LDA player_y
    SEC
    SBC #$07
    STA $0204                   ; 2nd sprite in OAM RAM
    LDA player,X
    STA $0205
    LDA player_sprite_attrs
    STA $0206
    LDA player_x
    SEC
    SBC #$07
    STA $0207
    ; top right tile (x, y - 7)
    INX
    LDA player_y
    SEC
    SBC #$07
    STA $0208
    LDA player,X
    STA $0209
    LDA player_sprite_attrs
    STA $020a
    LDA player_x
    STA $020b
    ; bottom left tile (x - 7, y)
    INX
    LDA player_y
    STA $020c
    LDA player,X
    STA $020d
    LDA player_sprite_attrs
    STA $020e
    LDA player_x
    SEC
    SBC #$07
    STA $020f
    ; bottom right tile (x, y)
    INX
    LDA player_y
    STA $0210
    LDA player,X
    STA $0211
    LDA player_sprite_attrs
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
    CMP #$10                ; left screen limit
    BCS @check_right        ; if (player_x > left limit) { @check_right }
    LDX #$0f
    STX player_x
    JMP @check_up

@check_right:
    CMP #$e0
    BCC @check_up           ; if (player_x < right limit) { @check_up }
    LDX #$e0
    STX player_x

@check_up:
    LDA player_y
    CMP #$08
    BCS @check_down         ; if (player_y > upper limit) { @check_down }
    LDX #$08
    STX player_y
    JMP @done

@check_down:
    CMP #$d4
    BCC @done               ; if (player_y < lower limit) { @done }
    LDX #$d4
    STX player_y

@done:
    ; all done, return
    RTS
.endproc

.export draw_player
.export move_player
.export check_limits

.include "../constants.asm"
.include "../io.asm"

.importzp tmp1
.importzp enemies
.importzp enemy_timer
.importzp enemy_flags
.importzp enemy_x_vels
.importzp enemy_y_vels
.importzp enemy_x_pos
.importzp enemy_y_pos
.importzp current_enemy
.importzp enemy_sprite_attrs

.import multiply

.import enemy_sprites

.proc process_enemies
    DEC enemy_timer
    LDY #$ff
@start:
    INY
    TYA
    CMP #NUM_ENEMIES
    BEQ @done           ; if (Y == NUM_ENEMIES) { @done }

    LDA enemy_flags,Y
    BPL @spawn          ; if (enemy_flags >= 0) { @spawn } enemy is inactive

@update:
    JSR move_enemy
    JSR check_enemy_limits
    JSR draw_enemy
    JMP @start

@spawn:
    LDA enemy_timer
    BNE @start          ; if (enemy_timer != 0) { @start }

    JSR spawn_enemy
    JMP @update

@done:
    RTS
.endproc

; Switch enemy status to active and set starting parameters
; -- Vars --
;   Y: enemy number (0 - NUM_ENEMIES)
.proc spawn_enemy
    LDA enemy_flags,Y
    ORA #%10000000      ; set "active" flag
    STA enemy_flags,Y
    LDA #$00
    STA enemy_x_vels,Y
    LDA #$01
    STA enemy_y_vels,Y
    LDA #$50
    STA enemy_x_pos,Y
    LDA #$10
    STA enemy_y_pos,Y
    LDA #$10            ; reset enemy timer
    STA enemy_timer

    RTS
.endproc

; Update enemy x and y coordinates
; -- Vars --
;   Y: enemy number (0 - NUM_ENEMIES)
.proc move_enemy
    TYA
    TAX
    INC enemy_y_pos,X

    RTS
.endproc

; Check if enemy within screen coordinates. Set to inactive if not
;   Y: enmey number (0 - NUM_ENEMIES)
.proc check_enemy_limits
    LDA enemy_y_pos,Y
    CMP #SCREEN_HEIGHT + OFFSET_1x1
    BCC @done               ; if (enemy_y_pos < screen height) { @done }

    LDA enemy_flags,Y
    AND #%01111111          ; turn off enemy's "active" flag
    STA enemy_flags,Y       ; stop tracking enemy if it is outside the screen

@done:
    RTS
.endproc

; Draw enemy
;   Y: enemy number (0 - NUM_ENEMIES)
.proc draw_enemy
    ; get oam address offset
    TYA
    TAX
    LDA #$04
    STA tmp1
    JSR multiply    ; multiply enemy number by 4 to find the offset
    TAX
    ; draw enemy
    LDA enemy_y_pos,Y
    SEC
    SBC #OFFSET_1x1
    STA ENEMY_SPRITE_ADDRESS,X
    INX
    LDA enemy_sprites
    STA ENEMY_SPRITE_ADDRESS,X
    INX
    LDA enemy_sprite_attrs
    STA ENEMY_SPRITE_ADDRESS,X
    INX
    LDA enemy_x_pos,Y
    SEC
    SBC #OFFSET_1x1
    STA ENEMY_SPRITE_ADDRESS,X

    RTS
.endproc

.export process_enemies

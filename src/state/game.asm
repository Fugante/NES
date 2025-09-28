.include "../constants.asm"
.include "../io.asm"

.importzp addr1
.importzp current_ppu_ctrl
.importzp current_ppu_mask
.importzp game_state
.importzp joy1_press
.importzp joy1_down
.importzp ppu_scroll_x
.importzp ppu_scroll_y
.importzp seed
.importzp tmp1

.import load_attr_table
.import load_nametable
.import load_palettes

.import attr_table_1
.import level_1
.import palette_1

.code
.scope Game
    .proc init_game
        jsr init_random
        jsr init_graphics
        rts
    .endproc

    .proc init_random
        lda #$2a
        sta seed + 1
        lda #$5E
        sta seed
        rts
    .endproc

    .proc init_graphics
        lda #<palette_1
        sta addr1
        lda #>palette_1
        sta addr1 + 1
        jsr load_palettes
        lda #<level_1
        sta addr1
        lda #>level_1
        sta addr1 + 1
        lda #$20                ; nametable 0 high byte
        sta tmp1
        jsr load_nametable
        lda #<attr_table_1
        sta addr1
        lda #>attr_table_1
        sta addr1 + 1
        lda #$23                ; attribute table 0 start address high byte
        sta tmp1
        jsr load_attr_table
        lda #$00                ; set scroll values to 0
        sta ppu_scroll_x
        lda #240
        sta ppu_scroll_y
        lda #%10010000          ; turn on NMIs, sprites use first pattern table
        sta current_ppu_ctrl
        lda #%00011110          ; turn on screen
        sta current_ppu_mask
        rts
    .endproc

    .proc pause
        lda joy1_press
        and #BTN_START
        beq @done               ; if (button start not pressed) { @done }

        and joy1_down
        beq @done               ; if (button start not down) { @done }

        lda game_state
        eor #PAUSE_FLAG         ; flip paused flag
        sta game_state
    @done:
        rts
    .endproc

.export init_game
.export pause
.endscope

.include "io.asm"

.importzp current_ppu_ctrl
.importzp current_ppu_mask
.importzp ppu_scroll_x
.importzp ppu_scroll_y
.importzp enemy_sprite_attrs
.importzp enemy_timer

.import init_game
.import init_player

.code
.proc boot
    jsr init_game
    jsr init_player
    lda #$00
    sta enemy_sprite_attrs
    lda #$01
    sta enemy_timer

@vblank_wait:
    bit PPUSTATUS
    bpl @vblank_wait

    ; enable graphics
    lda current_ppu_ctrl
    sta PPUCTRL
    lda current_ppu_mask
    sta PPUMASK
    lda ppu_scroll_x
    sta PPUSCROLL
    lda ppu_scroll_y
    sta PPUSCROLL

    rts
.endproc

.export boot

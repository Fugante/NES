.include "io.asm"

.importzp ppu_scroll_x
.importzp ppu_scroll_y
.importzp current_ppu_ctrl
.importzp current_ppu_mask
.importzp addr1
.importzp tmp1
.importzp tmp2
.importzp player_x
.importzp player_y
.importzp player_sprite_attrs

.import load_palettes
.import load_nametable
.import load_attr_table

.import palette_1
.import level_1
.import attr_table_1

.code
.proc boot
    ; initialize zero-page values
    LDA #$00                ; set scroll values to 0
    STA ppu_scroll_x
    LDA #240
    STA ppu_scroll_y
    LDA #%10010000          ; turn on NMIs, sprites use first pattern table
    STA current_ppu_ctrl
    LDA #%00011110          ; turn on screen
    STA current_ppu_mask

    ; load palettes
    LDA #<palette_1
    STA addr1
    LDA #>palette_1
    STA addr1 + 1
    JSR load_palettes

    ; load nametables
    LDA #<level_1
    STA addr1
    LDA #>level_1
    STA addr1 + 1
    LDA #$20                ; nametable 0 high byte
    STA tmp1
    JSR load_nametable

    ; load attribute tables
    LDA #<attr_table_1
    STA addr1
    LDA #>attr_table_1
    STA addr1 + 1
    LDA #$23                    ; attribute table 0 start address high byte
    STA tmp1
    JSR load_attr_table

    LDA #$80                ; middle of the x axis
    STA player_x
    LDA #$a0                ; middle of the y axis
    STA player_y
    LDA #$00                ; use palette 0
    STA player_sprite_attrs

@vblank_wait:
    BIT PPUSTATUS
    BPL @vblank_wait

    LDA current_ppu_ctrl
    STA PPUCTRL
    LDA current_ppu_mask
    STA PPUMASK
    LDA ppu_scroll_x
    STA PPUSCROLL
    LDA ppu_scroll_y
    STA PPUSCROLL

    RTS
.endproc

.export boot

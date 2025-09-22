
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
    LDA #<palettes
    STA addr1
    LDA #>palettes
    STA addr1 + 1
    JSR load_palettes

    ; load nametables
    LDA #<big_star
    STA addr1
    LDA #>big_star
    STA addr1 + 1
    LDA #$20            ; high byte of nametable 0
    STA tmp1
    LDA #$2f            ; load byte (name) of the big star tile
    STA tmp2
    JSR load_tile
    LDA #$28            ; high byte of nametable 3
    STA tmp1
    LDA #$2f            ; load byte (name) of the big star tile
    STA tmp2
    JSR load_tile

    LDA #$80                ; middle of the x axis
    STA player_x
    LDA #$a0                ; middle of the y axis
    STA player_y
    LDA #$00                ; use palette 0
    STA player_sprite_attrs


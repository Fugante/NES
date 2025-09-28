.include "../io.asm"

.importzp current_ppu_ctrl
.importzp current_ppu_mask
.importzp ppu_scroll_x
.importzp ppu_scroll_y
.importzp game_state

.code
.proc nmi
    ; save registers
    php
    pha
    txa
    pha
    tya
    pha

    ; DMA transfer: copy sprite data to OAM
    lda #$00
    sta OAMADDR
    lda #$02        ; High byte of address where the OAM buffer starts
    sta OAMDMA

    ; set PPUCTRL
    lda current_ppu_ctrl
    sta PPUCTRL

    ; set PPUMASK
    lda current_ppu_mask
    sta PPUMASK

    ; set_scroll_positions:
    bit PPUSTATUS
    lda ppu_scroll_x
    sta PPUSCROLL
    lda ppu_scroll_y
    sta PPUSCROLL

    ; revert sleeping flag to zero (working)
    lda game_state
    and #%01111111
    sta game_state

    ; restore registers
    pla
    tay
    pla
    tax
    pla
    plp

    rti
.endproc

.export nmi

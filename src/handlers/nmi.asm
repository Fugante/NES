.include "../io.asm"

.importzp current_ppu_ctrl
.importzp current_ppu_mask
.importzp ppu_scroll_x
.importzp ppu_scroll_y
.importzp game_state

.code
.proc nmi
    ; save registers
    PHP
    PHA
    TXA
    PHA
    TYA
    PHA

    ; DMA transfer: copy sprite data to OAM
    LDA #$00
    STA OAMADDR
    LDA #$02        ; High byte of address where the OAM buffer starts
    STA OAMDMA

    ; set PPUCTRL
    LDA current_ppu_ctrl
    STA PPUCTRL

    ; set PPUMASK
    LDA current_ppu_mask
    STA PPUMASK

    ; set_scroll_positions:
    BIT PPUSTATUS
    LDA ppu_scroll_x
    STA PPUSCROLL
    LDA ppu_scroll_y
    STA PPUSCROLL

    ; revert sleeping flag to zero (working)
    LDA game_state
    AND #%01111111
    STA game_state

    ; restore registers
    PLA
    TAY
    PLA
    TAX
    PLA
    PLP

    RTI
.endproc

.export nmi

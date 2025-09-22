.include "io.asm"

.importzp tmp1
.importzp tmp2
.importzp addr1

.code
; Loads a palette
;   addr1: address (high byte) of the palette (located in palettes.asm)
.proc load_palettes
    LDY #$00
    BIT PPUSTATUS           ; reset the address latch to ensure next byte is "high"
    LDA (addr1),Y           ; high byte of the PPU palettes starting address
    INY
    STA PPUADDR
    LDA (addr1),Y           ; low byte of the same address
    STA PPUADDR

    INY
    LDA (addr1),Y           ; get the number of values to load
    TAX
@load:
    INY
    LDA (addr1),Y
    STA PPUDATA
    DEX
    BNE @load               ; if (X != 0) { @load }

    RTS
.endproc

.export load_palettes

; Loads a tile to a nametable
;   addr1: address (high byte) of the tile (located in nametables.asm)
;   tmp1: high byte of the nametable to load to
;   tmp2: low byte (name) of the tile
.proc load_tile
    LDY #$00
    LDA (addr1),Y               ; load data length
    TAX
@load:
    INY
    BIT PPUSTATUS
    ; calculate high byte value (nametable start address + offset)
    LDA tmp1
    CLC
    ADC (addr1),Y
    STA PPUADDR                 ; write name address high byte
    INY
    LDA (addr1),Y
    STA PPUADDR
    LDA tmp2                    ; load tile number (name)
    STA PPUDATA
    DEX
    BNE @load                   ; if (X != 0) { @load }

    RTS
.endproc

.export load_tile

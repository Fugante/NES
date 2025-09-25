.include "../io.asm"

.importzp tmp1
.importzp tmp2
.importzp addr1
.importzp ppu_scroll_y
.importzp current_ppu_ctrl

.code
; Loads a palette
;   addr1: pointer to the palette byte array
.proc load_palettes
    BIT PPUSTATUS           ; reset the address latch to ensure next byte is "high"
    LDA #$3f                ; high byte of the PPU palettes starting address
    STA PPUADDR
    LDA #$00                ; low byte of the same address
    STA PPUADDR
    LDX #$20                ; load 4 colours * 8 palettes = 32 bytes
    LDY #$ff
@load:
    INY
    LDA (addr1),Y
    STA PPUDATA
    DEX
    BNE @load               ; if (X != 0) { @load }

    RTS
.endproc

; Loads a tile to a nametable
;   addr1: pointer to the nametable struct
;   tmp1: high byte of the nametable to load to
.proc load_nametable
    LDY #$00
    LDA (addr1),Y               ; load tile number (name)
@params:
    STA tmp2
    INY
    LDA (addr1),Y               ; load array length
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

    INY
    LDA (addr1),Y
    BEQ @done                   ; if (addr1 + Y == 0) { @done } ($00 marks the end)
    JMP @params
@done:
    RTS
.endproc

; loads an attribute table
;   tmp1: high byte of the address where the attribute table starts
;   addr1: pointer the array of 64 byte data
.proc load_attr_table
    LDY #$00
    LDX #$c0            ; low byte of the start address of any attribute table
@load:
    BIT PPUSTATUS
    LDA tmp1
    STA PPUADDR
    STX PPUADDR
    LDA (addr1),Y
    STA PPUDATA
    INY
    INX
    BNE @load           ; if (X != 0) { @load } (will be 0 after 64 loops)

    RTS
.endproc

.proc update_scroll
    LDA ppu_scroll_y
    BNE @update             ; if (ppu_scroll_y != 0) { @update }
    LDA current_ppu_ctrl    ; false: change base nametable
    EOR #%00000010          ; flip bit 1 to its oposite
    STA current_ppu_ctrl
    LDA #240                ; reset scroll to 240
    STA ppu_scroll_y
@update:
    DEC ppu_scroll_y

    RTS
.endproc

.export load_palettes
.export load_nametable
.export load_attr_table
.export update_scroll

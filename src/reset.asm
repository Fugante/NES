.include "io.asm"

.import main

.code
; init code taken from https://www.nesdev.org/wiki/Init_code
.proc reset
    SEI                 ; disable IRQs
    CLD                 ; disable decimal mode
    LDX #%01000000
    STX JOY2_APUFC      ; disable APU frame IRQ
    LDX #$ff
    TXS                 ; set up stack
    INX                 ; now X = 0
    STX PPUCTRL         ; disable NMI
    STX PPUMASK         ; disable rendering (0000000)
    STX DMC_FREQ        ; disable DMC IRQs

    ; The vblank flag is in an unknown state after reset,
    ; so it is cleared here to make sure that @vblankwait1
    ; does not exit immediately.
    BIT PPUSTATUS
    ; First of two waits for vertical blank to make sure that the
    ; PPU has stabilized
@vblank_wait1:
    BIT PPUSTATUS
    BPL @vblank_wait1

    ; We now have about 30,000 cycles to burn before the PPU stabilizes.
    ; One thing we can do with this time is put RAM in a known state.
    ; Here we fill it with $00, which matches what (say) a C compiler
    ; expects for BSS. Since we haven't modified the X register since
    ; the earlier code above, it's still set to 0, so we can just
    ; transfer it to the Accumulator and save a byte
    TXA
@clear_oam:
    STA $00,X
    STA $100,X
    STA $200,X
    STA $300,X
    STA $400,X
    STA $500,X
    STA $600,X
    STA $700,X
    INX
    BNE @clear_oam
    ; Other things you can do between vblank waits are set up audio
    ; or set up other mapper registers.

    ; second vblankwait, after this the PPU is ready
@vblank_wait2:
    BIT PPUSTATUS
    BPL @vblank_wait2

    JMP main
.endproc

.export reset

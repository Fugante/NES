; PPU high byte, low byte
; length
; palette data

.rodata
palettes:
    .byte $3f, $00              ; high byte, low byte
    .byte $20                   ; length
    ; background palettes
    .byte $0f, $12, $23, $27
    .byte $0f, $2b, $3c, $39
    .byte $0f, $0c, $07, $13
    .byte $0f, $19, $09, $29
    ; sprites palettes
    .byte $0f, $2d, $10, $15
    .byte $0f, $19, $09, $29
    .byte $0f, $19, $09, $29
    .byte $0f, $19, $09, $29

.export palettes

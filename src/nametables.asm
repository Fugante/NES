; length of the array
; offset, low byte

.rodata
big_star:
    .byte $08                   ; length of the array
    .byte $00, $6b
    .byte $01, $57
    .byte $02, $23
    .byte $03, $52

.export big_star

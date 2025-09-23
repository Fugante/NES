.include "constants.asm"

.rodata
; tile number (name)
; array length / 2
; [ (offset, low byte) ]
level_1:
    .byte $2e
    .byte $1a
    .byte $00, $15
    .byte $00, $35
    .byte $00, $36
    .byte $00, $46
    .byte $00, $49
    .byte $00, $4b
    .byte $00, $67
    .byte $00, $6a
    .byte $00, $88
    .byte $00, $a9
    .byte $01, $5c
    .byte $01, $7a
    .byte $01, $7c
    .byte $01, $7d
    .byte $01, $9b
    .byte $01, $b3
    .byte $01, $ba
    .byte $01, $bc
    .byte $01, $f2
    .byte $02, $0a
    .byte $02, $22
    .byte $02, $30
    .byte $02, $41
    .byte $02, $6c
    .byte $03, $6a
    .byte $03, $6c

    .byte $2d
    .byte $1b
    .byte $00, $3e
    .byte $00, $47
    .byte $00, $48
    .byte $00, $65
    .byte $00, $87
    .byte $00, $89
    .byte $00, $a7
    .byte $00, $b6
    .byte $00, $c4
    .byte $00, $fa
    .byte $01, $24
    .byte $01, $32
    .byte $01, $42
    .byte $01, $48
    .byte $01, $51
    .byte $01, $5d
    .byte $01, $7b
    .byte $01, $9d
    .byte $01, $a5
    .byte $01, $a9
    .byte $01, $f6
    .byte $02, $16
    .byte $02, $57
    .byte $02, $b1
    .byte $02, $ed
    .byte $03, $24
    .byte $03, $62

    .byte $2f
    .byte $0c
    .byte $00, $91
    .byte $00, $bb
    .byte $01, $0d
    .byte $01, $d1
    .byte $02, $4e
    .byte $02, $b9
    .byte $02, $c8
    .byte $02, $e1
    .byte $03, $55
    .byte $03, $5a
    .byte $03, $5e
    .byte $03, $b9

    .byte $00

.export level_1

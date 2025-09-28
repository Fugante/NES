.include "constants.asm"
.include "io.asm"

.importzp game_state
.importzp ppu_scroll_y
.importzp current_ppu_ctrl

.import boot
.import nmi
.import reset
.import pause
.import update_player
.import update_controller
.import update_scroll
.import process_enemies

.segment "HEADER"
    .byte 'N', 'E', 'S', $1a        ; the word "NES" plus newline character
    .byte $02                       ; number of 16KB PRG-ROM banks
    .byte $01                       ; number of 8KB CHR-ROM banks
    .byte %00000001                 ; horizontal mirroring, no save RAM, no mapper
    .byte %00000000                 ; no special-case flags set, no mapper
    .byte $00                       ; no PRG-RAM present
    .byte $00                       ; NTSC format
    .byte $0, $0, $0, $0, $0, $0    ; padding

.code
.proc main
    jsr boot

@main_loop:
    ; update player
    jsr update_controller
    jsr pause
    lda game_state
    and #PAUSE_FLAG
    bne @sleep              ; if (pause flag != 0) { @sleep }

    jsr update_player
    ;update enemies
    jsr process_enemies
    ; update background
    jsr update_scroll
    ; update game state
    lda game_state
    ora #%10000000          ; set sleep flag
    sta game_state
@sleep:
    lda game_state
    and #%10000000          ; filter out sleep flag
    bne @sleep              ; if (sleep flag != 0) { @sleep }

    jmp @main_loop           ; return to the main loop
.endproc

.export main

irq:
    RTI
.segment "VECTORS"
    .addr nmi
    .addr reset
    .addr irq

.segment "CHR"
.incbin "sprites.chr"

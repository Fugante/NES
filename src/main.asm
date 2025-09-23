.include "io.asm"

.importzp game_state
.importzp ppu_scroll_y
.importzp current_ppu_ctrl

.import boot
.import nmi
.import reset
.import draw_player
.import poll_controller
.import move_player
.import check_limits
.import update_scroll

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
    JSR boot

main_loop:
    JSR poll_controller
    JSR move_player
    JSR check_limits
    JSR draw_player

    JSR update_scroll

    LDA game_state
    ORA #%10000000          ; set sleep flag
    STA game_state
@sleep:
    LDA game_state
    AND #%10000000          ; filter out sleep flag
    BNE @sleep              ; if (sleep flag != 0) { @sleep }

    JMP main_loop           ; return to the main loop
.endproc
.export main

irq:
    RTI
.segment "VECTORS"
    .addr nmi
    .addr reset
    .addr irq

.segment "CHR"
.incbin "graphics.chr"

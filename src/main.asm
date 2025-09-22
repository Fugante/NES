.include "io.asm"

.importzp tmp1
.importzp tmp2
.importzp addr1
.importzp player_x
.importzp player_y
.importzp player_sprite_attrs
.importzp game_state
.importzp sleep_counter
.importzp ppu_scroll_x
.importzp ppu_scroll_y
.importzp current_ppu_ctrl
.importzp current_ppu_mask
.importzp joy1

.import nmi
.import reset
.import load_palettes
.import load_tile
.import draw_player
.import poll_controller
.import move_player
.import check_limits

.import palettes
.import big_star

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
init_ram:
    ; initialize zero-page values
    LDA #$00                ; set scroll values to 0
    STA ppu_scroll_x
    LDA #240
    STA ppu_scroll_y
    LDA #%10010000          ; turn on NMIs, sprites use first pattern table
    STA current_ppu_ctrl
    LDA #%00011110          ; turn on screen
    STA current_ppu_mask

    ; load palettes
    LDA #<palettes
    STA addr1
    LDA #>palettes
    STA addr1 + 1
    JSR load_palettes

    ; load nametables
    LDA #<big_star
    STA addr1
    LDA #>big_star
    STA addr1 + 1
    LDA #$20            ; high byte of nametable 0
    STA tmp1
    LDA #$2f            ; load byte (name) of the big star tile
    STA tmp2
    JSR load_tile
    LDA #$28            ; high byte of nametable 3
    STA tmp1
    LDA #$2f            ; load byte (name) of the big star tile
    STA tmp2
    JSR load_tile

    LDA #$80                ; middle of the x axis
    STA player_x
    LDA #$a0                ; middle of the y axis
    STA player_y
    LDA #$00                ; use palette 0
    STA player_sprite_attrs

    ; TODO move all this section to a subroutine

vblank_wait:
    BIT PPUSTATUS
    BPL vblank_wait

    LDA current_ppu_ctrl
    STA PPUCTRL
    LDA current_ppu_mask
    STA PPUMASK
    LDA ppu_scroll_x
    STA PPUSCROLL
    LDA ppu_scroll_y
    STA PPUSCROLL

main_loop:
    JSR poll_controller
    JSR move_player
    JSR check_limits
    JSR draw_player

    ; update scroll
    LDA ppu_scroll_y
    BNE @update_scroll      ; if (ppu_scroll_y != 0) { @update_scroll }
    LDA current_ppu_ctrl    ; false: change base nametable
    EOR #%00000010          ; flip bit 1 to its oposite
    STA current_ppu_ctrl
    LDA #240                ; reset scroll to 240
    STA ppu_scroll_y
@update_scroll:
    DEC ppu_scroll_y
    ; TODO move all this section to a subroutine

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

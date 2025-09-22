.include "io.asm"

.zeropage
tmp1: .res 1                ; $0000
tmp2: .res 1                ; $0001
addr1: .res 2               ; $0002 - $0003
player_x: .res 1            ; $0004
player_y: .res 1            ; $0005
player_sprite_attrs: .res 1 ; $0006
ppu_scroll_y: .res 1        ; $0007
ppu_scroll_x: .res 1        ; $0008
current_ppu_ctrl: .res 1    ; $0009
current_ppu_mask: .res 1    ; $000a
; s p - - - - - -
; | +---------------------- 0 normal, 1 paused
; +------------------------ 0 working, 1 sleeping
game_state: .res 1          ; $000b
joy1: .res 1                ; $000c

.exportzp tmp1
.exportzp tmp2
.exportzp addr1
.exportzp player_x
.exportzp player_y
.exportzp player_sprite_attrs
.exportzp ppu_scroll_x
.exportzp ppu_scroll_y
.exportzp current_ppu_ctrl
.exportzp current_ppu_mask
.exportzp game_state
.exportzp joy1

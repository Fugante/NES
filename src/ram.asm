.include "constants.asm"
.include "io.asm"

.zeropage
tmp1: .res 1                        ; $0000
tmp2: .res 1                        ; $0001
addr1: .res 2                       ; $0002 - $0003
player_x: .res 1                    ; $0004
player_y: .res 1                    ; $0005
player_sprite_attrs: .res 1         ; $0006
ppu_scroll_y: .res 1                ; $0007
ppu_scroll_x: .res 1                ; $0008
current_ppu_ctrl: .res 1            ; $0009
current_ppu_mask: .res 1            ; $000a
; s p - - - - - -
; | +------------------------------ 0 normal, 1 paused
; +-------------------------------  0 working, 1 sleeping
game_state: .res 1                  ; $000b
joy1: .res 1                        ; $000c
joy2: .res 1                        ; $000d
; enemy object pool
enemy_x_pos: .res NUM_ENEMIES       ; $000e - $0012
enemy_y_pos: .res NUM_ENEMIES       ; $0013 - $0018
enemy_x_vels: .res NUM_ENEMIES      ; $0019 - $001d
enemy_y_vels: .res NUM_ENEMIES      ; $001e - $0022
enemy_flags: .res NUM_ENEMIES       ; $0023 - $0028
current_enemy: .res 1               ; $0029
current_enemy_type: .res 1          ; $002a
enemy_timer: .res 1                 ; $002b
; player bullet pool
bullet_xs: .res NUM_BULLETS         ; $002c - $002e
bullet_ys: .res NUM_BULLETS         ; $002f - $0031

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
.exportzp joy2
.exportzp enemy_x_pos
.exportzp enemy_y_pos
.exportzp enemy_x_vels
.exportzp enemy_y_vels
.exportzp enemy_flags
.exportzp current_enemy
.exportzp current_enemy_type
.exportzp enemy_timer
.exportzp bullet_xs
.exportzp bullet_ys
